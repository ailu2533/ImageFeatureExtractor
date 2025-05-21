//
//  ClothingClassifier.swift
//  LemonThingsManager
//
//  Created by ailu on 2024/7/28.
//

import Accelerate
import CoreML
import Foundation
import UIKit

// MARK: - ClothingClassifier

public actor ClothingClassifier {
    // MARK: Lifecycle

    private init(loadTextEmbeddingFromJson: Bool) throws {
        // 初始化textEncoder
        if loadTextEmbeddingFromJson {
            textEncoder = nil
        } else {
            textEncoder = try TextEncoder()
        }

        // 初始化imgEncoder
        imgEncoder = try ImgEncoder()

        guard let textEmbeddingURL = Bundle.module.url(forResource: "categoryEmbedding", withExtension: "json") else {
            throw ImageLoadError.invalidData
        }

        // 从JSON文件中读取文本嵌入数据
        do {
            let data = try Data(contentsOf: textEmbeddingURL)
            let embeddingsArrays = try JSONDecoder().decode([String: [Float]].self, from: data)

            var tmpLabels: [String] = []
            var tmpEmbeddings: [MLShapedArray<Float32>] = []

            for (key, array) in embeddingsArrays {
                tmpLabels.append(key)
                let embedding = MLShapedArray<Float32>(scalars: array.map { Float32($0) }, shape: [1, array.count])
                tmpEmbeddings.append(embedding)
            }

            labels = tmpLabels
            labelEmbeddings = tmpEmbeddings
        }
    }

    // MARK: Public

    // MARK: - Factory Method

    public static func create(loadTextEmbeddingFromJson: Bool) async throws -> ClothingClassifier {
        return try await Task.detached(priority: .userInitiated) {
            try ClothingClassifier(loadTextEmbeddingFromJson: loadTextEmbeddingFromJson)
        }.value
    }

    // MARK: Private

    private let textEncoder: TextEncoder?
    private let imgEncoder: ImgEncoder
    private let labels: [String]
    private let labelEmbeddings: [MLShapedArray<Float32>]
}

// MARK: - PredictResult

struct PredictResult {
    let label: String
    let cos: Float
}

extension ClothingClassifier {
    public func predictTopNLabels(image: UIImage, topN: Int) async throws -> [CategoryLabel] {
        // 使用灰度图
        guard let normalImage = image.removeTransparency() else {
            return []
        }

        let imgEmbedding = try await imgEncoder.computeImgEmbedding(img: normalImage)

        // 计算所有标签的相似度
        let scores = calculateSimilarityScores(
            imageEmbedding: imgEmbedding,
            labelEmbeddings: labelEmbeddings,
            labels: labels
        )

        // 计算概率分布
        let probabilities = calculateProbabilities(from: scores)

        // 获取前N个最可能的标签
        return getTopNLabels(from: probabilities, count: topN)
    }

    // MARK: - Private Methods

    private func calculateSimilarityScores(
        imageEmbedding: MLShapedArray<Float32>,
        labelEmbeddings: [MLShapedArray<Float32>],
        labels: [String]
    ) -> [PredictResult] {
        zip(labelEmbeddings, labels).map { embedding, label in
            let similarity = similarity_score(
                text_features: embedding,
                image_features: imageEmbedding
            )
            return PredictResult(label: label, cos: similarity)
        }
    }

    private func calculateProbabilities(from scores: [PredictResult]) -> [CategoryLabel] {
        let similarityValues = scores.map(\.cos)
        let softmaxValues = softmax(inputs: similarityValues)

        return zip(softmaxValues, scores).map { probability, result in
            CategoryLabel(
                label: result.label,
                probability: probability
            )
        }
    }

    private func getTopNLabels(
        from probabilities: [CategoryLabel],
        count: Int
    ) -> [CategoryLabel] {
        probabilities
            .sorted { $0.probability > $1.probability }
            .prefix(count)
            .map { $0 }
    }

    private func cosine_similarity(A: MLShapedArray<Float32>, B: MLShapedArray<Float32>) -> Float {
        let magnitude = vDSP.sumOfSquares(A.scalars).squareRoot() * vDSP.sumOfSquares(B.scalars).squareRoot()
        let dotarray = vDSP.dot(A.scalars, B.scalars)
        return dotarray / magnitude
    }

    private func similarity_score(text_features: MLShapedArray<Float32>, image_features: MLShapedArray<Float32>) -> Float {
        // 归一化图像特征
        let normalizedImageFeatures = normalize(image_features)

        // 归一化文本特征
        let normalizedTextFeatures = normalize(text_features)

        // 计算点积
        let dotProduct = vDSP.dot(normalizedImageFeatures.scalars, normalizedTextFeatures.scalars)

        return dotProduct * 100
    }

    // 归一化函数
    private func normalize(_ features: MLShapedArray<Float32>) -> MLShapedArray<Float32> {
        let norm = sqrt(vDSP.sumOfSquares(features.scalars))
        return MLShapedArray(scalars: features.scalars.map { $0 / norm }, shape: features.shape)
    }
}

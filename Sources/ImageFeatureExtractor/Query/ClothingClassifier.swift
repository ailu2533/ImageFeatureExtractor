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

public final class ClothingClassifier: Sendable {
    private let textEncoder: TextEncoder?
    private let imgEncoder: ImgEncoder
    private let labels: [String]
    private let labelEmbeddings: [MLShapedArray<Float32>]

    public init(loadTextEmbeddingFromJson: Bool) {
        do {
            if loadTextEmbeddingFromJson {
                textEncoder = nil
            } else {
                textEncoder = try TextEncoder()
            }

            imgEncoder = try ImgEncoder()
        } catch {
            fatalError("初始化编码器失败: \(error)")
        }

        labels = ClothingCatalog.labels

        if loadTextEmbeddingFromJson {
            guard let textEmbeddingURL = Bundle.module.url(forResource: "textEmbedding", withExtension: "json")
            else {
                fatalError("textEmbedding.json not found")
            }

            // 从JSON文件中读取文本嵌入数据
            do {
                let data = try Data(contentsOf: textEmbeddingURL)
                let embeddingsArrays = try JSONDecoder().decode([[Float]].self, from: data)
                labelEmbeddings = embeddingsArrays.map { array in
                    MLShapedArray<Float32>(scalars: array.map { Float32($0) }, shape: [1, array.count])
                }
            } catch {
                fatalError("Failed to load or decode text embeddings: \(error)")
            }
        } else {
            // 使用本地变量来初始化 labelEmbeddings

            let textEncoder = self.textEncoder!
            labelEmbeddings = labels.compactMap { label in
                try? textEncoder.computeTextEmbedding(prompt: label)
            }

            // 将 labelEmbeddings 转换为可序列化的格式并序列化为 JSON
            let embeddingsAsArrays = labelEmbeddings.map { $0.scalars }
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(embeddingsAsArrays),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON String: \(jsonString)")
            }
        }
    }

    public static func loadAsync(loadTextEmbeddingFromJson: Bool) async -> ClothingClassifier {
        return await Task {
            return ClothingClassifier(loadTextEmbeddingFromJson: loadTextEmbeddingFromJson)
        }.value
    }

    func predictLabel(image: UIImage) async throws -> String {
        let imgEmbedding = try await imgEncoder.computeImgEmbedding(img: image)

        let cosines = await withTaskGroup(of: (Float, String).self) { group in
            for (embedding, label) in zip(labelEmbeddings, labels) {
                group.addTask { [self] in
                    let cos = similarity_score(text_features: embedding, image_features: imgEmbedding)
                    return (cos, label)
                }
            }
            return await group.reduce(into: [(Float, String)]()) { $0.append($1) }
        }

        // 提取余弦相似度值
        let cosineValues = cosines.map { $0.0 }

        // 计算 softmax
        let softmaxValues = softmax(inputs: cosineValues)

        // 将 softmax 值与标签配对
        let labelProbabilities = zip(softmaxValues, cosines.map { $0.1 })

        print(labelProbabilities)

        // 找到最高概率的标签
        if let (maxProb, maxLabel) = labelProbabilities.max(by: { $0.0 < $1.0 }) {
            // 如果最高概率大于 0.7，返回该标签，否则返回"未知"
            return maxProb > 0.9 ? maxLabel : "\(maxLabel) \(maxProb)"
        }

        return "未知"
    }

    public func predictTopNLabels(image: UIImage, topN: Int) async throws -> [CategoryLabel] {
        guard let normalImage = image.removeTransparency() else {
            return []
        }

        let imgEmbedding = try await imgEncoder.computeImgEmbedding(img: normalImage)

        let scores = await withTaskGroup(of: (Float, String).self) { group in
            for (embedding, label) in zip(labelEmbeddings, labels) {
                group.addTask { [self] in
                    let cos = similarity_score(text_features: embedding, image_features: imgEmbedding)
                    return (cos, label)
                }
            }
            return await group.reduce(into: [(Float, String)]()) { $0.append($1) }
        }

        // 提取相似度值
        let similarityValues = scores.map { $0.0 }

        // 计算 softmax
        let softmaxValues = softmax(inputs: similarityValues)

        // 将 softmax 值与标签配对
        let labelProbabilities = zip(softmaxValues, scores.map { $0.1 })
            .map { CategoryLabel(label: $0.1, probability: $0.0) }

        // 按概率排序并返回前 N 个标签
        return Array(labelProbabilities.sorted(by: { $0.probability > $1.probability }).prefix(topN))
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
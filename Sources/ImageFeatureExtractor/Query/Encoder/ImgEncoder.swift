//
//  ImgEncoder.swift
//  TestEncoder
//
//  Created by Ke Fang on 2022/12/08.
//

import CoreML
import Foundation
import UIKit

// MARK: - ImgEncoder

public struct ImgEncoder {
    // MARK: Lifecycle

    init(configuration config: MLModelConfiguration = .init()) throws {
        let imgEncoderModel = try ImageEncoder_float32(configuration: config)
        model = imgEncoderModel
    }

    // MARK: Public

    public func computeImgEmbedding(img: UIImage) async throws -> MLShapedArray<Float32> {
        let imgEmbedding = try await encode(image: img)
        return imgEmbedding
    }

    // MARK: Internal

    var model: ImageEncoder_float32

    // MARK: Private

    private func encode(image: UIImage) async throws -> MLShapedArray<Float32> {
        do {
            guard let resizedImage = try image.resizeImageTo(size: CGSize(width: 256, height: 256)) else {
                throw ImageEncodingError.resizeError
            }

            guard let buffer = resizedImage.convertToBuffer() else {
                throw ImageEncodingError.bufferConversionError
            }

            let result = try model.prediction(colorImage: buffer)
            guard let embeddingFeature = result.featureValue(for: "embOutput"),
                  let multiArray = embeddingFeature.multiArrayValue else {
                throw ImageEncodingError.predictionError
            }

            return MLShapedArray<Float32>(converting: multiArray)
        } catch {
            print("Error in encoding: \(error)")
            throw error
        }
    }
}

// MARK: - ImageEncodingError

// Define the custom errors
enum ImageEncodingError: Error {
    case resizeError
    case bufferConversionError
    case featureProviderError
    case predictionError
}

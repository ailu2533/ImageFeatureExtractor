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

    public func encode(image: UIImage) async throws -> MLShapedArray<Float32> {
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
    }

    // MARK: Internal

    var model: ImageEncoder_float32
}

// MARK: - ImageEncodingError

// Define the custom errors
enum ImageEncodingError: LocalizedError {
    case resizeError
    case bufferConversionError
    case featureProviderError
    case predictionError

    case fileNotFound(URL)
    case invalidImageData
    case transparencyRemovalFailed
    case encodingFailed(Error)

    // MARK: Internal

    var errorDescription: String? {
        switch self {
        case let .fileNotFound(url):
            return "无法找到图片文件：\(url.path)"
        case .invalidImageData:
            return "图片数据无效或损坏"
        case .transparencyRemovalFailed:
            return "无法处理图片透明度"
        case let .encodingFailed(error):
            return "图片编码失败：\(error.localizedDescription)"
        case .resizeError:
            return "图片调整大小失败"
        case .bufferConversionError:
            return "图片缓冲区转换失败"
        case .featureProviderError:
            return "特征提取失败"
        case .predictionError:
            return "模型预测失败"
        }
    }

    // 添加错误恢复建议
    var recoverySuggestion: String? {
        switch self {
        case .fileNotFound:
            return "请检查文件路径是否正确，确保文件存在"
        case .invalidImageData:
            return "请确保图片格式正确且未损坏，支持的格式包括：JPEG、PNG"
        case .transparencyRemovalFailed:
            return "请尝试使用不包含透明度的图片，或确保图片格式正确"
        case .encodingFailed:
            return "请检查图片大小和格式是否符合要求，建议使用小于 4MB 的图片"
        case .resizeError:
            return "请确保图片尺寸合理，建议使用 224x224 或更小的图片"
        case .bufferConversionError:
            return "请确保图片格式正确，建议使用 RGB 格式的图片"
        case .featureProviderError:
            return "请确保图片预处理正确，检查图片是否为空"
        case .predictionError:
            return "请确保模型加载正确，检查系统内存是否充足"
        }
    }
}

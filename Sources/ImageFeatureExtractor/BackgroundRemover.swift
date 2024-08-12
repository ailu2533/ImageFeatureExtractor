//
//  File.swift
//  ImageFeatureExtractor
//
//  Created by ailu on 2024/8/6.
//

import Foundation
import UIKit

extension CIImage: @unchecked Sendable {}

public final class BackgroundRemover: Sendable {
    public init() {}

    public func processImageToUIImage(_ image: UIImage) async throws -> UIImage {
        #if targetEnvironment(simulator)
            return image
        #endif

        guard let cgImage = image.cgImage else {
            throw BackgroundRemoverError.invalidImageData
        }

        let ciImage = CIImage(cgImage: cgImage)

        return try await Task.detached(priority: .userInitiated) {
            let visionHelper = ImageVisionHelper()
            guard let maskedImage = visionHelper.removeBackground(from: ciImage, croppedToInstanceExtent: true) else {
                throw BackgroundRemoverError.processingFailed
            }

            let renderedCGImage = visionHelper.render(ciImage: maskedImage)
            return UIImage(cgImage: renderedCGImage)
        }.value
    }

    public func processImageToPNGData(_ image: UIImage) async throws -> Data? {
        #if targetEnvironment(simulator)
            return image.pngData()
        #endif

        guard let cgImage = image.cgImage else {
            throw BackgroundRemoverError.invalidImageData
        }

        let ciImage = CIImage(cgImage: cgImage)

        return try await Task.detached(priority: .userInitiated) {
            let visionHelper = ImageVisionHelper()
            guard let maskedImage = visionHelper.removeBackground(from: ciImage, croppedToInstanceExtent: true) else {
//                throw BackgroundRemoverError.processingFailed
                // TODO: 待优化
                return image.pngData()
            }

            let renderedCGImage = visionHelper.render(ciImage: maskedImage)
            return UIImage(cgImage: renderedCGImage).pngData()
        }.value
    }
}

// MARK: - Error Types

public enum ImageLoadError: Error, LocalizedError {
    case invalidData
    case loadFailed(Error)
    case processingFailed(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return "无法加载图片数据"
        case let .loadFailed(error):
            return "加载图片失败: \(error.localizedDescription)"
        case let .processingFailed(error):
            return "处理图片失败: \(error.localizedDescription)"
        }
    }
}

enum BackgroundRemoverError: Error {
    case invalidImageData
    case processingFailed
}

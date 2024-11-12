//
//  File.swift
//  ImageFeatureExtractor
//
//  Created by ailu on 2024/8/6.
//

import Foundation
import UIKit

extension CIImage: @unchecked @retroactive Sendable {}

public final class BackgroundRemover: Sendable {
    // MARK: Lifecycle

    public init() {}

    // MARK: Public

    public func removeBackground(_ image: UIImage) throws -> UIImage {
        #if targetEnvironment(simulator)
            return image
        #endif

        guard let cgImage = image.cgImage else {
            throw BackgroundRemoverError.invalidImageData
        }

        let ciImage = CIImage(cgImage: cgImage)

        guard let maskedImage = ImageVisionHelper.createMask(from: ciImage, croppedToInstanceExtent: true) else {
            throw BackgroundRemoverError.processingFailed
        }

        let context = CIContext(options: nil)

        guard let renderedCGImage = context.createCGImage(maskedImage, from: maskedImage.extent) else {
            fatalError("failed to render CIImage")
        }

        return UIImage(cgImage: renderedCGImage, scale: image.scale, orientation: image.imageOrientation)
    }
}

// MARK: - Error Types

enum BackgroundRemoverError: Error {
    case invalidImageData
    case processingFailed
}

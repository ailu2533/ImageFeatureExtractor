//
//  UIImage+grayscale.swift
//  LemonThingsManager
//
//  Created by ailu on 2024/7/30.
//

import UIKit

extension UIImage {
    func convertToGrayScale() -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }

        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(0.0, forKey: kCIInputSaturationKey)

        guard let outputImage = filter?.outputImage else { return nil }

        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }
}

extension UIImage {
    func removeTransparency() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        draw(at: .zero)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


extension UIImage {
    var hasAlphaChannel: Bool {
        guard let alphaInfo = cgImage?.alphaInfo else { return false }
        return alphaInfo != .none && alphaInfo != .noneSkipLast && alphaInfo != .noneSkipFirst
    }
}


//public extension UIImage {
//    // Helper function to generate thumbnail data
//    func thumbnailData(maxThumbnailHeight: CGFloat = 80, maxThumbnailWidth: CGFloat = 80, format: ImageFormat = .png) -> Data? {
//        // Check if the original image is smaller than the required thumbnail size
//        guard size.width > maxThumbnailWidth || size.height > maxThumbnailHeight else {
//            return format == .png ? pngData() : jpegData(compressionQuality: 0.9)
//        }
//
//        // Calculate the scale ratio while maintaining the aspect ratio
//        let widthRatio = maxThumbnailWidth / size.width
//        let heightRatio = maxThumbnailHeight / size.height
//        let scale = min(widthRatio, heightRatio)
//
//        // Define the new size based on the scale ratio
//        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
//
//        // Use UIGraphicsImageRenderer for high-quality scaling
//        let renderer = UIGraphicsImageRenderer(size: newSize)
//        let thumbnail = renderer.image { _ in
//            draw(in: CGRect(origin: .zero, size: newSize))
//        }
//
//        // Return the image data based on the specified format
//        switch format {
//        case .png:
//            return thumbnail.pngData()
//        case .jpeg:
//            return thumbnail.jpegData(compressionQuality: 0.9) // Adjust compression quality as needed
//        }
//    }
//
//    enum ImageFormat {
//        case png
//        case jpeg
//    }
//}

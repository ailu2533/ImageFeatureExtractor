//
//  ImageFeatureExtractor.swift
//  LemonThingsManager
//
//  Created by ailu on 2024/8/5.
//

import CustomColor
import Foundation
import LemonUtils
import UIKit

public struct ImagePairWithID: Sendable, Identifiable {
    let uuid = UUID()
    // 这个是remove background后的图片
    public let noBackgroundImage: UIImage
    // 有background的图片
    public let originalImage: UIImage

    public var id: UUID {
        return uuid
    }

    public init(noBackgroundImage: UIImage, originalImage: UIImage) {
        self.noBackgroundImage = noBackgroundImage
        self.originalImage = originalImage
    }
}

public struct ImageFeature: Sendable, Identifiable {
    public let imageUUID: UUID
    public let thumbnailData: Data?
    public let bigImageData: Data?

    public let colorHexCode: String?

    // 分类信息
    public let categoryLabel: CategoryLabel?
    public let secondaryCategoryUUID: UUID?

    public var id: UUID {
        return imageUUID
    }

    init(imageUUID: UUID, thumbnailData: Data?, bigImageData: Data?, colorHexCode: String?, categoryLabel: CategoryLabel?, secondaryCategoryUUID: UUID?) {
        self.imageUUID = imageUUID
        self.thumbnailData = thumbnailData
        self.bigImageData = bigImageData
        self.colorHexCode = colorHexCode
        self.categoryLabel = categoryLabel
        self.secondaryCategoryUUID = secondaryCategoryUUID
    }
}

public struct ImageFeatureOptions: Sendable {
    public let includeThumbnail: Bool
    public let includeBigImage: Bool
    public let includeColorInfo: Bool
    public let includeCategory: Bool
    public let classifier: ClothingClassifier?

    private init(builder: Builder) {
        includeThumbnail = builder.includeThumbnail
        includeBigImage = builder.includeBigImage
        includeColorInfo = builder.includeColorInfo
        includeCategory = builder.includeCategory
        classifier = builder.classifier
    }

    public class Builder {
        private(set) var includeThumbnail = false
        private(set) var includeBigImage = false
        private(set) var includeColorInfo = false
        private(set) var includeCategory = false
        private(set) var classifier: ClothingClassifier?

        public init() {}

        @discardableResult
        public func includeThumbnail(_ include: Bool = true) -> Self {
            includeThumbnail = include
            return self
        }

        @discardableResult
        public func includeBigImage(_ include: Bool = true) -> Self {
            includeBigImage = include
            return self
        }

        @discardableResult
        public func includeColorInfo(_ include: Bool = true) -> Self {
            includeColorInfo = include
            return self
        }

        @discardableResult
        public func includeCategory(with classifier: ClothingClassifier) -> Self {
            includeCategory = true
            self.classifier = classifier
            return self
        }

        public func build() -> ImageFeatureOptions {
            ImageFeatureOptions(builder: self)
        }
    }
}

public struct ImageFeatureExtractor: Sendable {
    public init() {
    }

    public func execute(images: [ImagePairWithID], options: ImageFeatureOptions, classifier: ClothingClassifier? = nil) async -> [ImageFeature] {
        await withTaskGroup(of: ImageFeature.self) { group in
            for imageAndUUID in images {
                group.addTask { [imageAndUUID] in
                    await processImage(imageAndUUID, options: options)
                }
            }
            return await group.reduce(into: []) { $0.append($1) }
        }
    }

    private func processImage(_ imagePairWithID: ImagePairWithID, options: ImageFeatureOptions) async -> ImageFeature {
        let noBackgroundImage = imagePairWithID.noBackgroundImage

        var originalData: Data?
        if options.includeBigImage {
            originalData = noBackgroundImage.hasAlphaChannel ? noBackgroundImage.pngData() : noBackgroundImage.jpegData(compressionQuality: 0.8)
        }

        var thumbnailData: Data?
        if options.includeThumbnail {
            thumbnailData = noBackgroundImage.thumbnailData()
        }

        var colorHexCode: String?
        if options.includeColorInfo {
            let colorMatchResult = await ColorMatcher.extractDominantColor(from: noBackgroundImage)
            colorHexCode = colorMatchResult.predictColor?.hex
        }

        var categoryLabel: CategoryLabel?
        var categorySecondaryUUID: UUID?

        if options.includeCategory {
            guard let classifier = options.classifier else {
                fatalError("classifier is nil")
            }

            do {
                let labels = try await classifier.predictTopNLabels(image: imagePairWithID.originalImage, topN: 1)
                if let label = labels.first {
                    categoryLabel = label
                    categorySecondaryUUID = ClothingCatalog.label2CategoryUUID[label.label, default: otherCategorySubUUID]
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }

        return ImageFeature(
            imageUUID: imagePairWithID.id,
            thumbnailData: thumbnailData,
            bigImageData: originalData,
            colorHexCode: colorHexCode,
            categoryLabel: categoryLabel,
            secondaryCategoryUUID: categorySecondaryUUID
        )
    }
}

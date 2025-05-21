//
//  ImageFeatureExtractor.swift
//  LemonThingsManager
//
//  Created by ailu on 2024/8/5.
//

import CustomColor
import Foundation

// import LemonUtils
import UIKit

public struct ImageFeatureExtractor: Sendable {
    // MARK: Lifecycle

    public init() {}

    // MARK: Public

    public func execute(images: [ImagePairWithID], options: ImageFeatureOptions, classifier _: ClothingClassifier? = nil) async -> [ImageFeature] {
        await withTaskGroup(of: ImageFeature.self) { group in
            for imageAndUUID in images {
                group.addTask { [imageAndUUID] in
                    await processImage(imageAndUUID, options: options)
                }
            }
            return await group.reduce(into: []) { $0.append($1) }
        }
    }

    // MARK: Private

    private func processImage(_ imagePairWithID: ImagePairWithID, options: ImageFeatureOptions) async -> ImageFeature {
        let noBackgroundImage = imagePairWithID.noBackgroundImage

        var customColor: CustomColor?
        if options.includeColorInfo {
            let colorMatchResult = await ColorMatcher.extractDominantColor(from: noBackgroundImage)
            customColor = colorMatchResult.predictColor
        }

        var categorySecondaryUUID: UUID?

        if options.includeCategory {
            guard let classifier = options.classifier else {
                fatalError("classifier is nil")
            }

            do {
                let labels = try await classifier.predictTopNLabels(image: imagePairWithID.originalImage, topN: 1)
                if let label = labels.first {
                    categorySecondaryUUID = ClothingCatalog.label2CategoryUUID[label.label, default: otherCategorySubUUID]
                } else {
                    print("error predictTopNLabels")
                }

                print("processImage \(labels)")
            } catch {
                fatalError(error.localizedDescription)
            }
        }

        return ImageFeature(
            imageUUID: imagePairWithID.id,
            thumbnailData: nil,
            bigImageData: nil,
            colorHexCode: customColor,
            categoryLabel: nil,
            secondaryCategoryUUID: categorySecondaryUUID
        )
    }
}

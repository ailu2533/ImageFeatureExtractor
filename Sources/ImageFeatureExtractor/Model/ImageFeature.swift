//
//  ImageFeature.swift
//  ImageFeatureExtractor
//
//  Created by Lu Ai on 2024/10/23.
//

import CustomColor
import Foundation

public struct ImageFeature: Sendable, Identifiable {
    // MARK: Lifecycle

    init(
        imageUUID: UUID,
        thumbnailData: Data?,
        bigImageData: Data?,
        colorHexCode: CustomColor?,
        categoryLabel: CategoryLabel?,
        secondaryCategoryUUID: UUID?
    ) {
        self.imageUUID = imageUUID
        self.thumbnailData = thumbnailData
        self.bigImageData = bigImageData
        self.colorHexCode = colorHexCode
        self.categoryLabel = categoryLabel
        self.secondaryCategoryUUID = secondaryCategoryUUID
    }

    // MARK: Public

    public let imageUUID: UUID
    public let thumbnailData: Data?
    public let bigImageData: Data?

    public let colorHexCode: CustomColor?

    // 分类信息
    public let categoryLabel: CategoryLabel?
    public let secondaryCategoryUUID: UUID?

    public var id: UUID {
        imageUUID
    }
}

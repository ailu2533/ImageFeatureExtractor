//
//  ImagePairWithID.swift
//  ImageFeatureExtractor
//
//  Created by Lu Ai on 2024/10/23.
//

import UIKit

public struct ImagePairWithID: Sendable, Identifiable {
    // MARK: Lifecycle

    public init(uuid: UUID, noBackgroundImage: UIImage, originalImage: UIImage) {
        self.uuid = uuid
        self.noBackgroundImage = noBackgroundImage
        self.originalImage = originalImage
    }

    // MARK: Public

    // 这个是remove background后的图片
    public let noBackgroundImage: UIImage
    // 有background的图片
    public let originalImage: UIImage

    public var id: UUID {
        uuid
    }

    // MARK: Internal

    let uuid: UUID
}

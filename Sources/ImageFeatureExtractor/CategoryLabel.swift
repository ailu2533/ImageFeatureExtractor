//
//  File.swift
//  ImageFeatureExtractor
//
//  Created by ailu on 2024/8/6.
//

import Foundation

public struct CategoryLabel: Identifiable, Sendable {
    public let label: String
    public let displayLabel: String
    public let probability: Float

    public var id: String {
        "\(label)_\(probability)"
    }

    public init(label: String, probability: Float) {
        self.label = label
        displayLabel = ClothingCatalog.localizedLabel(label)
        self.probability = probability
    }
}

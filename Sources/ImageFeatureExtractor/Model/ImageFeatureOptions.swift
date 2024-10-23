//
//  ImageFeatureOptions.swift
//  ImageFeatureExtractor
//
//  Created by Lu Ai on 2024/10/23.
//

public struct ImageFeatureOptions: Sendable {
    // MARK: Lifecycle

    private init(builder: Builder) {
        includeThumbnail = builder.includeThumbnail
        includeBigImage = builder.includeBigImage
        includeColorInfo = builder.includeColorInfo
        includeCategory = builder.includeCategory
        classifier = builder.classifier
    }

    // MARK: Public

    public class Builder {
        // MARK: Lifecycle

        public init() {}

        // MARK: Public

        public func includeThumbnail(_ include: Bool = true) -> Self {
            includeThumbnail = include
            return self
        }

        public func includeBigImage(_ include: Bool = true) -> Self {
            includeBigImage = include
            return self
        }

        public func includeColorInfo(_ include: Bool = true) -> Self {
            includeColorInfo = include
            return self
        }

        public func includeCategory(with classifier: ClothingClassifier) -> Self {
            includeCategory = true
            self.classifier = classifier
            return self
        }

        public func build() -> ImageFeatureOptions {
            ImageFeatureOptions(builder: self)
        }

        // MARK: Internal

        private(set) var includeThumbnail = false
        private(set) var includeBigImage = false
        private(set) var includeColorInfo = false
        private(set) var includeCategory = false
        private(set) var classifier: ClothingClassifier?
    }

    public let includeThumbnail: Bool
    public let includeBigImage: Bool
    public let includeColorInfo: Bool
    public let includeCategory: Bool
    public let classifier: ClothingClassifier?
}

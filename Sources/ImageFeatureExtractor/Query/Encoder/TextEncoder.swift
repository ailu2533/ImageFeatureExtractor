// For licensing see accompanying LICENSE.md file.
// Copyright (C) 2022 Apple Inc. All Rights Reserved.

import CoreML
import Foundation

#if os(iOS)
    import UIKit
#endif

// MARK: - TextEncoder

// extension TextEncoder_float32: @unchecked Sendable {}

///  A model for encoding text
public struct TextEncoder {
    // MARK: Lifecycle

    init(
        configuration config: MLModelConfiguration = .init()
    ) throws {
//        let textEncoderURL = baseURL.appending(path: "TextEncoder_float32.mlmodelc")

        guard let vocabURL = Bundle.module.url(forResource: "vocab", withExtension: "json"),
              let mergesURL = Bundle.module.url(forResource: "merges", withExtension: "txt")
        else {
            fatalError()
        }

//        #if os(iOS)
//            // Fallback to CPU only to avoid NN compute error on iPhone < 11 and iPad < 9th gen
//            if !UIDevice.chipIsA13OrLater() {
//        config.computeUnits = .cpuOnly
//            }
//        #endif

        // Text tokenizer and encoder
//        let tokenizer = CLIPTokenizer(vocabulary: vocabURL.path(), merges: mergesURL.path())
        model = try TextEncoder_float32(configuration: config)

        clipTokenizer = CLIPTokenizer(vocabulary: vocabURL.path(), merges: mergesURL.path())
    }

    // MARK: Internal

    /// Text tokenizer
//    let tokenizer: BPETokenizer

    let clipTokenizer: CLIPTokenizer

    /// Embedding model
    let model: TextEncoder_float32

    let inputLength = 77

    // MARK: Private

    private func encode(ids: [Int32]) throws -> MLShapedArray<Float32> {
        let inputArray = MLShapedArray<Int32>(scalars: ids, shape: [1, inputLength])

        let result = try model.prediction(prompt: inputArray)

        return result.embOutputShapedArray
    }

    /// Encode input text/string
    ///
    ///  - Parameters:
    ///     - text: Input text to be tokenized and then embedded
    ///  - Returns: Embedding representing the input text
    private func encode(_ text: String) throws -> MLShapedArray<Float32> {
        let ids = clipTokenizer.tokenize(text: text, truncation: true, maxLength: inputLength, paddingToken: 0)

        // Use the model to generate the embedding
        return try encode(ids: ids)
    }
}

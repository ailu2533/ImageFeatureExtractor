// For licensing see accompanying LICENSE.md file.
// Copyright (C) 2022 Apple Inc. All Rights Reserved.

import CoreML
import Foundation

#if os(iOS)
    import UIKit
#endif

extension TextEncoder_float32: @unchecked Sendable {}

///  A model for encoding text
public struct TextEncoder: @unchecked Sendable {
    /// Text tokenizer
//    let tokenizer: BPETokenizer

    let clipTokenizer: CLIPTokenizer

    /// Embedding model
    let model: TextEncoder_float32

    let inputLength = 77

    /// Prediction queue
    let queue = DispatchQueue(label: "textencoder.predict")

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

    public func computeTextEmbedding(prompt: String) throws -> MLShapedArray<Float32> {
        let promptEmbedding = try encode(prompt)
//        Logging.shared.debug("\(prompt) \(promptEmbedding)")
        return promptEmbedding
    }

    /**
     /// Creates text encoder which embeds a tokenized string
     ///
     /// - Parameters:
     ///   - tokenizer: Tokenizer for input text
     ///   - model: Model for encoding tokenized text
     public init(tokenizer: BPETokenizer, model: MLModel) {
         self.tokenizer = tokenizer
         self.model = model
     }
      */

    /// Encode input text/string
    ///
    ///  - Parameters:
    ///     - text: Input text to be tokenized and then embedded
    ///  - Returns: Embedding representing the input text
    private func encode(_ text: String) throws -> MLShapedArray<Float32> {
        let ids = clipTokenizer.tokenize(text: text, truncation: true, maxLength: inputLength, paddingToken: 0)

        print(text, ids)

        // Use the model to generate the embedding
        return try encode(ids: ids)
    }

    func encode(ids: [Int32]) throws -> MLShapedArray<Float32> {
//        let floatIds = ids.map { Int32($0) }
        let inputArray = MLShapedArray<Int32>(scalars: ids, shape: [1, inputLength])

//        print(inputArray)
        let result = try queue.sync { try model.prediction(prompt: inputArray) }

        return result.embOutputShapedArray
    }
}

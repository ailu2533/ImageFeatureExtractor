//
// TextEncoder_float32.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
public class TextEncoder_float32Input : MLFeatureProvider {

    /// prompt as 1 by 77 matrix of 32-bit integers
    public var prompt: MLMultiArray

    public var featureNames: Set<String> { ["prompt"] }

    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "prompt" {
            return MLFeatureValue(multiArray: prompt)
        }
        return nil
    }

    public init(prompt: MLMultiArray) {
        self.prompt = prompt
    }

    public convenience init(prompt: MLShapedArray<Int32>) {
        self.init(prompt: MLMultiArray(prompt))
    }

}


/// Model Prediction Output Type
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
public class TextEncoder_float32Output : MLFeatureProvider {

    /// Source provided by CoreML
    private let provider : MLFeatureProvider

    /// embOutput as 1 by 512 matrix of floats
    public var embOutput: MLMultiArray {
        provider.featureValue(for: "embOutput")!.multiArrayValue!
    }

    /// embOutput as 1 by 512 matrix of floats
    public var embOutputShapedArray: MLShapedArray<Float> {
        MLShapedArray<Float>(embOutput)
    }

    public var featureNames: Set<String> {
        provider.featureNames
    }

    public func featureValue(for featureName: String) -> MLFeatureValue? {
        provider.featureValue(for: featureName)
    }

    public init(embOutput: MLMultiArray) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["embOutput" : MLFeatureValue(multiArray: embOutput)])
    }

    public init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
public class TextEncoder_float32 {
    public let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle.module
        return bundle.url(forResource: "TextEncoder_float32", withExtension:"mlmodelc")!
    }

    /**
        Construct TextEncoder_float32 instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of TextEncoder_float32.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `TextEncoder_float32.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    public convenience init(configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct TextEncoder_float32 instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    public convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    public convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct TextEncoder_float32 instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    public class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<TextEncoder_float32, Error>) -> Void) {
        load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct TextEncoder_float32 instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
    */
    public class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> TextEncoder_float32 {
        try await load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct TextEncoder_float32 instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    public class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<TextEncoder_float32, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(TextEncoder_float32(model: model)))
            }
        }
    }

    /**
        Construct TextEncoder_float32 instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
    */
    public class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> TextEncoder_float32 {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return TextEncoder_float32(model: model)
    }

    /**
        Make a prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - input: the input to the prediction as TextEncoder_float32Input

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as TextEncoder_float32Output
    */
    public func prediction(input: TextEncoder_float32Input) throws -> TextEncoder_float32Output {
        try prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - input: the input to the prediction as TextEncoder_float32Input
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as TextEncoder_float32Output
    */
    public func prediction(input: TextEncoder_float32Input, options: MLPredictionOptions) throws -> TextEncoder_float32Output {
        let outFeatures = try model.prediction(from: input, options: options)
        return TextEncoder_float32Output(features: outFeatures)
    }

    /**
        Make an asynchronous prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - input: the input to the prediction as TextEncoder_float32Input
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as TextEncoder_float32Output
    */
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
    public func prediction(input: TextEncoder_float32Input, options: MLPredictionOptions = MLPredictionOptions()) async throws -> TextEncoder_float32Output {
        let outFeatures = try await model.prediction(from: input, options: options)
        return TextEncoder_float32Output(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        It uses the default function if the model has multiple functions.

        - parameters:
            - prompt: 1 by 77 matrix of 32-bit integers

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as TextEncoder_float32Output
    */
    public func prediction(prompt: MLMultiArray) throws -> TextEncoder_float32Output {
        let input_ = TextEncoder_float32Input(prompt: prompt)
        return try prediction(input: input_)
    }

    /**
        Make a prediction using the convenience interface

        It uses the default function if the model has multiple functions.

        - parameters:
            - prompt: 1 by 77 matrix of 32-bit integers

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as TextEncoder_float32Output
    */

    public func prediction(prompt: MLShapedArray<Int32>) throws -> TextEncoder_float32Output {
        let input_ = TextEncoder_float32Input(prompt: prompt)
        return try prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - inputs: the inputs to the prediction as [TextEncoder_float32Input]
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [TextEncoder_float32Output]
    */
    public func predictions(inputs: [TextEncoder_float32Input], options: MLPredictionOptions = MLPredictionOptions()) throws -> [TextEncoder_float32Output] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [TextEncoder_float32Output] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  TextEncoder_float32Output(features: outProvider)
            results.append(result)
        }
        return results
    }
}

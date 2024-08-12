//
//  File.swift
//  ImageFeatureExtractor
//
//  Created by ailu on 2024/8/6.
//

import Accelerate
import Foundation

func softmax(inputs: [Float]) -> [Float] {
    let count = inputs.count
    var outputs = [Float](repeating: 0, count: count)
    var inDescription = BNNSVectorDescriptor(size: count, data_type: .float)
    var outDescription = BNNSVectorDescriptor(size: count, data_type: .float)
    var activation = BNNSActivation(function: .softmax)

    var filterParameters = BNNSFilterParameters()

    let activationLayer = BNNSFilterCreateVectorActivationLayer(&inDescription,
                                                                &outDescription,
                                                                &activation,
                                                                &filterParameters)
    BNNSFilterApply(activationLayer, inputs, &outputs)

    return outputs
}

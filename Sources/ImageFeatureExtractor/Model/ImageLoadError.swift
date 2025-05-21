//
//  ImageLoadError.swift
//  ImageFeatureExtractor
//
//  Created by Lu Ai on 2024/10/23.
//

import Foundation

public enum ImageLoadError: Error, LocalizedError {
    case invalidData
    case loadFailed(Error)
    case processingFailed(Error)

    // MARK: Public

    public var errorDescription: String? {
        switch self {
        case .invalidData:
            "无法加载图片数据"
        case let .loadFailed(error):
            "加载图片失败: \(error.localizedDescription)"
        case let .processingFailed(error):
            "处理图片失败: \(error.localizedDescription)"
        }
    }
}

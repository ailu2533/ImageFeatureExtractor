//
//  File.swift
//  ImageFeatureExtractor
//
//  Created by ailu on 2024/8/11.
//

import Foundation

import Foundation
import SwiftUI

extension LocalizedStringKey: @unchecked Sendable {}

public struct ClothingSubcategory: Identifiable, Sendable {
    public let id: UUID
    public let rawValue: String
    public let displayLabel: String

    init(id: UUID, rawValue: String, displayLabel: String) {
        self.id = id
        self.rawValue = rawValue
        self.displayLabel = displayLabel
    }
}

public struct ClothingCategory: Identifiable, Sendable {
    public let id: UUID
    public let rawValue: String
    public let displayLabel: String

    public let subcategories: [ClothingSubcategory]

    init(id: UUID, rawValue: String, displayLabel: String, subcategories: [ClothingSubcategory]) {
        self.id = id
        self.rawValue = rawValue
        self.displayLabel = displayLabel
        self.subcategories = subcategories
    }
}

public struct ClothingCatalog {
    public static let categories: [ClothingCategory] = [
        ClothingCategory(id: otherCategoryUUID, rawValue: "Other", displayLabel: String(localized: "Other", bundle: .module), subcategories: [
            ClothingSubcategory(id: otherCategorySubUUID, rawValue: "Other", displayLabel: String(localized: "Other", bundle: .module)),
        ]),

        ClothingCategory(id: UUID(uuidString: "01913f53-1b26-7690-bde3-d520df805046")!, rawValue: "Tops", displayLabel: String(localized: "Tops", bundle: .module), subcategories: [
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7153-ac42-e681089aa19f")!, rawValue: "T-Shirt", displayLabel: String(localized: "T-Shirt", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7dae-82ce-fe22697acba2")!, rawValue: "Polo Shirt", displayLabel: String(localized: "Polo Shirt", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-79f1-8d46-efddb22f4316")!, rawValue: "Shirt", displayLabel: String(localized: "Shirt", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-712c-9bea-cee1803d8581")!, rawValue: "Blouse", displayLabel: String(localized: "Blouse", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7f13-9e16-bcc7fc09d03e")!, rawValue: "Vest", displayLabel: String(localized: "Vest", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7fe6-b55f-95de53369f72")!, rawValue: "Sweater", displayLabel: String(localized: "Sweater", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-798c-9151-c48c6da1d466")!, rawValue: "Hoodie", displayLabel: String(localized: "Hoodie", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7616-a34c-e9435d40ee09")!, rawValue: "Suit", displayLabel: String(localized: "Suit", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-72a6-b06c-0684e40654c1")!, rawValue: "Jacket", displayLabel: String(localized: "Jacket", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7ce9-9984-86db33b6dc41")!, rawValue: "Coat", displayLabel: String(localized: "Coat", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-774c-94ac-65fac54d28c9")!, rawValue: "Tank Top", displayLabel: String(localized: "Tank Top", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7d2c-8667-013b84db9bd2")!, rawValue: "Bra", displayLabel: String(localized: "Bra", bundle: .module)),
        ]),
        ClothingCategory(id: UUID(uuidString: "01913f53-1b26-725a-abae-cbcbf092c279")!, rawValue: "One-Piece Garments", displayLabel: String(localized: "One-Piece Garments", bundle: .module), subcategories: [
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7848-b464-7ccf7e8e252b")!, rawValue: "One-Piece Dress", displayLabel: String(localized: "One-Piece Dress", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-79b3-b818-533c06708ccd")!, rawValue: "Jumpsuit", displayLabel: String(localized: "Jumpsuit", bundle: .module)),
        ]),
        ClothingCategory(id: UUID(uuidString: "01913f53-1b26-7d58-90aa-6f366b4ebddd")!, rawValue: "Bottoms", displayLabel: String(localized: "Bottoms", bundle: .module), subcategories: [
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7f36-a409-87850056f61f")!, rawValue: "Pants", displayLabel: String(localized: "Pants", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-72a7-b830-6f929e232ffd")!, rawValue: "Skirt", displayLabel: String(localized: "Skirt", bundle: .module)),
        ]),
        ClothingCategory(id: UUID(uuidString: "01913f53-1b26-7463-947b-5d5f6b3d13bd")!, rawValue: "Shoes", displayLabel: String(localized: "Shoes", bundle: .module), subcategories: [
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-787e-b259-533ecd658591")!, rawValue: "Shoes", displayLabel: String(localized: "Shoes", bundle: .module)),
        ]),
        ClothingCategory(id: UUID(uuidString: "01913f53-1b26-71d7-b33a-e1912dba6947")!, rawValue: "Bags", displayLabel: String(localized: "Bags", bundle: .module), subcategories: [
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-76dd-9adf-e05c630bf87d")!, rawValue: "Bag", displayLabel: String(localized: "Bag", bundle: .module)),
        ]),
        ClothingCategory(id: UUID(uuidString: "01913f53-1b26-7f53-8d16-695618540bdb")!, rawValue: "Accessories", displayLabel: String(localized: "Accessories", bundle: .module), subcategories: [
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7299-96c1-eae262585604")!, rawValue: "Hat", displayLabel: String(localized: "Hat", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-71a8-b576-dc7074062cfe")!, rawValue: "Bracelet", displayLabel: String(localized: "Bracelet", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-71cb-94bd-ea5ced0b05cf")!, rawValue: "Ring", displayLabel: String(localized: "Ring", bundle: .module)),
            ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-765d-9dd4-3ccadfb78a3e")!, rawValue: "Brooch", displayLabel: String(localized: "Brooch", bundle: .module)),
        ]),
    ]

    public static var allSubcategories: [ClothingSubcategory] {
        categories.flatMap { $0.subcategories }
    }

    public static func subcategory(forRawValue rawValue: String) -> ClothingSubcategory? {
        allSubcategories.first { $0.rawValue == rawValue }
    }

    public static func category(forSubcategory subcategory: ClothingSubcategory) -> ClothingCategory? {
        categories.first { $0.subcategories.contains { $0.id == subcategory.id } }
    }

    public static var labels: [String] {
        allSubcategories.map { $0.rawValue }
    }

    public static var label2CategoryUUID: [String: UUID] {
        Dictionary(uniqueKeysWithValues: allSubcategories.map { ($0.rawValue, $0.id) })
    }

    // 从UUID到子类别的DisplayLabel
    public static var categoryUUID2Label: [UUID: String] {
        Dictionary(uniqueKeysWithValues: allSubcategories.map { ($0.id, $0.rawValue) })
    }

    // 从rawValue到displayLabel的映射
    public static var rawValueToDisplayLabel: [String: String] {
        Dictionary(uniqueKeysWithValues: allSubcategories.map { ($0.rawValue, $0.displayLabel) })
    }

    public static func localizedLabel(_ label: String) -> String {
        return Bundle.module.localizedString(forKey: label, value: label, table: nil)
    }
}

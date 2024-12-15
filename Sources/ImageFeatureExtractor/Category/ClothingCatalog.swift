//
//  File.swift
//  ImageFeatureExtractor
//
//  Created by ailu on 2024/8/11.
//

import Algorithms
import Foundation
import SwiftUI

// MARK: - ClothingSubcategory

// extension LocalizedStringKey: @unchecked Sendable {}

public struct ClothingSubcategory: Identifiable, Sendable {
    // MARK: Lifecycle

    init(id: UUID, rawValue: String, displayLabel: String) {
        self.id = id
        self.rawValue = rawValue
        self.displayLabel = displayLabel
    }

    // MARK: Public

    public let id: UUID
    public let rawValue: String
    public let displayLabel: String
}

// MARK: - ClothingCategory

public struct ClothingCategory: Identifiable, Sendable {
    // MARK: Lifecycle

    init(id: UUID, rawValue: String, displayLabel: String, subcategories: [ClothingSubcategory]) {
        self.id = id
        self.rawValue = rawValue
        self.displayLabel = displayLabel
        self.subcategories = subcategories
    }

    // MARK: Public

    public let id: UUID
    public let rawValue: String
    public let displayLabel: String

    public let subcategories: [ClothingSubcategory]
}

// MARK: - ClothingCatalog

public struct ClothingCatalog {
    public static let categories: [ClothingCategory] = [
        ClothingCategory(
            id: UUID(uuidString: "01913f53-1b26-7690-bde3-d520df805046")!,
            rawValue: "Tops",
            displayLabel: String(localized: "Tops", bundle: .module),
            subcategories: [
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7153-ac42-e681089aa19f")!, rawValue: "T-Shirt", displayLabel: String(localized: "T-Shirt", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7dae-82ce-fe22697acba2")!, rawValue: "Polo Shirt", displayLabel: String(localized: "Polo Shirt", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-79f1-8d46-efddb22f4316")!, rawValue: "Shirt", displayLabel: String(localized: "Shirt", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-712c-9bea-cee1803d8581")!, rawValue: "Blouse", displayLabel: String(localized: "Blouse", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7f13-9e16-bcc7fc09d03e")!, rawValue: "Vest", displayLabel: String(localized: "Vest", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7fe6-b55f-95de53369f72")!, rawValue: "Sweater", displayLabel: String(localized: "Sweater", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-774c-94ac-65fac54d28c9")!, rawValue: "Tank Top", displayLabel: String(localized: "Tank Top", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7d2c-8667-013b84db9bd2")!, rawValue: "Bra", displayLabel: String(localized: "Bra", bundle: .module)),
            ]
        ),
        ClothingCategory(
            id: UUID(uuidString: "01913f53-1b26-7d58-90aa-6f366b4ebddd")!,
            rawValue: "Bottoms",
            displayLabel: String(localized: "Bottoms", bundle: .module),
            subcategories: [
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7f36-a409-87850056f61f")!, rawValue: "Trousers", displayLabel: String(localized: "Trousers", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-72a7-b830-6f929e232ffd")!, rawValue: "Skirt", displayLabel: String(localized: "Skirt", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "3db14230-055f-4c89-bc63-ae3e6c30b372")!, rawValue: "Jeans", displayLabel: String(localized: "Jeans", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "419f24f5-4ebe-470d-b282-d170c435886a")!, rawValue: "Shorts", displayLabel: String(localized: "Shorts", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "82cccb97-8b84-4f47-a366-f55a8b240953")!, rawValue: "Leggings", displayLabel: String(localized: "Leggings", bundle: .module)),
            ]
        ),
        ClothingCategory(
            id: UUID(uuidString: "01913f53-1b26-725a-abae-cbcbf092c279")!,
            rawValue: "Dresses & Jumpsuits",
            displayLabel: String(localized: "Dresses & Jumpsuits", bundle: .module),
            subcategories: [
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7848-b464-7ccf7e8e252b")!, rawValue: "One-Piece Dress", displayLabel: String(localized: "One-Piece Dress", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-79b3-b818-533c06708ccd")!, rawValue: "Jumpsuit", displayLabel: String(localized: "Jumpsuit", bundle: .module)),
            ]
        ),
        ClothingCategory(
            id: UUID(uuidString: "1b021e9a-859a-4f9c-ba9b-8882501cb8c8")!,
            rawValue: "Outerwear",
            displayLabel: String(localized: "Outerwear"),
            subcategories: [
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7ce9-9984-86db33b6dc41")!, rawValue: "Coat", displayLabel: String(localized: "Coat", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-72a6-b06c-0684e40654c1")!, rawValue: "Jacket", displayLabel: String(localized: "Jacket", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7616-a34c-e9435d40ee09")!, rawValue: "Blazer", displayLabel: String(localized: "Blazer", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-798c-9151-c48c6da1d466")!, rawValue: "Hoodie", displayLabel: String(localized: "Hoodie", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "e516a476-8c34-4778-b558-a348431123ce")!, rawValue: "Down Jacket", displayLabel: String(localized: "Down Jacket", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "0bce8811-eb20-44b7-b9fb-1790893a4226")!, rawValue: "Cardigan", displayLabel: String(localized: "Cardigan", bundle: .module)),
            ]
        ),

        ClothingCategory(
            id: UUID(uuidString: "01913f53-1b26-7463-947b-5d5f6b3d13bd")!,
            rawValue: "Shoes",
            displayLabel: String(localized: "Shoes", bundle: .module),
            subcategories: [
                ClothingSubcategory(id: UUID(uuidString: "7c7c6d6d-ed0f-4d76-b48f-9791439b6e0f")!, rawValue: "Boots", displayLabel: String(localized: "Boots", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-787e-b259-533ecd658591")!, rawValue: "Flats", displayLabel: String(localized: "Flats", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "e63598d4-08ff-44a9-bf9d-d154cca0add9")!, rawValue: "Heels", displayLabel: String(localized: "Heels", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "28a2280a-6fe7-4f21-a8b3-ff7a3adc608c")!, rawValue: "Sandals", displayLabel: String(localized: "Sandals", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "d94a0720-cf47-4c73-98b0-52abd48ff32e")!, rawValue: "Slippers", displayLabel: String(localized: "Slippers", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "b918bfe2-9b17-4013-b630-5779b03dc9ec")!, rawValue: "Sports Shoes", displayLabel: String(localized: "Sports Shoes", bundle: .module)),
            ]
        ),
        ClothingCategory(
            id: UUID(uuidString: "01913f53-1b26-71d7-b33a-e1912dba6947")!,
            rawValue: "Bags",
            displayLabel: String(localized: "Bags", bundle: .module),
            subcategories: [
                ClothingSubcategory(id: UUID(uuidString: "93e2971e-e9fb-471c-b11f-9055f6d3a46a")!, rawValue: "Sling Bag", displayLabel: String(localized: "Sling Bag", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "7a578dab-bd51-4fbe-9f88-96df33a77c20")!, rawValue: "Clutch Bag", displayLabel: String(localized: "Clutch Bag", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "fd6495fe-7145-4512-b26c-d3bea1f2a122")!, rawValue: "Belly Bag", displayLabel: String(localized: "Belly Bag", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-76dd-9adf-e05c630bf87d")!, rawValue: "Handbag", displayLabel: String(localized: "Handbag", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "d4fdaa07-6ce4-4952-8181-8fa9020a436d")!, rawValue: "Backpack", displayLabel: String(localized: "Backpack", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "4f2d7ee5-ff80-4032-83e2-c93e01b6dd6f")!, rawValue: "Briefcase", displayLabel: String(localized: "Briefcase", bundle: .module)),
            ]
        ),

        ClothingCategory(
            id: UUID(uuidString: "01913f53-1b26-7f53-8d16-695618540bdb")!,
            rawValue: "Accessories",
            displayLabel: String(localized: "Accessories", bundle: .module),
            subcategories: [
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-7299-96c1-eae262585604")!, rawValue: "Hat", displayLabel: String(localized: "Hat", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-71a8-b576-dc7074062cfe")!, rawValue: "Bracelet", displayLabel: String(localized: "Bracelet", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-71cb-94bd-ea5ced0b05cf")!, rawValue: "Ring", displayLabel: String(localized: "Ring", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "01910e4e-3b31-765d-9dd4-3ccadfb78a3e")!, rawValue: "Brooch", displayLabel: String(localized: "Brooch", bundle: .module)),

                ClothingSubcategory(id: UUID(uuidString: "956daee0-6782-43a1-ab45-1d2bf8050b7c")!, rawValue: "Sunglasses", displayLabel: String(localized: "Sunglasses", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "e048d749-1eb7-4db8-8980-36bf267834f4")!, rawValue: "Belt", displayLabel: String(localized: "Belt", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "b5666623-0fe1-4f27-9c2c-5d5f103e97b3")!, rawValue: "Watch", displayLabel: String(localized: "Watch", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "93c5d7ad-89bd-41be-9822-60017e7b40be")!, rawValue: "Gloves", displayLabel: String(localized: "Gloves", bundle: .module)),
                ClothingSubcategory(id: UUID(uuidString: "5a139de3-c25f-49e8-a5ce-e125edb9f421")!, rawValue: "Earrings", displayLabel: String(localized: "Earrings", bundle: .module)),
            ]
        ),
    ]

    public static var allSubcategories: [ClothingSubcategory] {
        categories.flatMap { $0.subcategories }
    }

    public static var labels: [String] {
        allSubcategories.map { $0.rawValue }
    }

    public static var label2CategoryUUID: [String: UUID] {
        Dictionary(uniqueKeysWithValues: allSubcategories.map { ($0.rawValue, $0.id) })
    }

    // 从UUID到子类别的DisplayLabel
    public static var categoryUUID2Label: [UUID: String] {
        Dictionary(uniqueKeysWithValues:
            chain(
                categories.map { ($0.id, $0.rawValue) },
                allSubcategories.map { ($0.id, $0.rawValue) }
            )
        )
    }

    // 从rawValue到displayLabel的映射
    public static var rawValueToDisplayLabel: [String: String] {
        Dictionary(uniqueKeysWithValues: allSubcategories.map { ($0.rawValue, $0.displayLabel) })
    }

    public static func subcategory(forRawValue rawValue: String) -> ClothingSubcategory? {
        allSubcategories.first { $0.rawValue == rawValue }
    }

    public static func category(forSubcategory subcategory: ClothingSubcategory) -> ClothingCategory? {
        categories.first { $0.subcategories.contains { $0.id == subcategory.id } }
    }

    public static func localizedLabel(_ label: String) -> String {
        return Bundle.module.localizedString(forKey: label, value: label, table: nil)
    }
}

//
//  ProductDataObject+CoreDataProperties.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//
//

import Foundation
import CoreData
import SwiftUI

extension ProductDataObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductDataObject> {
        return NSFetchRequest<ProductDataObject>(entityName: "ProductDataObject")
    }

    @NSManaged public var id: Int
    @NSManaged public var name: String?
    @NSManaged public var thumbnailPath: String?
    @NSManaged public var descriptionImagePath: String?
    @NSManaged public var descriptionSubject: String?
    @NSManaged public var price: Int
    @NSManaged public var rate: Double
    @NSManaged public var isFavorite: Bool
    @NSManaged public var favoriteRegistrationTime: Date?
}

extension ProductDataObject : Identifiable {

}

extension ProductDataObject {
    func toDomain() -> Product {
        return Product(
            id: id,
            name: name ?? "",
            thumbnailPath: thumbnailPath ?? "",
            descriptionImagePath: descriptionImagePath ?? "",
            descriptionSubject: descriptionSubject ?? "",
            price: price,
            rate: rate,
            isFavorite: isFavorite,
            favoriteRegistrationTime: favoriteRegistrationTime
        )
    }
}

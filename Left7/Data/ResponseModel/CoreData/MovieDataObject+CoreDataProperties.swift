//
//  MovieDataObject+CoreDataProperties.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//
//

import Foundation
import CoreData

extension MovieDataObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDataObject> {
        return NSFetchRequest<MovieDataObject>(entityName: "MovieDataObject")
    }

    @NSManaged public var id: Int
    @NSManaged public var name: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var descriptionSubject: String?
    @NSManaged public var rate: Double
    @NSManaged public var isFavorite: Bool
    @NSManaged public var favoriteRegistrationTime: Date?
}

extension MovieDataObject : Identifiable {

}

extension MovieDataObject {
    func toDomain() -> Movie {
        return Movie(
            id: id,
            name: name ?? "",
            posterPath: posterPath ?? "",
            descriptionSubject: descriptionSubject ?? "" ,
            rate: rate,
            isFavorite: isFavorite,
            favoriteRegistrationTime: favoriteRegistrationTime
        )
    }
}

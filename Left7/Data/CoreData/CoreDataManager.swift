//
//  CoreDataManager.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import Foundation
import CoreData

import RxSwift

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let persistentContainer = NSPersistentContainer(name: ProductDataObject.entityName)
    private(set) lazy var context = persistentContainer.viewContext
    
    private init() {
        loadPersistentContainer()
    }
    
    private func loadPersistentContainer() {
        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func fetch() -> Observable<[ProductDataObject]> {
        return Observable.create { [weak self] emitter in
            guard let products = try? self?.context.fetch(ProductDataObject.fetchRequest()) else {
                emitter.onError(CoreDataError.FetchFail)
                return Disposables.create()
            }
            
            emitter.onNext(products)
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func save(_ product: Product) {
        let productObject = ProductDataObject(context: context)
        productObject.id = product.id
        productObject.name = product.name
        productObject.thumbnailPath = product.thumbnailPath
        productObject.descriptionImagePath = product.descriptionImagePath
        productObject.descriptionSubject = product.descriptionSubject
        productObject.price = product.price
        productObject.rate = product.rate
        productObject.isFavorite = product.isFavorite
        productObject.favoriteRegistrationTime = Date()
        
        saveContextChange()
    }
    
    private func saveContextChange() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(CoreDataError.FetchFail.errorDescription)
            }
        }
    }
}

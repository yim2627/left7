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
    private let persistentContainer = NSPersistentContainer(name: "YogiCoreDataModel")
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
    
    func delete(with id: Int) {
        let request = ProductDataObject.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", String(id))
        request.predicate = predicate
        
        guard let fetchResult = try? context.fetch(request) else {
            return
        }
        fetchResult.forEach {
            context.delete($0)
        }
        
        saveContext()
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(CoreDataError.FetchFail.errorDescription)
            }
        }
    }
}

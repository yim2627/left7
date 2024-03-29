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
    //MARK: - Properties

    static let shared = CoreDataManager()
    private let persistentContainer = NSPersistentContainer(name: "Left7CoreDataModel")
    private(set) lazy var context = persistentContainer.viewContext // 용량이 적어서, 용량이 크면 백그라운드 테스크 쓸듯
    
    //MARK: - Init

    private init() {
        loadPersistentContainer()
    }
    
    //MARK: - Method

    private func loadPersistentContainer() {
        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func fetch<T: NSManagedObject>(type: T.Type) -> Observable<[T]> {
        return Observable.create { [weak self] emitter in
            guard let movies = try? self?.context.fetch(T.fetchRequest()) as? [T] else {
                emitter.onError(CoreDataError.FetchFail)
                return Disposables.create()
            }

            emitter.onNext(movies)
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func delete(with id: Int) {
        let request = MovieDataObject.fetchRequest()
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

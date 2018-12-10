//
//  BaseRepository.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData

protocol BaseRepository {
    associatedtype ModelType: Identifiable
    
    init(coreDataHelper: CoreDataHelper)
    
    /// Returns core data object with the specified id (if it exists).
    ///
    /// - Parameter id: Object ID
    /// - Returns: Core data object
    func getById(id: Int32) -> ModelType?
    
    /// Saves a single instance of core data object populated with the specified data.
    ///
    /// - Parameter apiResponseData: Data to prefill the object with
    /// - Returns: Core data object
    func saveSingle(_ apiResponseData: ModelType.DataType) -> ModelType
    
    /// Saves an array core data objects populated with the specified data.
    ///
    /// - Parameter apiResponseData: Data to prefill the objects with
    /// - Returns: Array of Core data objects
    func saveList(_ apiResponseData: [ModelType.DataType]) -> [ModelType]
    
    /// Saves the Core data context associated with this repository.
    func saveRepository()
}

class BaseRepositoryImpl<ModelType: Identifiable>: BaseRepository {
  
    internal var coreDataHelper: CoreDataHelper
    
    required init(coreDataHelper: CoreDataHelper) {
        self.coreDataHelper = coreDataHelper
    }
    
    func getById(id: Int32) -> ModelType? {
        return coreDataHelper.getObjectById(ModelType.self, id: id)
    }
    
    func saveSingle(_ apiResponseData: ModelType.DataType) -> ModelType {
        let coreObject = initFromResponse(apiResponseData)
        saveRepository()
        return coreObject
    }
    
    func saveList(_ apiResponseData: [ModelType.DataType]) -> [ModelType] {
        var objectList = [ModelType]()
        objectList.reserveCapacity(apiResponseData.count)
        for data in apiResponseData {
            objectList.append(initFromResponse(data))
        }
        saveRepository()
        return objectList
    }
    
    func saveRepository() {
        coreDataHelper.saveContext()
    }
    
    private func initFromResponse(_ apiResponseData: ModelType.DataType)  -> ModelType {
        let coreObject = coreDataHelper.getExistingOrNew(ModelType.self, id: apiResponseData.id)
        return coreObject.populate(with: apiResponseData, coreDataHelper: coreDataHelper)
    }
    
}

//
//  BaseRepository.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import CoreData

protocol BaseRepository {
    associatedtype ModelType: Populatable
    
    init(coreDataHelper: CoreDataHelper)
    
    func initFromResponse(_ apiResponseData: ModelType.DataType)
    func getById(id: Int32) -> ModelType?
}

class BaseRepositoryImpl<ModelType: Populatable>: BaseRepository {
  
    internal var coreDataHelper: CoreDataHelper
    
    required init(coreDataHelper: CoreDataHelper) {
        self.coreDataHelper = coreDataHelper
    }
    
    func getById(id: Int32) -> ModelType? {
        return coreDataHelper.getObjectById(ModelType.self, id: id)
    }
    
    func initFromResponse(_ apiResponseData: ModelType.DataType) {
      //  let coreObject = coreDataHelper.getExistingOrNew(ModelType.self, id: apiResponseData.id)
    }
    
    
}

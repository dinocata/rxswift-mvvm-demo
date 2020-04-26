//
//  IsUserLoggedInUseCase.swift
//  Domain
//
//  Created by Dino Catalinac on 15/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift

// sourcery: injectable, AutoMockable
public protocol IsUserLoggedInUseCase {
    func execute() -> Observable<Bool>
}

public class IsUserLoggedInUseCaseImpl: IsUserLoggedInUseCase {
    
    private let getUserUseCase: GetUserUseCase
    
    public init(getUserUseCase: GetUserUseCase) {
        self.getUserUseCase = getUserUseCase
    }
    
    public func execute() -> Observable<Bool> {
        return getUserUseCase.execute().map { $0.type != .offline }
    }
}

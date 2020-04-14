//
//  DashboardViewModel.swift
//  Application
//
//  Created by Dino Catalinac on 13/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxCocoa
import Domain

// sourcery: injectable
class DashboardViewModel {
    var useCase: PostListUseCase!
    var mapper: DashboardViewDataMapper!
}

// Binding
extension DashboardViewModel: ViewModelType {
    struct Input {
        let loadPosts: Driver<Void>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let failure: Driver<String>
        let postData: Driver<[PostListItemCell.Data]>
    }
    
    func transform(input: Input) -> Output {
        let postsResult = input.loadPosts
            .asObservable()
            .flatMapLatest(useCase.getPosts)
            .share()
        
        let success = postsResult
            .compactMap { $0.value }
            .map { $0.map(self.mapper.mapPostData) }
            .asDriver(onErrorJustReturn: [])
        
        let failure = postsResult
            .compactMap { $0.error }
            .map(mapper.mapPostError)
            .asDriver(onErrorJustReturn: "Unknown error")
        
        let loading = Driver.merge(
            input.loadPosts.map { _ in true },
            postsResult.map { _ in false }.asDriver(onErrorJustReturn: false)
        )
        
        return Output(
            loading: loading,
            failure: failure,
            postData: success
        )
    }
}

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
    var postListUseCase: PostListUseCase!
    var loginUseCase: LoginUseCase!
    var mapper: DashboardViewDataMapper!
}

// Binding
extension DashboardViewModel: ViewModelType {
    struct Input {
        let loadPosts: Driver<Void>
        
        let loginButtonPressed: Driver<Void>
        let logoutButtonPressed: Driver<Void>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let failure: Driver<String>
        let postData: Driver<[PostListItemCell.Data]>
        
        let isLoggedIn: Driver<Bool>
        let logout: Driver<Void>
        let transition: Driver<Scene>
    }
    
    func transform(input: Input) -> Output {
        let postsResult = input.loadPosts
            .asObservable()
            .flatMapLatest(postListUseCase.getPosts)
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
        
        let isLoggedIn = loginUseCase.isUserLoggedIn()
            .asDriver(onErrorJustReturn: false)
        
        let logout = input.logoutButtonPressed
            .asObservable()
            .flatMapLatest { self.loginUseCase.logout() }
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
        
        let transition: Driver<Scene> = .merge(
            input.loginButtonPressed.map { .login }
        )
        
        return Output(
            loading: loading,
            failure: failure,
            postData: success,
            isLoggedIn: isLoggedIn,
            logout: logout,
            transition: transition
        )
    }
}

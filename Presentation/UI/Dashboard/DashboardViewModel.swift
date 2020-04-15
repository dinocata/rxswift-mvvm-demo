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
    var getPostsUseCase: GetPostsUseCase!
    var isUserLoggedInUseCase: IsUserLoggedInUseCase!
    var logoutUserUseCase: LogoutUserUseCase!
    var mapper: DashboardViewDataMapper!
}

// Binding
extension DashboardViewModel: ViewModelType {
    typealias Index = Int
    
    struct Input {
        let loadPosts: Driver<Void>
        let postSelected: Driver<Index>
        
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
            .flatMapLatest(getPostsUseCase.execute)
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
        
        let isLoggedIn = isUserLoggedInUseCase.execute()
            .asDriver(onErrorJustReturn: false)
        
        let logout = input.logoutButtonPressed
            .asObservable()
            .flatMapLatest(logoutUserUseCase.execute)
            .mapToVoid()
            .asDriver(onErrorJustReturn: ())
        
        let postDetailsCheck = input.postSelected
            .withLatestFrom(isLoggedIn)
        
        let postDetails = postDetailsCheck
            .filter { $0 }
            .withLatestFrom(Driver.combineLatest(success, input.postSelected))
            .map { Scene.postDetails(postId: $0[$1].id ) }
        
        let loginRedirect = postDetailsCheck
            .filter { !$0 }
            .map { _ in Scene.login }
        
        let transition: Driver<Scene> = .merge(
            postDetails,
            loginRedirect,
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

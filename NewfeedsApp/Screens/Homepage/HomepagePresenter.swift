//
//  HomepagePresenter.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 14/06/2023.
//

import Foundation

protocol HomepagePresenter {
    func getInitData()
    func getPosts()
    func loadMorePosts()
    func refreshPosts()
    func favorite(postID: String)
    func unfavorite(postID: String)
    func pin(postID: String)
    func unPin(postID: String)
}

class HomepagePresenterImpl: HomepagePresenter {
    
    private var postRepository: PostRepository
    private var favoriteRepository: FavoriteRepository
    private var pinRepository: PinRepository
    private var homepageVC: HomepageViewController
    
    init(postRepository: PostRepository, favoriteRepository: FavoriteRepository, pinRepository: PinRepository, homepageVC: HomepageViewController) {
        self.postRepository = postRepository
        self.favoriteRepository = favoriteRepository
        self.pinRepository = pinRepository
        self.homepageVC = homepageVC
    }
    
    var currentPage = 1
    var loadMoreAvailable = false
    
    private var apiGroup = DispatchGroup()
    
    let concurentQueue = DispatchQueue(label: "techmaster.queue.concurrent", attributes: .concurrent)
    
//    private var favoritePosts = [PostEntity]()
//    private var pinPosts = [PostEntity]()
    
    func getInitData() {
        homepageVC.showLoading(isShow: true)
        
        getPosts()
        getfavoritePosts()
        getPinPosts()
        
        apiGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.homepageVC.showLoading(isShow: false)
                self.concurentQueue.async {
                    DispatchQueue.main.async {
                        self.homepageVC.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getPosts() {
        _getPost(page: currentPage, apiType: .getInit)
        
//        apiGroup.enter()
//        postRepository.getPosts(page: currentPage, pageSize: 100) { [weak self] response in
//            guard let self = self else {return}
//            DispatchQueue.global().async {
//                self.homepageVC.getPosts(posts: response.results)
//                self.apiGroup.leave()
//            }
//        } failure: { [weak self] apiError in
//            guard let self = self else {return}
//            self.apiGroup.leave()
//            self.homepageVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
//        }
    }
    
    func loadMorePosts() {
        guard loadMoreAvailable else {return}
        loadMoreAvailable = false
        currentPage += 1
        _getPost(page: currentPage, apiType: .loadmore)
    }
    
    func refreshPosts() {
        currentPage = 1
        _getPost(page: currentPage, apiType: .refresh)
        getfavoritePosts()
        getPinPosts()
    }
    
    private func _getPost(page: Int, pageSize: Int = 20, apiType: APIType) {
        switch apiType {
        case .getInit:
//            homepageVC.showLoading(isShow: true)
            apiGroup.enter()
        default:
            break
        }
        postRepository.getPosts(page: page, pageSize: pageSize) { [weak self] response in
            guard let self = self else {return}
            switch apiType {
            case .getInit:
//                self.homepageVC.showLoading(isShow: false)
                self.homepageVC.getPosts(posts: response.results)
                self.apiGroup.leave()
            case .loadmore:
                self.homepageVC.loadmorePosts(posts: response.results)
            case .refresh:
                self.homepageVC.hideRefreshLoading()
                self.homepageVC.getPosts(posts: response.results)
            }
            self.loadMoreAvailable = response.loadMoreAvailable
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            print(apiError)
            switch apiType {
            case .getInit:
//                self.homepageVC.showLoading(isShow: false)
                self.homepageVC.getPosts(posts: [])
                self.apiGroup.leave()
            case .refresh:
                self.homepageVC.hideRefreshLoading()
            case .loadmore:
                self.homepageVC.loadmorePosts(posts: [])
            }
            self.homepageVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
           
        }
    }

    private func getfavoritePosts() {
        apiGroup.enter()
        favoriteRepository.getPosts(page: 1, pageSize: 100) { [weak self] response in
            guard let self = self else {return}
            let postIDs = response.results.compactMap({$0.id})
            self.homepageVC.getfavoritePostSuccess(postIDs: postIDs)
            self.apiGroup.leave()
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.apiGroup.leave()
            self.homepageVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    private func getPinPosts() {
        apiGroup.enter()
        pinRepository.getPosts(page: 1, pageSize: 100) { [weak self] response in
            guard let self = self else {return}
            let postIDs = response.results.compactMap({$0.id})
            self.homepageVC.getPinPostSuccess(postIDs: postIDs)
            self.apiGroup.leave()
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.homepageVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
            self.apiGroup.leave()
        }
    }
    
    //Call API favorite
    func favorite(postID: String) {
        favoriteRepository.favorite(postID: postID) { [weak self] response in
            guard let self = self else {return}
//            if let post = response.data, let postID = post.id {
                self.homepageVC.favoritePost(postID: postID)
//            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.homepageVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    func unfavorite(postID: String) {
        favoriteRepository.unFavorite(postID: postID) { [weak self] response in
            guard let self = self else {return}
//            if let post = response.data, let postID = post.id {
                self.homepageVC.unfavoritePostSuccess(postID: postID)
//            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.homepageVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    //Call API Pin
    func pin(postID: String) {
        pinRepository.pinPost(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.id {
                self.homepageVC.pinPost(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.homepageVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    func unPin(postID: String) {
        pinRepository.unPin(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.id {
                self.homepageVC.unPinPostSuccess(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.homepageVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
}

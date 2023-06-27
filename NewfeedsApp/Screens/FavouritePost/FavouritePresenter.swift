//
//  favoritePresenter.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 19/06/2023.
//

import Foundation

protocol favoritePresenter {
    func getInitData()
    func getPosts()
    func loadMorePosts()
    func refreshPosts()
    func favorite(postID: String)
    func unfavorite(postID: String)
    func pin(postID: String)
    func unPin(postID: String)
}

class favoritePresenterImpl: favoritePresenter {
    
    private var favoriteRepository: FavoriteRepository
    private var favoriteVC: favoriteViewController
    private var pinRepository: PinRepository
    
    init(favoriteRepository: FavoriteRepository, favoriteVC: favoriteViewController, pinRepository: PinRepository) {
        self.favoriteRepository = favoriteRepository
        self.favoriteVC = favoriteVC
        self.pinRepository = pinRepository
    }
    
    var currentPage = 1
    var loadMoreAvailable = false
    
    private var apiGroup = DispatchGroup()
    let concurentQueue = DispatchQueue(label: "techmaster.queue.concurrent", attributes: .concurrent)
    
    func getInitData() {
        favoriteVC.showLoading(isShow: true)
        
        getPosts()
        getfavoritePosts()
        getPinPosts()
        
        apiGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.favoriteVC.showLoading(isShow: false)
                self.concurentQueue.async {
                    DispatchQueue.main.async {
                        self.favoriteVC.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getPosts() {
        _getPost(page: currentPage, apiType: .getInit)
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
        getPinPosts()
    }
    
    
    private func _getPost(page: Int, pageSize: Int = 100, apiType: APIType) {
        switch apiType {
        case .getInit:
            favoriteVC.showLoading(isShow: true)
        default:
            break
        }
        favoriteRepository.getPosts(page: page, pageSize: pageSize) { [weak self] response in
            guard let self = self else {return}
            
            switch apiType {
            case .getInit:
                self.favoriteVC.showLoading(isShow: false)
                self.favoriteVC.getPosts(posts: response.results)
            case .loadmore:
                self.favoriteVC.loadmorePosts(posts: response.results)
            case .refresh:
                self.favoriteVC.hideRefreshLoading()
                self.favoriteVC.getPosts(posts: response.results)
            }
            self.loadMoreAvailable = response.loadMoreAvailable
            
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            switch apiType {
            case .getInit:
                self.favoriteVC.showLoading(isShow: false)
                self.favoriteVC.getPosts(posts: [])
            case .refresh:
                self.favoriteVC.hideRefreshLoading()
            case .loadmore:
                self.favoriteVC.loadmorePosts(posts: [])
            }
            self.favoriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    private func getfavoritePosts() {
//        apiGroup.enter()
        favoriteRepository.getPosts(page: 1, pageSize: 100) { [weak self] response in
            guard let self = self else {return}
            let postIDs = response.results.compactMap({$0.id})
            self.favoriteVC.getfavoritePostSuccess(postIDs: postIDs)
//            self.apiGroup.leave()
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.favoriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    private func getPinPosts() {
        apiGroup.enter()
        pinRepository.getPosts(page: 1, pageSize: 100) { [weak self] response in
            guard let self = self else {return}
            let postIDs = response.results.compactMap({$0.id})
            self.favoriteVC.getPinPostSuccess(postIDs: postIDs)
            self.apiGroup.leave()
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.apiGroup.leave()
            self.favoriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    //Call API favorite
    func favorite(postID: String) {
        favoriteRepository.favorite(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.id {
                self.favoriteVC.favoritePost(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.favoriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    func unfavorite(postID: String) {
        favoriteRepository.unFavorite(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.id {
                self.favoriteVC.unfavoritePostSuccess(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.favoriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    //Call API Pin
    func pin(postID: String) {
        pinRepository.pinPost(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.id {
                self.favoriteVC.pinPost(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.favoriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    func unPin(postID: String) {
        pinRepository.unPin(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.id {
                self.favoriteVC.unPinPostSuccess(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.favoriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
}

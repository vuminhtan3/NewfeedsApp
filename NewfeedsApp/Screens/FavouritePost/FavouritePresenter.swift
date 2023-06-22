//
//  FavouritePresenter.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 19/06/2023.
//

import Foundation

protocol FavouritePresenter {
    func getInitData()
    func getPosts()
    func loadMorePosts()
    func refreshPosts()
    func favourite(postID: String)
    func unFavourite(postID: String)
    func pin(postID: String)
    func unPin(postID: String)
}

class FavouritePresenterImpl: FavouritePresenter {
    
    private var favouriteRepository: FavouriteRepository
    private var favouriteVC: FavouriteViewController
    private var pinRepository: PinRepository
    
    init(favouriteRepository: FavouriteRepository, favouriteVC: FavouriteViewController, pinRepository: PinRepository) {
        self.favouriteRepository = favouriteRepository
        self.favouriteVC = favouriteVC
        self.pinRepository = pinRepository
    }
    
    var currentPage = 1
    var loadMoreAvailable = false
    
    private var apiGroup = DispatchGroup()
    let concurentQueue = DispatchQueue(label: "techmaster.queue.concurrent", attributes: .concurrent)
    
    func getInitData() {
        favouriteVC.showLoading(isShow: true)
        
        getPosts()
        getFavouritePosts()
        getPinPosts()
        
        apiGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.favouriteVC.showLoading(isShow: false)
                self.concurentQueue.async {
                    DispatchQueue.main.async {
                        self.favouriteVC.tableView.reloadData()
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
            favouriteVC.showLoading(isShow: true)
        default:
            break
        }
        favouriteRepository.getPosts(page: page, pageSize: pageSize) { [weak self] response in
            guard let self = self else {return}
            
            switch apiType {
            case .getInit:
                self.favouriteVC.showLoading(isShow: false)
                self.favouriteVC.getPosts(posts: response.results)
            case .loadmore:
                self.favouriteVC.loadmorePosts(posts: response.results)
            case .refresh:
                self.favouriteVC.hideRefreshLoading()
                self.favouriteVC.getPosts(posts: response.results)
            }
            self.loadMoreAvailable = response.loadMoreAvailable
            
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            switch apiType {
            case .getInit:
                self.favouriteVC.showLoading(isShow: false)
                self.favouriteVC.getPosts(posts: [])
            case .refresh:
                self.favouriteVC.hideRefreshLoading()
            case .loadmore:
                self.favouriteVC.loadmorePosts(posts: [])
            }
            self.favouriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    private func getFavouritePosts() {
//        apiGroup.enter()
        favouriteRepository.getPosts(page: 1, pageSize: 100) { [weak self] response in
            guard let self = self else {return}
            let postIDs = response.results.compactMap({$0.id})
            self.favouriteVC.getFavouritePostSuccess(postIDs: postIDs)
//            self.apiGroup.leave()
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.favouriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    private func getPinPosts() {
        apiGroup.enter()
        pinRepository.getPosts(page: 1, pageSize: 100) { [weak self] response in
            guard let self = self else {return}
            let postIDs = response.results.compactMap({$0.id})
            self.favouriteVC.getPinPostSuccess(postIDs: postIDs)
            self.apiGroup.leave()
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.apiGroup.leave()
            self.favouriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    //Call API Favourite
    func favourite(postID: String) {
        favouriteRepository.favourite(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.postID {
                self.favouriteVC.favouritePost(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.favouriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    func unFavourite(postID: String) {
        favouriteRepository.unFavourite(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.postID {
                self.favouriteVC.unFavouritePostSuccess(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.favouriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    //Call API Pin
    func pin(postID: String) {
        pinRepository.pinPost(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.postID {
                self.favouriteVC.pinPost(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.favouriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    func unPin(postID: String) {
        pinRepository.unPin(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.postID {
                self.favouriteVC.unPinPostSuccess(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.favouriteVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
}

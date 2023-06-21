//
//  PinPostPresenter.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 18/06/2023.
//

import Foundation

protocol PinPostPresenter {
    func getPosts()
    func loadMorePosts()
    func refreshPosts()
    func favourite(postID: String)
    func unFavourite(postID: String)
    func pin(postID: String)
    func unPin(postID: String)
}

class PinPostPresenterImpl: PinPostPresenter {
    
    private var pinRepository: PinRepository
    private var pinPostVC: PinPostViewController
    private var favouriteRepository: FavouriteRepository
    
    init(pinRepository: PinRepository, pinPostVC: PinPostViewController, favouriteRepository: FavouriteRepository) {
        self.pinRepository = pinRepository
        self.pinPostVC = pinPostVC
        self.favouriteRepository = favouriteRepository
    }
    
    var currentPage = 1
    var loadMoreAvailable = false
    
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
    }
    
    private func _getPost(page: Int, pageSize: Int = 100, apiType: APIType) {
        switch apiType {
        case .getInit:
            pinPostVC.showLoading(isShow: true)
        default:
            break
        }
        pinRepository.getPosts(page: page, pageSize: pageSize) { [weak self] response in
            guard let self = self else {return}
            
            switch apiType {
            case .getInit:
                self.pinPostVC.showLoading(isShow: false)
                self.pinPostVC.getPosts(posts: response.results)
//                let postIDs = response.results.compactMap({$0.id})
//                self.pinPostVC.getPinPostSuccess(postIDs: postIDs)
            case .loadmore:
                self.pinPostVC.loadmorePosts(posts: response.results)
            case .refresh:
                self.pinPostVC.hideRefreshLoading()
                self.pinPostVC.getPosts(posts: response.results)
            }
            self.loadMoreAvailable = response.loadMoreAvailable
            
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            print(apiError)
            switch apiType {
            case .getInit:
                self.pinPostVC.showLoading(isShow: false)
                self.pinPostVC.getPosts(posts: [])
            case .refresh:
                self.pinPostVC.hideRefreshLoading()
            case .loadmore:
                self.pinPostVC.loadmorePosts(posts: [])
            }
            self.pinPostVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    //Call API Favourite
    func favourite(postID: String) {
        favouriteRepository.favourite(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.postID {
                self.pinPostVC.favouritePost(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.pinPostVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    func unFavourite(postID: String) {
        favouriteRepository.unFavourite(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.postID {
                self.pinPostVC.unFavouritePostSuccess(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.pinPostVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    //Call API Pin
    func pin(postID: String) {
        pinRepository.pinPost(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.postID {
                self.pinPostVC.pinPost(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.pinPostVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
    func unPin(postID: String) {
        pinRepository.unPin(postID: postID) { [weak self] response in
            guard let self = self else {return}
            if let post = response.data, let postID = post.postID {
                self.pinPostVC.unPinPostSuccess(postID: postID)
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.pinPostVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }
    }
    
}

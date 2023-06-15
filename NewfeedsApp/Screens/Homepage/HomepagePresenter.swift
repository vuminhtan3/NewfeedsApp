//
//  HomepagePresenter.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 14/06/2023.
//

import Foundation

protocol HomepagePresenter {
    func getPosts()
    func loadMorePosts()
    func refreshPosts()
}

class HomepagePresenterImpl: HomepagePresenter {
    
    private var postRepository: PostRepository
    private var homepageVC: HomepageViewController
    
    init(postRepository: PostRepository, homepageVC: HomepageViewController) {
        self.postRepository = postRepository
        self.homepageVC = homepageVC
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
    
    private func _getPost(page: Int, pageSize: Int = 20, apiType: APIType) {
        switch apiType {
        case .getInit:
            homepageVC.showLoading(isShow: true)
        default:
            break
        }
        postRepository.getPosts(page: page, pageSize: pageSize) { [weak self] response in
            guard let self = self else {return}
            switch apiType {
            case .getInit:
                self.homepageVC.showLoading(isShow: true)
                self.homepageVC.getPosts(posts: response.results)
            case .loadmore:
                self.homepageVC.loadmorePosts(posts: response.results)
            case .refresh:
                self.homepageVC.hideRefreshLoading()
                self.homepageVC.getPosts(posts: response.results)
            }
            self.loadMoreAvailable = response.loadMoreAvailable
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            
            switch apiType {
            case .getInit:
                self.homepageVC.showLoading(isShow: false)
                self.homepageVC.getPosts(posts: [])
            case .refresh:
                self.homepageVC.hideRefreshLoading()
            case .loadmore:
                self.homepageVC.loadmorePosts(posts: [])
            }
            self.homepageVC.callAPIFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong")
        }

        
    }
}

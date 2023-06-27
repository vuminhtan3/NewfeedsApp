//
//  PostRepository.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 14/06/2023.
//

import Foundation
import CoreData
import Alamofire

protocol PostRepository {
    /**
     
     */
    func getPosts(page: Int,
                  pageSize: Int,
                  success: ((ArrayResponse<PostEntity>) -> Void)?,
                  failure: ((APIError?) -> Void)?)
}

class PostRepositoryImpl: PostRepository {
    
    var postAPIService: PostAPIService
    var postCoreDataService: PostCoreDataService
    
    init(postAPIService: PostAPIService, postCoreDataService: PostCoreDataService) {
        self.postAPIService = postAPIService
        self.postCoreDataService = postCoreDataService
    }
    
    func getPosts(page: Int, pageSize: Int, success: ((ArrayResponse<PostEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        /**
         Kiểm tra xem có internet hay không?
         Nếu mà có internet thì thực hiện call API bình thường và save data xuống coredata
         */
        if Connectivity.isConnectedToInternet {
            postAPIService.getPosts(page: page, pageSize: pageSize, success: { response in
                if !response.results.isEmpty {
                    ///Xoá data cũ
                    self.postCoreDataService.clear()
                    
                    ///Dùng vòng lặp lặp qua các result để tạo post từ api lưu vào coreData
                    response.results.forEach { postEntity in
                        self.postCoreDataService.create(postEntity: postEntity)                    }
                }
                success?(response)
            }, failure: { apiError in
                self.postCoreDataService.getPost(page: page, pageSize: pageSize, success: success, failure: failure)
            })

        } else {
            postCoreDataService.getPost(page: page, pageSize: pageSize, success: success, failure: failure)
        }
    }
}

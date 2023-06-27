//
//  PostCoreDataService.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 23/06/2023.
//

import UIKit
import CoreData

protocol PostCoreDataService {
    func getPost(page: Int,
                 pageSize: Int,
                 success: ((ArrayResponse<PostEntity>) -> Void)?,
                 failure: ((APIError) -> Void)?)
    func create(postEntity: PostEntity)
    func clear()
}

class PostCoreDataServiceImpl: PostCoreDataService {
    
    func getPost(page: Int, pageSize: Int, success: ((ArrayResponse<PostEntity>) -> Void)?, failure: ((APIError) -> Void)?) {
        //Step 1: Lấy AppDelegate, Managed Object Context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Step 2: Tạo fetchRequest với entityName:
        var postFetchRequest = NSFetchRequest<PostData>(entityName: "PostData")
        
        //Step 3: Fetch bằng đối tượng Managed Object Context
        do {
            ///Thêm vào array có sẵn:
            let posts: [PostData] = try managedContext.fetch(postFetchRequest)
            print(posts)
            /// Sử dụng toán tử map để biến đổi từ mảng [Posts] -> mảng [PostEntitry]
            let postEntities = posts.map { post in
                return PostEntity(title: post.title,
                                  content: post.content,
                                  address: post.address,
                                  latitude: Int(post.latitude),
                                  longitude: Int(post.longitude),
                                  author: nil,
                                  createdAt: post.createdAt,
                                  updatedAt: post.updatedAt,
                                  isFavorite: post.isFavorite,
                                  isPin: post.isPin,
                                  id: post.id)
            }
            /*
            let authorEntities = authors.map { author in
                
                return UserEntity(username: author.username,
                              createdAt: author.createdAt,
                              updatedAt: author.updatedAt,
                              profile: nil,
                              isAdmin: author.isAdmin,
                              id: author.id)
                
            }
            */
            success?(ArrayResponse(page: page, pageSize: pageSize, results: postEntities))
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            success?(ArrayResponse())
        }
    }
    
    func create(postEntity: PostEntity) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "PostData", in: managedContext)!
        
        let post = PostData(entity: entity, insertInto: managedContext)
        
        post.id = postEntity.id
        post.title = postEntity.title
        post.content = postEntity.content
        post.createdAt = postEntity.createdAt
        post.updatedAt = postEntity.updatedAt
        post.address = postEntity.address
        
        do {
            try managedContext.save()
            print("Save post successfull")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func clear() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PostData")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print("Failed to clear data: \(error)")
        }
    }
    
   
}

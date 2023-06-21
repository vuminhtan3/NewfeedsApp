//
//  FavouriteViewController.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 13/06/2023.
//

import UIKit
import Alamofire
import MBProgressHUD

protocol FavouriteDisplay {
    func getPosts(posts: [PostEntity])
    func loadmorePosts(posts: [PostEntity])
    func callAPIFailure(errorMsg: String?)
    func showLoading(isShow: Bool)
    func hideRefreshLoading()
    func getFavouritePostSuccess(postIDs: [String])
    func getPinPostSuccess(postIDs: [String])
    func favouritePost(postID: String)
    func unFavouritePostSuccess(postID: String)
}

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var posts: [PostEntity]?
    private var presenter: FavouritePresenter!
    private var refresher = UIRefreshControl()
    
    private var cacheImages = [String: UIImage]()
    
    private var favouritePostIDs = [String]()
    private var pinPostIDs = [String]()
    
    override func viewDidLoad() {
        let favouriteService = FavouriteListAPIServiceImpl()
        let favouriteRepository = FavouriteRepositoryImpl(favouriteAPIService: favouriteService)
        let pinService = PinAPIServiceImpl()
        let pinRepository = PinRepositoryImpl(pinAPIService: pinService)
        
        presenter = FavouritePresenterImpl(favouriteRepository: favouriteRepository,
                                           favouriteVC: self,
                                           pinRepository: pinRepository)
        super.viewDidLoad()
        setupTableView()
        presenter.getPosts()
        
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none // Không muốn hiển thị các gạch ngăn cách giữa các cell
        
//        Đăng ký custom UITableViewCell
        let cellID = "HomePostTableViewCell"
        let nib = UINib(nibName: cellID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }
    
    @objc func onRefresh() {
        presenter.refreshPosts()
    }
    
    private func loadImage(link: String, completed: ((UIImage?) -> Void)?) {
        AF.download(link).responseData { [weak self] response in
            guard let self = self else { return }
            if let data = response.value {
                let image = UIImage(data: data)
                self.cacheImages[link] = image
                completed?(image)
            }
        }
    }
}

//MARK: - FavouriteDataSource
extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePostTableViewCell", for: indexPath) as! HomePostTableViewCell
        let post = posts![indexPath.row]
        if let author = post.author, let avatarImg = author.profile?.avatar {
            if let imgCached = cacheImages[avatarImg] {
                cell.authorAvatar(image: imgCached)
            } else {
                loadImage(link: avatarImg) { image in
                    cell.authorAvatar(image: image)
                }
            }
        } else {
            cell.authorAvatar(image: nil)
        }
//        let homepageVC = HomepageViewController()
        let isFavourited = self.favouritePostIDs.contains(where: {$0 == post.id})
        let isPinned = self.pinPostIDs.contains(where: {$0 == post.id})
        cell.favouriteButtonActionHandle = { [weak self] in
            guard let self = self else { return }
            if isFavourited {
                self.presenter.unFavourite(postID: post.id!)
            } else {
                self.presenter.favourite(postID: post.id!)
            }
        }
        cell.pinButtonActionHandle = { [weak self] in
            guard let self = self else {return}
            if isPinned {
                self.presenter.unPin(postID: post.id!)
            } else {
                self.presenter.pin(postID: post.id!)
            }
        }
        
        cell.binData(post: post, isFavourited: isFavourited, isPinned: isPinned)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let posts = posts else {
            return
        }
        
        if indexPath.row == posts.count - 1 {
            self.presenter.loadMorePosts()
        }
    }
    
}

//MARK: - FavouriteDelegate
extension FavouriteViewController: UITableViewDelegate {
    
}

//MARK: - FavouriteDisplay
extension FavouriteViewController: FavouriteDisplay {
    
    func getFavouritePostSuccess(postIDs: [String]) {
        self.favouritePostIDs = postIDs
        self.tableView.reloadData()
    }
    
    func getPinPostSuccess(postIDs: [String]) {
        self.pinPostIDs = postIDs
        self.tableView.reloadData()
    }
    
    func favouritePost(postID: String) {
        self.favouritePostIDs.append(postID)
        self.reloadRow(where: postID)
    }
    
    func unFavouritePostSuccess(postID: String) {
        self.favouritePostIDs.removeAll { id in
            return id == postID
        }
        self.reloadRow(where: postID)
    }
    
    func pinPost(postID: String) {
        self.pinPostIDs.append(postID)
        self.reloadRow(where: postID)
    }
    
    func unPinPostSuccess(postID: String) {
        self.pinPostIDs.removeAll { id in
            return id == postID
        }
        self.reloadRow(where: postID)
    }
    
    func getPosts(posts: [PostEntity]) {
        if posts.isEmpty {
            let messageLb = UILabel(frame: CGRect(x: tableView.frame.midX,
                                                  y: tableView.frame.midY,
                                                  width: tableView.frame.size.width,
                                                  height: tableView.frame.size.height))
            messageLb.text = "You haven't favourited any posts yet"
            messageLb.textColor = .black
            messageLb.numberOfLines = 0
            messageLb.textAlignment = .center
            messageLb.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            messageLb.sizeToFit()
            tableView.backgroundView = messageLb
        } else {
            tableView.backgroundView = nil
        }
        self.posts = posts
        tableView.reloadData()
    }
    
    func loadmorePosts(posts: [PostEntity]) {
        self.posts?.append(contentsOf: posts)
        
        print("Load more post \(posts.count)")
        
        self.tableView.reloadData()
    }
    
    func callAPIFailure(errorMsg: String?) {
        let alert = UIAlertController(title: "Get posts failure", message: errorMsg ?? "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func hideRefreshLoading() {
        refresher.endRefreshing()
    }
    
    func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func reloadRow(where postID: String) {
        if let index = self.posts?.firstIndex(where: {$0.id == postID}) {
            self.tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        }
    }
}

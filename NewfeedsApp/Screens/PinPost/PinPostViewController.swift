//
//  PinPostViewController.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 13/06/2023.
//

import UIKit
import Alamofire
import MBProgressHUD

protocol PinPostDisplay {
    func getPosts(posts: [PostEntity])
    func loadmorePosts(posts: [PostEntity])
    func callAPIFailure(errorMsg: String?)
    func showLoading(isShow: Bool)
    func hideRefreshLoading()
    func pinPost(postID: String)
    func unPinPostSuccess(postID: String)
    func getPinPostSuccess(postIDs: [String])
}

class PinPostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var posts: [PostEntity]?
    private var presenter: PinPostPresenter!
    private var refresher = UIRefreshControl()
    
    private var cacheImages = [String: UIImage]()
    
    private var favoritePostIDs = [String]()
    private var pinPostIDs = [String]()
    
    override func viewDidLoad() {
        let favoriteService = FavoriteListAPIServiceImpl()
        let favoriteRepository = FavoriteRepositoryImpl(favoriteAPIService: favoriteService)
        let pinService = PinAPIServiceImpl()
        let pinRepository = PinRepositoryImpl(pinAPIService: pinService)
        
        presenter = PinPostPresenterImpl(pinRepository: pinRepository,
                                         pinPostVC: self,
                                         favoriteRepository: favoriteRepository)
        
        super.viewDidLoad()
        setupTableView()
        presenter.getInitData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getInitData()
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

//MARK: - PinPostDataSource
extension PinPostViewController: UITableViewDataSource {
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
        
        let isFavorited = self.favoritePostIDs.contains(where: {$0 == post.id})
        let isPinned = self.pinPostIDs.contains(where: {$0 == post.id})
        cell.favoriteButtonActionHandle = { [weak self] in
            guard let self = self else { return }
            if isFavorited {
                self.presenter.unFavorite(postID: post.id!)
            } else {
                self.presenter.favorite(postID: post.id!)
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
        
        cell.binData(post: post, isFavorited: isFavorited, isPinned: isPinned)
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

//MARK: - PinPostDelegate
extension PinPostViewController: UITableViewDelegate {
    
}

//MARK: - PinPostDisplay
extension PinPostViewController: PinPostDisplay {
    
    func getFavoritePostSuccess(postIDs: [String]) {
        self.favoritePostIDs = postIDs
        self.tableView.reloadData()
    }
    
    func getPinPostSuccess(postIDs: [String]) {
        self.pinPostIDs = postIDs
        self.tableView.reloadData()
    }
    
    func favoritePost(postID: String) {
        self.favoritePostIDs.append(postID)
        self.reloadRow(where: postID)
    }
    
    func unFavoritePostSuccess(postID: String) {
        self.favoritePostIDs.removeAll { id in
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
            messageLb.text = "You haven't pinned any posts yet"
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

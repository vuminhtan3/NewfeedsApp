//
//  HomePostTableViewCell.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 14/06/2023.
//

import UIKit

class HomePostTableViewCell: UITableViewCell {

    @IBOutlet weak var authorAvatarImgView: UIImageView!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var authorNameLb: UILabel!
    @IBOutlet weak var createTimeLb: UILabel!
    @IBOutlet weak var postTitleLb: UILabel!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var contentLb: UILabel!
    @IBOutlet weak var favouriteCountLb: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentCountLb: UILabel!
    
    var favouriteButtonActionHandle: (() -> Void)?
    var pinButtonActionHandle: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        resetData()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetData()
    }
    
    private func resetData() {
        authorAvatarImgView.image = nil
        authorNameLb.text = nil
        createTimeLb.text = nil
        postTitleLb.text = nil
        contentLb.text = nil
        favouriteCountLb.text = nil
        commentCountLb.text = nil
    }
    
    func binData(post: PostEntity, isFavourited: Bool, isPinned: Bool) {
        authorNameLb.text = post.author?.username ?? "Unknown"
        postTitleLb.text = post.title
        contentLb.text = post.content
        favouriteCountLb.text = "999"
        commentCountLb.text = "999 comments"
        
        if let createTime = post.createdAt {
            let dateFormater = DateFormatter()
            dateFormater.locale = Locale(identifier: "en_US_POSIX")
            dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormater.date(from: createTime) {
                let resultDateFormater = DateFormatter()
                resultDateFormater.locale = Locale(identifier: "vi_VN")
                resultDateFormater.dateFormat = "dd-MM-yyy HH:mm:ss"
                createTimeLb.text = resultDateFormater.string(from: date)
            }
        }
        if isPinned {
            pinButton.setBackgroundImage(UIImage(systemName: "pin.fill"), for: .normal)
        } else {
            pinButton.setBackgroundImage(UIImage(systemName: "pin"), for: .normal)
        }
        
        if isFavourited {
            favouriteBtn.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favouriteBtn.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func authorAvatar(image: UIImage?) {
        if let image = image {
            authorAvatarImgView.image = image
        } else {
            authorAvatarImgView.image = UIImage(systemName: "person.fill")
        }
    }
    
    //MARK: - PinButtonAction
    @IBAction func pinButtonTapped(_ sender: UIButton) {
        
//        isPinned = !isPinned
        pinButtonActionHandle?()
        
//        if isPinned {
//            pinButton.setBackgroundImage(UIImage(systemName: "pin.fill"), for: .normal)
//        } else {
//            pinButton.setBackgroundImage(UIImage(systemName: "pin"), for: .normal)
//        }
    }
    
//MARK: - FavouriteButtonAction
    @IBAction func favouriteBtnTapped(_ sender: UIButton) {
        
//        isFavourited = !isFavourited
        favouriteButtonActionHandle?()
        
//        if isFavourited {
//            favouriteBtn.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
//        } else {
//            favouriteBtn.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
//        }
    }
    
    @IBAction func commentBtnTapped(_ sender: UIButton) {
    }
}

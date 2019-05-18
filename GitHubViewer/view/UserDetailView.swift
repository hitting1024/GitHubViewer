//
//  UserDetailView.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/18.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import UIKit

import AlamofireImage

/// ユーザー詳細ビュー
class UserDetailView: UIView {
    
    /// オーバーレイ
    @IBOutlet weak var overlayView: UIView!
    
    /// アイコン画像
    @IBOutlet weak var avatarImageView: UIImageView!
    /// フルネーム
    @IBOutlet weak var fullnameLabel: UILabel!
    /// ユーザー名
    @IBOutlet weak var usernameLabel: UILabel!
    /// フォロワー数
    @IBOutlet weak var followersNumLabel: UILabel!
    /// フォロイー数
    @IBOutlet weak var followingNumLabel: UILabel!
    
    /// ナンバーフォーマッター
    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    /// ユーザー詳細情報を設定する
    ///
    /// - Parameter userDetail: ユーザー詳細情報
    func setData(userDetail: UserDetail) {
        let imageFilter = AspectScaledToFillSizeWithRoundedCornersFilter(size: self.avatarImageView.frame.size, radius: 10.0)
        self.avatarImageView?.af_setImage(withURL: userDetail.avatarUrl, placeholderImage: Constants.noImage, filter: imageFilter)
        self.fullnameLabel.text = userDetail.name
        self.usernameLabel.text = userDetail.login
        self.followersNumLabel.text = UserDetailView.numberFormatter.string(from: NSNumber(value: userDetail.followers))
        self.followingNumLabel.text = UserDetailView.numberFormatter.string(from: NSNumber(value: userDetail.following))
        self.overlayView.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNib()
    }
    
    private func loadNib() {
        if let bundle = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil), let view = bundle.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
            self.overlayView.frame = view.frame
            view.addSubview(self.overlayView)
        }
    }
    
}

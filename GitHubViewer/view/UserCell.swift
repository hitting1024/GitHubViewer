//
//  UserCell.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/16.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import UIKit

import AlamofireImage

/// ユーザー一覧用セル
class UserCell: UITableViewCell {
    
    /// ユーザーセルの識別子
    public static let userCellIdentifier = "UserCell"
    /// セルの高さ
    public static let height: CGFloat = 130.0
    
    /// デフォルト画像
    private static let noImage = UIImage(named: "no_image")!
    
    /// アイコン画像
    @IBOutlet weak var avatarImageView: UIImageView!
    /// ユーザー名
    @IBOutlet weak var usernameLabel: UILabel!
    
    /// ユーザー情報をセルに設定する
    ///
    /// - Parameter user: 対象ユーザー
    func setData(user: User) {
        self.usernameLabel.text = user.login
        if let url = URL(string: user.avatarUrl) {
            let imageFilter = AspectScaledToFillSizeWithRoundedCornersFilter(size: self.avatarImageView.frame.size, radius: 10.0)
            self.avatarImageView?.af_setImage(withURL: url, placeholderImage: UserCell.noImage, filter: imageFilter)
        } else {
            self.avatarImageView.image = UserCell.noImage
        }
    }
    
}

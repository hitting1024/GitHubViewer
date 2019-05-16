//
//  UserCell.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/16.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage

/// ユーザー一覧用セル
class UserCell: UITableViewCell {
    
    /// ユーザーセルの識別子
    public static let userCellIdentifier = "UserCell"
    /// セルの高さ
    public static let height: CGFloat = 130.0
    
    /// アイコン画像
    @IBOutlet weak var avatarImageView: UIImageView!
    /// ユーザー名
    @IBOutlet weak var usernameLabel: UILabel!
    
    /// ユーザー情報をセルに設定する
    ///
    /// - Parameter user: 対象ユーザー
    func setData(user: User) {
        self.usernameLabel.text = user.login
        // TODO 画像キャッシュ
        Alamofire.request(user.avatarUrl).responseImage(completionHandler: { response in
            // TODO 失敗時処理
            guard let image = response.result.value else { return }
            self.avatarImageView.image = image.af_imageRounded(withCornerRadius: 10.0)
        })
    }
    
}

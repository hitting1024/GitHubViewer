//
//  UserDetail.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/18.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import Foundation

/// GitHubユーザー詳細
struct UserDetail: Codable {
    
    /// アイコン画像URL
    let avatarUrl: URL
    /// ユーザー名
    let login: String
    /// フルネーム
    let name: String
    /// フォロワー数
    let followers: Int
    /// フォロイー数
    let following: Int

}

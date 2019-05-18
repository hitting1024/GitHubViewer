//
//  User.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/14.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import Foundation

/// GitHubユーザー
struct User: Codable {

    /// アイコン画像URL
    let avatarUrl: URL
    /// ユーザー名
    let login: String
    
}

//
//  Repository.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/18.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import Foundation

/// GitHubリポジトリ
struct Repository: Codable {
    
    /// fork
    let fork: Bool
    /// リポジトリ名
    let name: String
    /// 開発言語
    let language: String
    /// スター数
    let stargazersCount: Int
    /// 説明文
    let description: String
    
}

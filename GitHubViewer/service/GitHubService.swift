//
//  GitHubService.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/14.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import Foundation

import Alamofire

/// GitHub APIを扱うサービス
class GitHubService {
    
    /// GitHubのユーザー検索用URL
    private static let GitHubAPISearchUserURL = "https://api.github.com/search/users"

    /// GitHub APIを用いてユーザー一覧を取得する
    ///
    /// - Parameter completionHandler: GitHubユーザーのリストを渡すコールバック。リストがnilの場合は取得失敗
    class func getUserList(completionHandler: @escaping (Array<User>?) -> Void) {
        Alamofire.request(GitHubAPISearchUserURL, parameters: ["q": "type:user"]).responseJSON(completionHandler: { response in
            guard let jsonData = response.data else {
                completionHandler(nil)
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let users = try? decoder.decode(Users.self, from: jsonData)
            completionHandler(users?.items)
        })
    }
    
    /// GitHubのJSONデータマッピング用ユーザー
    private struct Users: Codable {
        let items: [User]
    }
    
}

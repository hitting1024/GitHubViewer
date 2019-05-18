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
    private static let gitHubAPISearchUserURL = "https://api.github.com/search/users"
    
    /// JSONデコーダ
    private static let jsonDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
    
    /// 次ページ番号抽出用正規表現
    private static let nextPageRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: #"[?&]page=(\d+).*$"#)
    }()

    /// GitHub APIを用いてユーザー一覧を取得する
    ///
    /// - Parameters:
    ///   - page: 取得ページ番号
    ///   - completionHandler: GitHubユーザーのリストおよび次ページ番号を渡すコールバック。リストがnilの場合は取得失敗
    class func getUserList(page: Int, completionHandler: @escaping (Array<User>?, Int?) -> Void) {
        Alamofire.request(gitHubAPISearchUserURL, parameters: ["q": "type:user", "per_page": "100", "page": page]).responseJSON(completionHandler: { response in

            guard let jsonData = response.data else {
                completionHandler(nil, nil)
                return
            }
            let users = try? jsonDecoder.decode(Users.self, from: jsonData)
            let nextPageNum = parseNextPageNum(response.response?.allHeaderFields["Link"] as? String)
            completionHandler(users?.items, nextPageNum)
        })
    }
    
    /// GitHub APIを用いてユーザ詳細を取得する
    ///
    /// - Parameters:
    ///   - url: 対象ユーザ詳細URL
    ///   - completionHandler: GitHubユーザー詳細を渡すコールバック。ユーザー詳細がnilの場合は取得失敗
    class func getUserDetail(url: URL?, completionHandler: @escaping (UserDetail?) -> Void) {
        guard let url = url else {
            completionHandler(nil)
            return
        }
        Alamofire.request(url).responseJSON(completionHandler: { response in
            guard let jsonData = response.data else {
                completionHandler(nil)
                return
            }
            let userDetail = try? jsonDecoder.decode(UserDetail.self, from: jsonData)
            completionHandler(userDetail)
        })
    }
    
    /// GitHub APIを用いて対象リポジトリ一覧(not forked)を取得する
    ///
    /// - Parameters:
    ///   - url: 対象リポジトリURL
    ///   - completionHandler: forkedを除いたGitHubリポジトリのリストおよび次ページ番号を渡すコールバック。リストがnilの場合は取得失敗
    class func getRepositoryList(url: URL?, page: Int, completionHandler: @escaping (Array<Repository>?, Int?) -> Void) {
        guard let url = url else {
            completionHandler(nil, nil)
            return
        }
        Alamofire.request(url, parameters: ["per_page": "100", "page": page]).responseJSON(completionHandler: { response in
            guard let jsonData = response.data else {
                completionHandler(nil, nil)
                return
            }
            let repositories = try? jsonDecoder.decode([Repository].self, from: jsonData)
            let nextPageNum = parseNextPageNum(response.response?.allHeaderFields["Link"] as? String)
            completionHandler(repositories?.filter { return !$0.fork }, nextPageNum)
        })
    }
    
    /// Linkヘッダーから次ページ番号を取得する
    ///
    /// - Parameter linkHeader: Linkヘッダー。以下、フォーマット
    ///                         <https://api.github.com/search/code?q=addClass+user%3Amozilla&page=15>; rel="next",
    ///                         <https://api.github.com/search/code?q=addClass+user%3Amozilla&page=34>; rel="last",
    ///                         <https://api.github.com/search/code?q=addClass+user%3Amozilla&page=1>; rel="first",
    ///                         <https://api.github.com/search/code?q=addClass+user%3Amozilla&page=13>; rel="prev"
    /// - Returns: 次ページ番号。存在しない場合はnil。
    private class func parseNextPageNum(_ linkHeader: String?) -> Int? {
        guard let linkHeader = linkHeader else { return nil }
        let links = linkHeader.components(separatedBy: ",")
        for link in links {
            if !link.contains("rel=\"next\"") {
                continue
            }
            guard let matched = nextPageRegex.firstMatch(in: link, range: NSRange(location: 0, length: link.count)) else { return nil }
            return Int((link as NSString).substring(with: matched.range(at: 1)))
        }
        return nil
    }
    
    /// GitHubのJSONデータマッピング用ユーザー
    private struct Users: Codable {
        let items: [User]
    }
    
}

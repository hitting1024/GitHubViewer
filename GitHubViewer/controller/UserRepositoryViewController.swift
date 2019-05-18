//
//  UserRepositoryViewController.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/18.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import UIKit

import TTGSnackbar

/// ユーザーリポジトリ画面用ViewController
class UserRepositoryViewController: UIViewController {
    
    @IBOutlet weak var userDetailView: UserDetailView!
    @IBOutlet weak var tableView: UITableView!
    
    /// GitHubユーザー
    var user: User!
    
    /// GitHubリポジトリリスト
    private var repositoryList = Array<Repository>()
    /// 検索ページ番号
    private var nextPageNum: Int? = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: RepositoryCell.repositoryCellIdentifier, bundle: nil), forCellReuseIdentifier: RepositoryCell.repositoryCellIdentifier)
        
        // スクロール時の読み込み設定
        self.tableView.addInfiniteScroll(handler: { [weak self] tableView in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self?.loadRepositories(completionHandler: {
                tableView.finishInfiniteScroll()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        })
        // 初回読み込み
        self.loadUserDetail()
        self.tableView.beginInfiniteScroll(true)
    }
    
    /// ユーザー詳細データ取得
    private func loadUserDetail() {
        GitHubService.getUserDetail(url: self.user.url, completionHandler: { userDetail in
            guard let userDetail = userDetail else {
                // 取得失敗ダイアログ表示
                let snackbar = TTGSnackbar(message: "Failed to load data.", duration: .middle)
                snackbar.show()
                return
            }
            self.userDetailView.setData(userDetail: userDetail)
        })
    }
    
    /// リポジトリ一覧データ取得
    ///
    /// - Parameter completionHandler: データ取得完了時に呼び出されるコールバック
    private func loadRepositories(completionHandler: @escaping () -> Void) {
        defer { completionHandler() }

        guard let page = self.nextPageNum else {
            // 全データ取得済み
            return
        }
        GitHubService.getRepositoryList(url: self.user.reposUrl, page: page, completionHandler: { repositoryList, nextPageNum in
            guard let repositoryList = repositoryList else {
                // 取得失敗ダイアログ表示
                let snackbar = TTGSnackbar(message: "Failed to load data.", duration: .middle)
                snackbar.show()
                return
            }
            self.nextPageNum = nextPageNum

            let prevCount = self.repositoryList.count
            self.repositoryList.append(contentsOf: repositoryList)
            // ビュー更新
            let indexPaths = (prevCount..<(prevCount+repositoryList.count)).map { return IndexPath(row: $0, section: 0) }
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexPaths, with: .automatic)
            self.tableView.endUpdates()
        })
    }
    
}

extension UserRepositoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.repositoryCellIdentifier) as! RepositoryCell
        cell.setData(repository: self.repositoryList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RepositoryCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositoryList.count
    }
    
}

extension UserRepositoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

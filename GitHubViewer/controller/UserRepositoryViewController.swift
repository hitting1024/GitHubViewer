//
//  UserRepositoryViewController.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/18.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import UIKit

import StatusCodes

import TTGSnackbar

/// ユーザーリポジトリ画面用ViewController
class UserRepositoryViewController: UIViewController {
    
    @IBOutlet weak var userDetailView: UserDetailView!
    @IBOutlet weak var tableView: UITableView!
    
    /// GitHubユーザー
    var user: User!
    
    /// Segue識別子
    private struct SegueIdentifiers {
        static let showWeb = "showWeb"
    }
    
    /// GitHubリポジトリリスト
    private var repositoryList = Array<Repository>()
    /// 検索ページ番号
    private var nextPageNum: Int? = 1

    /// ターゲットリポジトリ
    private var targetRepository: Repository? = nil

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifiers.showWeb:
            let vc = segue.destination as! WebViewController
            vc.title = self.targetRepository?.fullName
            vc.url = self.targetRepository?.htmlUrl
        default:
            break
        }
    }
    
    /// ユーザー詳細データ取得
    private func loadUserDetail() {
        GitHubService.getUserDetail(url: self.user.url, completionHandler: { status, userDetail in
            if let status = status, status == StatusCodes.Code401Unauthorised.code {
                // 不正な認証情報
                // リポジトリ一覧データ取得側で対応
                return
            }

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
        GitHubService.getRepositoryList(url: self.user.reposUrl, page: page, completionHandler: { status, repositoryList, nextPageNum in
            if let status = status, status == StatusCodes.Code401Unauthorised.code {
                // 不正な認証情報
                GitHubUtil.handleInvalidToken()
                // 再読み込み
                self.loadUserDetail()
                self.loadRepositories(completionHandler: completionHandler)
                return
            }

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
        self.targetRepository = self.repositoryList[indexPath.row]
        self.performSegue(withIdentifier: SegueIdentifiers.showWeb, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

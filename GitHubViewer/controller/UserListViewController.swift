//
//  ViewController.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/14.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import UIKit

import TTGSnackbar
import SCLAlertView

/// ユーザー一覧画面用ViewController
class UserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    /// Segue識別子
    private struct SegueIdentifiers {
        static let showUserRepository = "showUserRepository"
    }
    /// GitHubユーザリスト
    private var userList = Array<User>()
    /// 検索ページ番号
    private var nextPageNum: Int? = 1
    
    /// ターゲットユーザー
    private var targetUser: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: UserCell.userCellIdentifier, bundle: nil), forCellReuseIdentifier: UserCell.userCellIdentifier)
        
        // スクロール時の読み込み設定
        self.tableView.addInfiniteScroll(handler: { [weak self] tableView in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self?.loadData(completionHandler: {
                tableView.finishInfiniteScroll()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        })
        // 初回読み込み
        self.tableView.beginInfiniteScroll(true)
        
        // Personal Access Tokenが保存されていない場合は、保存ダイアログを表示する
        if GitHubUtil.getPersonalAccessToken() == nil {
            self.showConfig(self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifiers.showUserRepository:
            let vc = segue.destination as! UserRepositoryViewController
            vc.user = self.targetUser
        default:
            break
        }
    }
    
    /// ユーザー一覧データ取得
    ///
    /// - Parameter completionHandler: データ取得完了時に呼び出されるコールバック
    private func loadData(completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        
        guard let page = self.nextPageNum else {
            // 全データ取得済み
            return
        }
        GitHubService.getUserList(page: page, completionHandler: { userList, nextPageNum in
            guard let userList = userList else {
                // 取得失敗ダイアログ表示
                let snackbar = TTGSnackbar(message: "Failed to load data.", duration: .middle)
                snackbar.show()
                return
            }
            self.nextPageNum = nextPageNum

            let prevCount = self.userList.count
            self.userList.append(contentsOf: userList)
            // ビュー更新
            let indexPaths = (prevCount..<(prevCount+userList.count)).map { return IndexPath(row: $0, section: 0) }
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexPaths, with: .automatic)
            self.tableView.endUpdates()
        })
    }

}

// MARK: Action
extension UserListViewController {

    /// GitHubのpersonal access tokenを保存するためのダイアログを表示
    @IBAction func showConfig(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(kWindowWidth: self.view.frame.width - 70, showCloseButton: false, buttonsLayout: .horizontal)
        let alert = SCLAlertView(appearance: appearance)
        let textField = alert.addTextField("New personal access token")
        alert.addButton("Cancel", backgroundColor: UIColor.darkGray, action: {})
        alert.addButton("Save") {
            GitHubUtil.savePersonalAccessToken(token: textField.text)
        }
        alert.showInfo("Config", subTitle: "Authenticated requests get a higher rate limit. Please enter your GitHub's personal access token.")
    }

}

extension UserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.userCellIdentifier) as! UserCell
        cell.setData(user: self.userList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserCell.height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
}

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.targetUser = self.userList[indexPath.row]
        self.performSegue(withIdentifier: SegueIdentifiers.showUserRepository, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//
//  ViewController.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/14.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import UIKit

/// ユーザー一覧画面用ViewController
class UserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    /// GitHubユーザリスト
    private var userList = Array<User>()
    /// 検索ページ番号
    private var nextPageNum: Int? = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: UserCell.userCellIdentifier, bundle: nil), forCellReuseIdentifier: UserCell.userCellIdentifier)
        
        // スクロール時の読み込み設定
        self.tableView.addInfiniteScroll(handler: { [weak self] tableView in
            self?.loadData(completionHandler: {
                tableView.finishInfiniteScroll()
            })
        })
        // 初回読み込み
        self.tableView.beginInfiniteScroll(true)
    }
    
    /// ユーザー一覧データ取得
    ///
    /// - Parameter completionHandler: データ取得完了時に呼び出されるコールバック
    private func loadData(completionHandler: @escaping () -> Void) {
        GitHubService.getUserList(page: self.nextPageNum, completionHandler: { userList, nextPageNum in
            defer { completionHandler() }
            
            self.nextPageNum = nextPageNum
            guard let userList = userList else {
                // TODO 取得失敗ダイアログ表示
                return
            }
            
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

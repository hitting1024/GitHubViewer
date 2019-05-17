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
        self.loadData()
    }
    
    /// ユーザー一覧データ取得
    private func loadData() {
        GitHubService.getUserList(page: self.nextPageNum, completionHandler: { userList, nextPageNum in
            self.nextPageNum = nextPageNum
            guard let userList = userList else {
                // TODO 取得失敗ダイアログ表示
                return
            }
            userList.forEach({ user in
                self.userList.append(user)
            })
            self.tableView.reloadData()
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

//
//  RepositoryCell.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/18.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import UIKit

/// リポジトリ一覧用セル
class RepositoryCell: UITableViewCell {
    
    /// ユーザーセルの識別子
    public static let repositoryCellIdentifier = "RepositoryCell"
    /// セルの高さ
    public static let height: CGFloat = 100.0
    
    @IBOutlet weak var repositoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starNumLabel: UILabel!

    /// ナンバーフォーマッター
    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    /// リポジトリ情報をセルに設定する
    ///
    /// - Parameter repository: 対象リポジトリ
    func setData(repository: Repository) {
        self.repositoryLabel.text = repository.name
        self.descriptionLabel.text = repository.description
        self.languageLabel.text = repository.language
        self.starNumLabel.text = RepositoryCell.numberFormatter.string(from: NSNumber(value: repository.stargazersCount))
    }
    
}

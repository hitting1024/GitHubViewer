//
//  GitHubUtil.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/20.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import Foundation

import SCLAlertView

/// GitHub用ユーティリティ
class GitHubUtil {
    
    /// Personal Access Token保存用キー
    private static let personalAccessTokenKey = "personalAccessTokenKey"
    
    /// Personl Access Tokenを保存する
    ///
    /// - Parameter token: 対象のトークン
    class func savePersonalAccessToken(token: String?) {
        guard let token = token else { return }
        if !token.isEmpty {
            UserDefaults.standard.set(token, forKey: personalAccessTokenKey)
        }
    }
    
    /// Personal Access Tokenを取得する
    ///
    /// - Returns: 保存されているトークン。保存されていない場合はnil
    class func getPersonalAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: personalAccessTokenKey)
    }
    
    /// 保存されているPersonal Access Tokenを削除する
    class func clearPersonalAccessToken() {
        UserDefaults.standard.removeObject(forKey: personalAccessTokenKey)
    }
    
    /// 不正な認証情報時の対応
    class func handleInvalidToken() {
        GitHubUtil.clearPersonalAccessToken()
        let alert = SCLAlertView(appearance: Constants.sCLAlertViewAppearance)
        alert.addButton("OK", action: {})
        alert.showWarning("Invalid Personal Access Token", subTitle: "Please re-enter your GitHub's personal access token.")
    }
    
}

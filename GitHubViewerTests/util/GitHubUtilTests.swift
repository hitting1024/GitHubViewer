//
//  GitHubUtilTests.swift
//  GitHubViewerTests
//
//  Created by hitting on 2019/05/20.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import XCTest

@testable import GitHubViewer

/// GitHubUtilのテストケース
class GitHubUtilTests: XCTestCase {

    /// Personal Access Token保存用キー
    private static let personalAccessTokenKey = "personalAccessTokenKey"

    override func setUp() {
        // nothing
    }

    override func tearDown() {
        // 対象データ削除
        UserDefaults.standard.removeObject(forKey: GitHubUtilTests.personalAccessTokenKey)
    }

    /// トークンとしてnilを保存するテスト
    func testSavePersonalAccessToken01() {
        let token: String? = nil
        GitHubUtil.savePersonalAccessToken(token: token)
        let actual = UserDefaults.standard.string(forKey: GitHubUtilTests.personalAccessTokenKey)
        XCTAssertNil(actual)
    }

    /// トークンとして空文字を保存するテスト
    func testSavePersonalAccessToken02() {
        let token: String? = ""
        GitHubUtil.savePersonalAccessToken(token: token)
        let actual = UserDefaults.standard.string(forKey: GitHubUtilTests.personalAccessTokenKey)
        XCTAssertNil(actual)
    }

    /// トークンとして文字列を保存するテスト
    func testSavePersonalAccessToken03() {
        let token: String? = "token"
        GitHubUtil.savePersonalAccessToken(token: token)
        let actual = UserDefaults.standard.string(forKey: GitHubUtilTests.personalAccessTokenKey)
        XCTAssertEqual(actual, token)
    }

    /// 何も保存されていない状態でトークンを取得するテスト
    func testGetPersonalAccessToken01() {
        let actual = GitHubUtil.getPersonalAccessToken()
        XCTAssertNil(actual)
    }

    /// 保存されたトークンを取得するテスト
    func testGetPersonalAccessToken02() {
        let token = "token"
        UserDefaults.standard.set(token, forKey: GitHubUtilTests.personalAccessTokenKey)
        let actual = GitHubUtil.getPersonalAccessToken()
        XCTAssertEqual(actual, token)
    }
    
    /// 保存されたトークンを削除するテスト
    func testClearPersonalAccessToken01() {
        let token = "token"
        UserDefaults.standard.set(token, forKey: GitHubUtilTests.personalAccessTokenKey)
        GitHubUtil.clearPersonalAccessToken()
        let actual = UserDefaults.standard.string(forKey: GitHubUtilTests.personalAccessTokenKey)
        XCTAssertNil(actual)
    }
    
    /// 保存されたトークンが削除されていることをテスト
    func testHandleInvalidToken01() {
        let token = "token"
        UserDefaults.standard.set(token, forKey: GitHubUtilTests.personalAccessTokenKey)
        GitHubUtil.handleInvalidToken()
        let actual = UserDefaults.standard.string(forKey: GitHubUtilTests.personalAccessTokenKey)
        XCTAssertNil(actual)
    }
    
}

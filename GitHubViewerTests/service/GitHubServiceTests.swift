//
//  GitHubServiceTests.swift
//  GitHubViewerTests
//
//  Created by hitting on 2019/05/20.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import XCTest

@testable import GitHubViewer

/// GitHubServiceのテストケース
class GitHubServiceTests: XCTestCase {

    /// Personal Access Token (テスト実行前に設定)
    private static let personalAccessToken = ""
    ///
    
    /// Personal Access Token保存用キー
    private static let personalAccessTokenKey = "personalAccessTokenKey"

    /// GitHubのユーザー詳細(hitting1024)URL
    private static let gitHubAPIUserDetailURL = URL(string: "https://api.github.com/users/hitting1024")!
    /// GitHubのユーザー(hitting1024)リポジトリURL
    private static let gitHubAPIReposURL = URL(string: "https://api.github.com/users/hitting1024/repos")!
    /// GitHub API以外のJSONを返さないURL
    private static let noGitHubAPIURL = URL(string: "https://github.com")!
    
    override func setUp() {
        if !GitHubServiceTests.personalAccessToken.isEmpty {
            UserDefaults.standard.set(GitHubServiceTests.personalAccessToken, forKey: GitHubServiceTests.personalAccessTokenKey)
        }
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: GitHubServiceTests.personalAccessTokenKey)
    }
    
    /// 正常取得のテスト
    func testGetUserList01() {
        let expect = expectation(description: "async test")
        GitHubService.getUserList(page: 2, completionHandler: { status, userList, nextPageNum in
            XCTAssertEqual(status, 200)
            XCTAssertEqual(userList?.count, 100)
            XCTAssertEqual(nextPageNum, 3)
            expect.fulfill()
        })
        waitForExpectations(timeout: 5) { (error) in
            if error != nil {
                XCTFail()
            }
        }
    }
    
    /// トークン不正時のテスト
    func testGetUserList02() {
        UserDefaults.standard.set("InvalidToken", forKey: GitHubServiceTests.personalAccessTokenKey)

        let expect = expectation(description: "async test")
        GitHubService.getUserList(page: 2, completionHandler: { status, userList, nextPageNum in
            XCTAssertEqual(status, 401)
            XCTAssertNil(userList)
            XCTAssertNil(nextPageNum)
            expect.fulfill()
        })
        waitForExpectations(timeout: 5) { (error) in
            if error != nil {
                XCTFail()
            }
        }
    }

    /// 正常取得のテスト
    func testGetUserDetail01() {
        let expect = expectation(description: "async test")
        GitHubService.getUserDetail(url: GitHubServiceTests.gitHubAPIUserDetailURL, completionHandler: { status, userDetail in
            XCTAssertEqual(status, 200)
            XCTAssertNotNil(userDetail)
            XCTAssertEqual(userDetail?.login, "hitting1024")
            expect.fulfill()
        })
        waitForExpectations(timeout: 5) { (error) in
            if error != nil {
                XCTFail()
            }
        }
    }
    
    /// トークン不正時のテスト
    func testGetUserDetail02() {
        UserDefaults.standard.set("InvalidToken", forKey: GitHubServiceTests.personalAccessTokenKey)

        let expect = expectation(description: "async test")
        GitHubService.getUserDetail(url: GitHubServiceTests.gitHubAPIUserDetailURL, completionHandler: { status, userDetail in
            XCTAssertEqual(status, 401)
            XCTAssertNil(userDetail)
            expect.fulfill()
        })
        waitForExpectations(timeout: 5) { (error) in
            if error != nil {
                XCTFail()
            }
        }
    }
    
    /// GitHub API以外のURLテスト
    func testGetUserDetail03() {
        let expect = expectation(description: "async test")
        GitHubService.getUserDetail(url: GitHubServiceTests.noGitHubAPIURL, completionHandler: { status, userDetail in
            XCTAssertEqual(status, 200)
            XCTAssertNil(userDetail)
            expect.fulfill()
        })
        waitForExpectations(timeout: 5) { (error) in
            if error != nil {
                XCTFail()
            }
        }
    }
    
    /// 正常取得のテスト
    func testGetRepositoryList01() {
        let expect = expectation(description: "async test")
        GitHubService.getRepositoryList(url: GitHubServiceTests.gitHubAPIReposURL, page: 1, completionHandler: { status, repositoryList, nextPageNum in
            XCTAssertEqual(status, 200)
            XCTAssertNotNil(repositoryList)
            if let list = repositoryList {
                XCTAssertGreaterThan(list.count, 0)
            }
            XCTAssertNil(nextPageNum)
            expect.fulfill()
        })
        waitForExpectations(timeout: 5) { (error) in
            if error != nil {
                XCTFail()
            }
        }
    }
    
    /// トークン不正時のテスト
    func testGetRepositoryList02() {
        UserDefaults.standard.set("InvalidToken", forKey: GitHubServiceTests.personalAccessTokenKey)

        let expect = expectation(description: "async test")
        GitHubService.getRepositoryList(url: GitHubServiceTests.gitHubAPIReposURL, page: 1, completionHandler: { status, repositoryList, nextPageNum in
            XCTAssertEqual(status, 401)
            XCTAssertNil(repositoryList)
            XCTAssertNil(nextPageNum)
            expect.fulfill()
        })
        waitForExpectations(timeout: 5) { (error) in
            if error != nil {
                XCTFail()
            }
        }
    }
    
    /// GitHub API以外のURLテスト
    func testGetRepositoryList03() {
        let expect = expectation(description: "async test")
        GitHubService.getRepositoryList(url: GitHubServiceTests.noGitHubAPIURL, page: 1, completionHandler: { status, repositoryList, nextPageNum in
            XCTAssertEqual(status, 200)
            XCTAssertNil(repositoryList)
            XCTAssertNil(nextPageNum)
            expect.fulfill()
        })
        waitForExpectations(timeout: 5) { (error) in
            if error != nil {
                XCTFail()
            }
        }
    }
    
}

//
//  Constants.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/18.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import Foundation

import SCLAlertView

/// 定数
class Constants {

    /// 画像なし
    public static let noImage = UIImage(named: "no_image")!
    
    /// SCLAlertViewの外観
    public static let sCLAlertViewAppearance = SCLAlertView.SCLAppearance(kWindowWidth: UIScreen.main.bounds.size.width - 70, showCloseButton: false, buttonsLayout: .horizontal)

}

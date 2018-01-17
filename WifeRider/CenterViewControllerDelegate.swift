//
//  CenterViewControllerDelegate.swift
//  WifeRider
//
//  Created by 何品泰高 on 2018/1/17.
//  Copyright © 2018年 何品泰高. All rights reserved.
//

import UIKit

protocol CenterViewControllerDelegate {
    func toggleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand:Bool)
}


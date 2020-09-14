//
//  Menu.swift
//  CarManagement
//
//  Created by namnt on 8/21/20.
//  Copyright © 2020 namnt. All rights reserved.
//

import Foundation
import DropDown

struct Menu {
    let vehicleStatusMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Tất cả",
            "Đang chạy",
            "Mất tín hiệu",
            "Dừng đỗ",
            "Tắt máy"
        ]
        return menu
    }()
    
    let optionMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Thêm",
            "Xoá",
        ]
        
        return menu
    }()
    
    
}

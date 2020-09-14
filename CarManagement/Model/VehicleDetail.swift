//
//  VehicleInfo.swift
//  CarManagement
//
//  Created by namnt on 8/21/20.
//  Copyright © 2020 namnt. All rights reserved.
//

import Foundation

struct VehicleDetail {
    var licensePlate: String?
    var wareHouseName: String?
    var weight: String?
    var status: String?
    var driver: String?
    var distance: String?
    var IMEI: String?
    var phoneNumber: String?
    var speed: String?
    var validate: String?
    
    var vehicleID: String?

    func getStatus() -> Int {
        switch status {
        case "Tất cả":
            return 0
        case "Đang chạy":
            return 1
        case "Mất tín hiệu":
            return 2
        case "Dừng xe":
            return 3
        case "Tắt máy":
            return 4
        default:
            return 0
        }
    }
    
    init() {
        licensePlate = ""
        weight = "0.0"
        wareHouseName = "NaN"
        status = "NaN"
        driver = ""
        distance = "0.0"
        IMEI = "NaN"
        phoneNumber = "NaN"
        validate = ""
        vehicleID = ""
        speed = ""
    }
    
    func getArray() -> [String] {
        var arr: [String] = []
        arr.append(self.licensePlate ?? "")
        arr.append(self.wareHouseName ?? "")
        arr.append(self.weight ?? "")
        arr.append(self.status ?? "")
        arr.append(self.driver ?? "")
        arr.append(self.speed ?? "")
        arr.append(self.distance ?? "NaN")
        arr.append(self.IMEI ?? "")
        arr.append(self.phoneNumber ?? "")
        arr.append(self.validate ?? "")
        return arr
    }
    
    var title = [
        "Biển số",
        "Kho",
        "Tải trọng",
        "Trạng thái",
        "Tài xế",
        "Tốc độ",
        "KM trong ngày",
        "IMEI",
        "Số điện thoại",
        "Ngày gia hạn"
    ]
    
}

//
//  VehicleData.swift
//  CarManagement
//
//  Created by namnt on 9/4/20.
//  Copyright © 2020 namnt. All rights reserved.
//

import Foundation

//MARK: - Vehicle List Data Decoder

struct VehicleListData: Codable {
    let data: [License]

}

struct License: Codable {
    let license_plate: String?
    let tracker: [Tracker]
    
}

struct Tracker: Codable {
    let place: String?
    let gps_speed: Float?
}

//MARK: -Vehicle Detail Data Decoder

struct VehicleDetailData: Codable {
    let data: [Detail]
}

struct Detail: Codable {
    let capacity: String?
    let license_plate: String
    let total_distance_of_day: String?
    let imei: String
    let status: String
    let expiration_date: [String]
    let tel: [String]
    let station_name: [String]
    let driver: [Driver]
    let tracker: Tracker
}

struct Driver: Codable {
    let name: String
}

//MARK: - Distance Data Decoder
struct VehicleDistanceData: Decodable {
    let data: [Distance]
}

struct Distance: Decodable {
    let distance: Float?
}

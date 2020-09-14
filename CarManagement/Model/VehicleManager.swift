//
//  VehicleManager.swift
//  CarManagement
//
//  Created by namnt on 9/4/20.
//  Copyright © 2020 namnt. All rights reserved.
//

import Foundation


//MARK: - Vehicle List Manager

protocol VehicleListManagerDelegate {
    func updateVehicleList(with vehicles: [VehicleListInfo])
}

struct VehicleListInfo {
    var license_plate: String
    var vehicle_place: String
}

struct VehicleListManager {
    var access_token = ""
    var contentType = "application/x-www-form-urlencoded"
    
    var delegate: VehicleListManagerDelegate?
    
    func getListVehicle () {
        let url = "https://thietbi.ghtk.vn/api/vehicle/getCurrent"
        self.performRequest(urlString: url)
    }
    
    func performRequest (urlString: String) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            request.addValue(access_token, forHTTPHeaderField: "x-access-token")
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let errors = error {
                    print(errors)
                    return
                }
                
                if let safeData = data {
                    let vehicleList = self.parseListVehicle(safeData)
                    self.delegate?.updateVehicleList(with: vehicleList)
                }
                
            }
            
            task.resume()
            
        }
    }
    
    func parseListVehicle (_ vehicleList: Data) -> [VehicleListInfo] {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(VehicleListData.self, from: vehicleList)
            var list = [VehicleListInfo] ()
            for vehicle in decodeData.data {
                if vehicle.license_plate != nil {
                    let licensePlate = vehicle.license_plate!
                    let place = vehicle.tracker.count > 0 ? vehicle.tracker[0].place! : "Unknown"
                    list.append(VehicleListInfo(license_plate: licensePlate, vehicle_place: place))
                }
            }
            return list
        }
        catch {
            print(error)
            return []
        }
    }
    
}

//MARK: -Vehicle Detail Manager

protocol VehicleDetailManagerDelegate {
    func updateUI (with newVehicle: VehicleDetail?)
    
    func updateDistance (with distance: Float)
}

struct VehicleDetailManager {
    var access_token = ""
    var contentType = "application/x-www-form-urlencoded"
    
    var delegate: VehicleDetailManagerDelegate?
    
    func getVehicleDetail (withLicensePlate licensePlate: String) {
        let url = "https://thietbi.ghtk.vn/api/vehicle/search?license_plate=\(licensePlate)"
        //print(url)
        self.performRequest(urlString: url)
    }
    
    func performRequest (urlString: String) {
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            request.addValue(access_token, forHTTPHeaderField: "x-access-token")
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let errors = error {
                    print(errors)
                    return
                }
                
                if let safeData = data {
                    let vehicle = self.parseVehicleDetail(safeData)
                    self.delegate?.updateUI(with: vehicle)
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseVehicleDetail(_ data: Data) -> VehicleDetail? {
        let decoder = JSONDecoder()
        
        do {
            let vehicleDetail = try decoder.decode(VehicleDetailData.self, from: data)
            
            var newVehicle = VehicleDetail()
            
            if vehicleDetail.data.count == 0 { return newVehicle }
            
            let vehicle = vehicleDetail.data[0]
            
            newVehicle.licensePlate = vehicle.license_plate
            newVehicle.distance = vehicle.total_distance_of_day
            newVehicle.driver = (vehicle.driver.count != 0 ? vehicle.driver[0].name : "")
            newVehicle.IMEI = vehicle.imei
            newVehicle.status = vehicle.status
            newVehicle.phoneNumber = vehicle.tel.count != 0 ? vehicle.tel[0] : nil
            newVehicle.weight = vehicle.capacity
            newVehicle.wareHouseName = (vehicle.station_name.count != 0 ? vehicle.station_name[0] : nil)
            newVehicle.validate = (vehicle.expiration_date.count != 0 ? vehicle.expiration_date[0] : nil)
            newVehicle.speed = String(format: "%.2f km/h", Float(vehicle.tracker.gps_speed!))
            
            return newVehicle
            
        }
        catch {
            print(error)
            return nil
        }
    }
    
    //  get distance in day
    func getDistance(withLicensePlate licensePlate: String) {
        
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fromDate = formatter.string(from: date)
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let toDate = formatter.string(from: date)
        
        let url = "https://thietbi.ghtk.vn/api/vehicle/getVehicleRoute/\(licensePlate)?from=\(fromDate)&to=\(toDate)"
        self.requestRoute(urlString: url)
    }
    
    func requestRoute (urlString: String) {
        guard let urll = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return}

        if let url = URL(string: urll) {
            var request = URLRequest(url: url)
            
            request.addValue(access_token, forHTTPHeaderField: "x-access-token")
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let errors = error {
                    print(errors)
                    return
                }
                
                //print(String(data: data!, encoding: .utf8)!)
                if let safeData = data {
                    let distance = self.parseRoute(safeData)
                    self.delegate?.updateDistance(with: distance)
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseRoute(_ data: Data) -> Float {
        let decoder = JSONDecoder()
        
        do {
            let distance = try decoder.decode(VehicleDistanceData.self, from: data)
            var value: Float = 0.0
            
            if (distance.data.count == 0) {
                return value
            }
            
            for dis in distance.data {
                value += dis.distance ?? 0.0
            }
            return value
        }
        catch {
            print(error)
            return 0.0
        }
    }
    
}

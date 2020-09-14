//
//  InfoViewController.swift
//  CarManagement
//
//  Created by namnt on 8/21/20.
//  Copyright © 2020 namnt. All rights reserved.
//

import UIKit

let getStatus: [String: String] = [
    "1": "Tắt máy",
    "2": "Dừng đỗ",
    "3": "Đang chạy",
    "4": "Mất tín hiệu",
]

class VehicleDetailViewController: UIViewController {

    @IBOutlet weak var userInfoTable: UITableView!
    
    var vehicleIndex: Int?
    var vehicleLicensePlate: String?
    var vehicle: VehicleDetail?
    
    var vehicleDetailManager = VehicleDetailManager()
    var dateFormatter = DateFormatter()
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDateFormatter()
        
        vehicleDetailManager.delegate = self
        
        vehicleDetailManager.getVehicleDetail(withLicensePlate: vehicleLicensePlate!)
        vehicleDetailManager.getDistance(withLicensePlate: vehicleLicensePlate!)
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            self.vehicleDetailManager.getVehicleDetail(withLicensePlate: self.vehicleLicensePlate!)
        })
        
        navigationItem.title = vehicleLicensePlate
        userInfoTable.dataSource = self
        userInfoTable.delegate = self
    }
    
    func setDateFormatter() {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "EditVehicle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditVehicle" {
            let destinationVC = segue.destination as! EditViewController
            destinationVC.vehicleIndex = self.vehicleIndex
            destinationVC.VehicleDetailVC = self
            destinationVC.SegueIdentifier = segue.identifier
        }
    }
    
}


extension VehicleDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicle?.title.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "XCell", for: indexPath)
        let detail = vehicle?.getArray()
        
        cell.textLabel?.text = vehicle?.title[indexPath.row]
        cell.detailTextLabel?.text = detail?[indexPath.row]
        
        return cell
    }
    
}

extension VehicleDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension VehicleDetailViewController: VehicleDetailManagerDelegate {
    
    func updateUI(with newVehicle: VehicleDetail?) {
        self.vehicle = newVehicle
        
        vehicle?.status = getStatus[(newVehicle?.status)!] ?? ""
        let dateStr = newVehicle?.validate ?? "00/00/00"
        let date = dateFormatter.date(from: dateStr)
        vehicle?.validate = date != nil ? dateFormatter.string(from: date!) : ""

    }
    
    func updateDistance(with distance: Float) {
        self.vehicle?.distance = String(format: "%.2f km", Float(distance))
        
        DispatchQueue.main.async {
            self.userInfoTable.reloadData()
        }
    }
    
}

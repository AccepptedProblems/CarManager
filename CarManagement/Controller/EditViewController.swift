//
//  EditViewController.swift
//  CarManagement
//
//  Created by namnt on 8/25/20.
//  Copyright © 2020 namnt. All rights reserved.
//

import UIKit

struct EditObject {
    var title = ""
    var placeholder = ""
    var value = ""
    var isShow = false
}


class EditViewController: UIViewController {
    
    var dateFormatter = DateFormatter()
    var SegueIdentifier: String?
    var vehicleIndex: Int?
    
    
    var editList = [EditObject]()
    
    
    @IBOutlet weak var editTableView: UITableView!
    var VehicleListVC: VehicleListViewController?
    var VehicleDetailVC: VehicleDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()

        // Setup Table view
        editTableView.delegate = self
        editTableView.dataSource = self
        
        editTableView.estimatedRowHeight = 80
        editTableView.rowHeight = UITableView.automaticDimension
        editTableView.tableFooterView = UIView()
        
        
        
        // Date formatter
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }
    
    func setupTable() {
        editList.append(EditObject(title: "License", placeholder: "Input license"))
        editList.append(EditObject(title: "Tải trọng", placeholder: "Input Weight"))
        editList.append(EditObject(title: "IMEI", placeholder: "Input Imei"))
        editList.append(EditObject(title: "Phone number", placeholder: "Input phone number"))
        editList.append(EditObject(title: "Ngày gia hạn", placeholder: ""))
        
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {

        guard let segueID = SegueIdentifier else {return}
        
//        let newVehicle = getEditedDetail()
        
        if segueID == "AddVehicle" {
            let alert = UIAlertController(title: "Thêm vào danh sách?", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Thêm", style: .default) {(action) in
                //VehicleData.vehicleArray.vehicle?.append(newVehicle)
                self.VehicleListVC!.vehicleTableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
            alert.addAction(action)
            
            present(alert, animated: true)
        }
        
        
        if segueID == "EditVehicle" {
            let alert = UIAlertController(title: "Xác nhận lần nữa nè", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) {(action) in
                //VehicleData.vehicleArray.vehicle?[self.vehicleIndex!] = newVehicle
                self.VehicleDetailVC!.userInfoTable.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
            alert.addAction(action)
            present(alert, animated: true)
            
        }

    }
    
    func getEditedDetail() -> VehicleDetail {
        
        for index in 0...3 {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = editTableView.cellForRow(at: indexPath) as! WeightViewCell
            editList[index].value = cell.textField.text ?? ""
        }
        
        let indexPath = IndexPath(row: 4, section: 0)
        let cell = editTableView.cellForRow(at: indexPath) as! ValidateCell
        editList[4].value = cell.valueDate.text!
        
        var newVehicle = VehicleDetail()
        newVehicle.licensePlate = editList[0].value
        newVehicle.weight = editList[1].value
        newVehicle.IMEI = editList[2].value
        newVehicle.phoneNumber = editList[3].value
        newVehicle.validate = editList[4].value
        
        return newVehicle
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: - TableView Delegate & DataSources Method
extension EditViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == editList.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "validate", for: indexPath) as! ValidateCell
            
            let object = editList[indexPath.row]
            
            let dateStr = dateFormatter.string(from: cell.datePicker.date)
            
            cell.setUI(title: object.title, value: dateStr, status: object.isShow)
            editList[indexPath.row].value = cell.valueDate.text ?? ""
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "weight", for: indexPath) as! WeightViewCell
            let object = editList[indexPath.row]
            
            cell.setUI(titleString: object.title, placeholder: object.placeholder, value: object.value)
            editList[indexPath.row].value = cell.textField.text ?? ""
            
            return cell
        }
    }

}

extension EditViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         //tableView.deselectRow(at: indexPath, animated: false)
        
        let lastIndex = editList.count - 1
      
        if indexPath.row == lastIndex {
            editList[lastIndex].isShow = !editList[lastIndex].isShow
            tableView.reloadRows(at: [IndexPath(row: lastIndex, section: 0)], with: .fade)
        } else {
            if editList[lastIndex].isShow == true {
                editList[lastIndex].isShow = false
                tableView.reloadRows(at: [IndexPath(row: lastIndex, section: 0)], with: .fade)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }

}

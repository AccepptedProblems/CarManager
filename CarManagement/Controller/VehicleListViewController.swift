//
//  ViewController.swift
//  CarManagement
//
//  Created by namnt on 8/25/20.
//  Copyright © 2020 namnt. All rights reserved.
//

import UIKit

class VehicleListViewController: UIViewController {
    
    var vehicleList: [VehicleListInfo]?
    var filteredVehiclelist: [VehicleListInfo]?
    
    
    var menu = Menu()
    var timer: Timer?
    @IBOutlet weak var vehicleTableView: UITableView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var vehicleManager = VehicleListManager()
    
    var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return !isSearchBarEmpty && !searchView.isHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navBar = navigationController?.navigationBar else {return}
        
        // Initialize search bar
        searchView.isHidden = true
        searchBar.delegate = self
        
        //Get data from API
        vehicleManager.delegate = self
        
        vehicleManager.getListVehicle()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            self.vehicleManager.getListVehicle()
        })
        
        // Menu method in View
        menuMethod(navBar)
        
        // Set up navigation not editing mode bar
        normalModeNavigationBar()
        
        vehicleTableView.delegate = self
        vehicleTableView.dataSource = self
        vehicleTableView.allowsMultipleSelectionDuringEditing = true
        
        // set up constraint
        vehicleTableView.estimatedRowHeight = 65
        vehicleTableView.rowHeight = UITableView.automaticDimension
        vehicleTableView.tableFooterView = UIView()
        
        initializeHideKeyboard()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        tableBottomConstraint.constant = keyboardSize.height
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        tableBottomConstraint.constant = CGFloat(0)
    }
    
    @objc func searchTapped () {
        UIView.animate(withDuration: 0.4) {
            self.searchView.isHidden = !self.searchView.isHidden
            if self.searchView.isHidden {
                self.searchBar.endEditing(true)
            }
        }
        //searchView.isHidden = !searchView.isHidden
        
    }
    
    @objc func optionTapped () {
        menu.optionMenu.show()
    }
    
    @IBAction func ststusButtonPressed(_ sender: UIButton) {
        menu.vehicleStatusMenu.show()
    }
    
    func menuMethod(_ navBar: UINavigationBar) {
        
        //set menu anchor
        menu.optionMenu.anchorView = navBar
        menu.vehicleStatusMenu.anchorView = statusButton
        
        //set action in menu
        menu.optionMenu.selectionAction = { index, title in
            if title == "Thêm" {
                self.performs_segue()
            } else {
                self.editting_vehicle()
            }
        }
        
        menu.vehicleStatusMenu.selectionAction = {index, title in
            self.statusButton.setTitle(title, for: .normal)
        }
    }
    
    func editting_vehicle() {
        vehicleTableView.isEditing = !vehicleTableView.isEditing
        edittingModeNavigationBar()
    }
    
    func performs_segue() {
        performSegue(withIdentifier: "AddVehicle", sender: self)
    }
    
    //MARK: - Editting Mode Method
    func edittingModeNavigationBar () {
        let done = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(delete_vehicle))
        navigationItem.rightBarButtonItem = done
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel_button))
        navigationItem.leftBarButtonItem = cancel
    }
    
    func normalModeNavigationBar () {
        let option = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionTapped))
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchTapped))
        
        navigationItem.rightBarButtonItems = [option, search]
        navigationItem.leftBarButtonItems = []
    }
    
    @objc func cancel_button () {
        vehicleTableView.isEditing = !vehicleTableView.isEditing
        normalModeNavigationBar()
    }
    
    @objc func delete_vehicle() {
//        if let selectedRows = vehicleTableView.indexPathsForSelectedRows {
//
//            var items = [Bool]()
//
//            for _ in 0 ... (VehicleData.vehicleArray.vehicle?.count ?? 0) - 1 {
//                items.append(false)
//            }
//
//            for indexPath in selectedRows  {
//                items[indexPath.row] = true
//            }
//
//            for index in stride(from: (VehicleData.vehicleArray.vehicle?.count ?? 0) - 1 , to: 0, by: -1) {
//                if items[index] == true {
//                    VehicleData.vehicleArray.vehicle?.remove(at: index)
//                }
//            }
//
//            vehicleTableView.beginUpdates()
//            vehicleTableView.deleteRows(at: selectedRows, with: .automatic)
//            vehicleTableView.endUpdates()
//        }
        
        let alert = UIAlertController(title: "Delete Success", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        vehicleTableView.isEditing = !vehicleTableView.isEditing
        normalModeNavigationBar()
    }
    
}


//MARK: -TableView DataSources & Delegate Method

extension VehicleListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredVehiclelist?.count ?? 0
        }
        
        return vehicleList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let vehicle = !isFiltering ? vehicleList?[indexPath.row] : filteredVehiclelist?[indexPath.row]
        
        cell.textLabel?.text = vehicle?.license_plate
        cell.detailTextLabel?.text = vehicle?.vehicle_place
        
        
        return cell
    }
    
}

extension VehicleListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vehicleTableView.isEditing == false {
            performSegue(withIdentifier: "getUserInfo", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getUserInfo" {
            let destinationVC = segue.destination as! VehicleDetailViewController
            
            if let indexPath = vehicleTableView.indexPathForSelectedRow {
                //destinationVC.vehicleIndex = indexPath.row
                destinationVC.vehicleLicensePlate = !isFiltering ? vehicleList![indexPath.row].license_plate :  filteredVehiclelist![indexPath.row].license_plate
            }
        }
        if segue.identifier == "AddVehicle" {
            let destinationVC = segue.destination as! EditViewController
            destinationVC.SegueIdentifier = segue.identifier
            destinationVC.VehicleListVC = self
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //VehicleData.vehicleArray.vehicle?.remove(at: indexPath.row)
            vehicleTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


//MARK: -VehicleListManagerDelegate Method

extension VehicleListViewController: VehicleListManagerDelegate {
    
    func updateVehicleList(with vehicles: [VehicleListInfo]) {
        self.vehicleList = vehicles
        DispatchQueue.main.async {
            self.vehicleTableView.reloadData()
        }
    }
    
}

//MARK: -Search Bar Method

extension VehicleListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.4) {
            self.searchView.isHidden = true
            searchBar.endEditing(true)
        }
        vehicleTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterVehicleForSearchText(searchText)
    }
    
    func filterVehicleForSearchText(_ searchText: String) {
        filteredVehiclelist = vehicleList?.filter({ (vehicle) -> Bool in
            return vehicle.license_plate.lowercased().contains(searchText.lowercased()) || vehicle.vehicle_place.lowercased().contains(searchText.lowercased())
        })
        
        vehicleTableView.reloadData()
    }
    
    // Show and dismiss keyboard when tap to the search bar
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        searchBar.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        searchBar.endEditing(true)
    }
    
}


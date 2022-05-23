//
//  CityPickerTableViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 14/04/2022.
//

import UIKit

import UIKit

class CityPickerViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        //your code here....
    }
    

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomCityPickerTableViewCell.self, forCellReuseIdentifier: CustomCityPickerTableViewCell.identifier)
        return tableView
    }()
    
    private let searchBar: UISearchBar = UISearchBar()
    
    private let weatherService = WeatherService.shared
    
    private func setupNavigationBar() {
        navigationItem.title = "Select City"
        
        let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissCityPicker))
        
        navigationItem.rightBarButtonItem = closeBarButtonItem
        
    }
    
    @objc private func dismissCityPicker() {
        dismiss(animated: true, completion: nil)
    }

}

extension CityPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCityPickerTableViewCell.identifier, for: indexPath) as? CustomCityPickerTableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = "City"
        
        return cell
    }
    
}



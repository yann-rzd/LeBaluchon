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
//
        tableView.dataSource = self
        tableView.delegate = self
        
      
        
        
        let tableAndSearchStackView = UIStackView(arrangedSubviews: [
            searchBar,
            tableView
        ])
        
        
        tableAndSearchStackView.alignment = .fill
        tableAndSearchStackView.distribution = .fill
        tableAndSearchStackView.axis = .vertical
        
        

        view.addSubview(tableAndSearchStackView)
        
        
        
        tableAndSearchStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableAndSearchStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableAndSearchStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableAndSearchStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableAndSearchStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        
    
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
    
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
        navigationController?.navigationBar.backgroundColor = .white
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
        return CitySelection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCityPickerTableViewCell.identifier, for: indexPath) as? CustomCityPickerTableViewCell else {
            return UITableViewCell()
        }
        
        
        
        let city = CitySelection.allCases[indexPath.row]
        cell.textLabel?.text = city.title
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = CitySelection.allCases[indexPath.row]
        weatherService.add(city: city)
    }
}



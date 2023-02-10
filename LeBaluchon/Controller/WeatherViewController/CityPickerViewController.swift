//
//  CityPickerTableViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 14/04/2022.
//

import UIKit

import UIKit

class CityPickerViewController: UIViewController {

    // MARK: - INTERNAL: methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupToolBar()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        weatherService.filteredCities = weatherService.filteredCities
        setupBinding()
        
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
        
        weatherService.searchText = ""
    }
    

    // MARK: - PRIVATE: properties
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomCityPickerTableViewCell.self, forCellReuseIdentifier: CustomCityPickerTableViewCell.identifier)
        return tableView
    }()
    
    private let searchBar: UISearchBar = UISearchBar()
    
    private let weatherService = WeatherService.shared
    
    
    // MARK: - PRIVATE: methods
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.title = "Select City"
        
        let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissCityPicker))
        
        navigationItem.rightBarButtonItem = closeBarButtonItem
    }
    
    @objc private func dismissCityPicker() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupBinding() {
        weatherService.onSearchResultChanged = { [weak self] in
            self?.tableView.reloadData()
        }
        
        weatherService.onSearchTextChanged = { [weak self] searchText in
            self?.searchBar.text = searchText
        }
    }
    
    private func setupToolBar() {
        let toolBar = UIToolbar()
        
        let clearButton = UIBarButtonItem(
            title: "CLEAR",
            primaryAction: UIAction(handler: { [weak self] _ in self?.weatherService.emptySearchText() } )
        )
        
        clearButton.tintColor = .gray
        
        let doneButton = UIBarButtonItem(
            title: "DONE",
            primaryAction: UIAction(handler: { [weak self] _ in self?.view.endEditing(true) } )
        )
        
        toolBar.items = [
            clearButton,
            .flexibleSpace(),
            doneButton
        ]
        
        toolBar.sizeToFit()
        
        searchBar.inputAccessoryView = toolBar
        
    }
}


// MARK: - EXTENSIONS

extension CityPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherService.filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCityPickerTableViewCell.identifier, for: indexPath) as? CustomCityPickerTableViewCell else {
            return UITableViewCell()
        }
        
        let city = weatherService.filteredCities[indexPath.row]
        cell.textLabel?.text = city.title
        
        return cell
    }
}

extension CityPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = weatherService.filteredCities[indexPath.row]
        weatherService.add(city: city)
        dismiss(animated: true, completion: nil)
    }
}

extension CityPickerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        weatherService.searchText = searchText
    }
}

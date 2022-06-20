//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import UIKit

final class WeatherViewController: UIViewController {

    // MARK: - INTERNAL: methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(isLoading: weatherService.isLoading)
        
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.rowHeight = self.view.safeAreaLayoutGuide.layoutFrame.height / 3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        
        weatherService.fetchCitiesInformation()
        
    }

    
    // MARK: - PRIVATE: properties
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomWeatherTableViewCell.self, forCellReuseIdentifier: CustomWeatherTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var addCityBarButton: UIBarButtonItem = {
        let addCityBarButtonImage = UIImage(systemName: "plus")
        let addCityBarButton = UIBarButtonItem(image: addCityBarButtonImage, style: .plain, target: self, action: #selector(didTapAddCityButton))
        addCityBarButton.tintColor = .white
        return addCityBarButton
    }()
    
    private lazy var refreshBarButton: UIBarButtonItem = {
        let refreshDataImage = UIImage(systemName: "arrow.clockwise")
        let refreshDataBarButton = UIBarButtonItem(image: refreshDataImage, style: .plain, target: self, action: #selector(didTapRefreshButton))
        refreshDataBarButton.tintColor = .white
        return refreshDataBarButton
    }()
    
    private let weatherService = WeatherService.shared
    
    // MARK: - PRIVATE: methods
    
    
    private func setupBindings() {
        weatherService.weatherCitiesDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        weatherService.isLoadingDidChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.setupNavigationBar(isLoading: isLoading)
            }
        }
        
        weatherService.didProduceError = { [weak self] weatherServiceError in
            DispatchQueue.main.async {
                self?.displayAlert(error: weatherServiceError)
            }
        }
    }
    
    private func setupNavigationBar(isLoading: Bool) {
        navigationItem.rightBarButtonItems = [
            addCityBarButton,
            isLoading ? loadingBarButtonItem : refreshBarButton
        ]
    }
   
    
    @objc private func didTapAddCityButton() {
        let navigationController = UINavigationController(rootViewController: CityPickerViewController())
        present(navigationController, animated: true, completion: nil)
    }

    
    private var loadingBarButtonItem: UIBarButtonItem = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .white
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        let loadingBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        return loadingBarButtonItem
    }()
    
    
    
    @objc private func didTapRefreshButton() {
        weatherService.fetchCitiesInformation()
    }
    
    private func displayAlert(error: WeatherServiceError) {
        let alertController = UIAlertController(title: error.alertTitle, message: error.alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
}


// MARK: - EXTENSIONS

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherService.selectedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomWeatherTableViewCell.identifier, for: indexPath) as? CustomWeatherTableViewCell else {
            return UITableViewCell()
        }
        
        
        let selectedCity = weatherService.selectedCities[indexPath.row]
        print("SELECTED CITY => ✅✅ \(selectedCity)")
        
        cell.citySelection = selectedCity
        cell.cityWeatherModel = weatherService.weatherCities[selectedCity]
        
        
        cell.didTapDeleteButton = { [weak self] citySelectionToDelete in
            self?.weatherService.remove(city: citySelectionToDelete)
        }
        
        
        
        //let action = UIAction(title: "delete") { [weak self] _ in
        //    print("SIZE OF SELECTED CITIES => \( self?.weatherService.selectedCities.count ?? -1)")
        //    guard let selectedCities = self?.weatherService.selectedCities,
        //          selectedCities.indices.contains(indexPath.row)
        //    else { return }
        //
        //    let cityToDelete = selectedCities[indexPath.row]
        //    print("CITY TO DELETE => ❌❌ \(cityToDelete)")
        //    self?.weatherService.remove(city: cityToDelete)
        //}
        //
        //cell.deleteCityButton.addAction(action, for: .touchUpInside)
        
        
        
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    
}

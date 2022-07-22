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
        
        tableView.backgroundColor = UIColor.tableViewBackground
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didTapRefreshButton), for: .valueChanged)
        
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
    
    private var loadingBarButtonItem: UIBarButtonItem = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .white
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        let loadingBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        return loadingBarButtonItem
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private let weatherService = WeatherService.shared
    
    private let alertViewService = AlertViewService.shared
    
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
                if !isLoading {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
        
        weatherService.didProduceError = { [weak self] weatherServiceError in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.alertViewService.displayAlert(on: self, error: weatherServiceError)
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

    @objc private func didTapRefreshButton() {
        weatherService.fetchCitiesInformation()
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
        
        cell.citySelection = selectedCity
        cell.cityWeatherModel = weatherService.weatherCities[selectedCity]
        
        
        cell.didTapDeleteButton = { [weak self] citySelectionToDelete in
            self?.weatherService.remove(city: citySelectionToDelete)
        }
        
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            weatherService.removeCity(cityIndex: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        weatherService.selectedCities[indexPath.row] != .newYork
        
    }
}

extension UIColor {
    class var tableViewBackground: UIColor {
        if let color = UIColor(named: "lightBlue") {
            return color
        }
        fatalError("Could not find weatherCellsBackground color")
    }
}

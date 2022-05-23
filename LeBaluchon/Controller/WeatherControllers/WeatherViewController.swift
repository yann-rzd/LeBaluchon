//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import UIKit

class WeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.rowHeight = self.view.safeAreaLayoutGuide.layoutFrame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let addCityBarButtonImage = UIImage(systemName: "plus")
        let addCityBarButton = UIBarButtonItem(image: addCityBarButtonImage, style: .plain, target: self, action: #selector(didTapMenuButton))
        navigationItem.rightBarButtonItem = addCityBarButton
        addCityBarButton.tintColor = .white
        
    }

    @objc public func didTapMenuButton() {
        present(CityPickerViewController(), animated: true, completion: nil)
    }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomWeatherTableViewCell.self, forCellReuseIdentifier: CustomWeatherTableViewCell.identifier)
        return tableView
    }()
    
    
    private let weatherService = WeatherService.shared

}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherService.selectedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomWeatherTableViewCell.identifier, for: indexPath) as? CustomWeatherTableViewCell else {
            return UITableViewCell()
        }
        
        let selectedCity = weatherService.selectedCities[indexPath.row]
        
        cell.cityWeatherModel = weatherService.weatherCities[selectedCity]
        
        return cell
    }
    
}


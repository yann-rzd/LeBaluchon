//
//  CustomWeatherTableViewCell.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 17/05/2022.
//

import UIKit

class CustomWeatherTableViewCell: UITableViewCell {
    static let identifier = "CustomWeatherTableViewCell"
    
    let cityNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .boldSystemFont(ofSize: 40.0)
        view.text = "Paris"
        return view
    }()
    
    let displayCitiesButton: UIButton = {
        let view = UIButton(type: .system)
        view.configuration = .tinted()
//        view.backgroundColor = .white
        view.setTitle("Villes", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.text = "Villes"
        view.titleLabel?.font = .systemFont(ofSize: 24.0, weight: .regular)
        return view
    }()
    
    let weatherDescriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .systemFont(ofSize: 17.0, weight: .regular)
        view.text = "Belles éclaircies"
        return view
    }()
    
    let maxTemperatureLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .systemFont(ofSize: 17.0, weight: .regular)
        view.text = "Max. 19°"
        return view
    }()
    
    let minTemperatureLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .systemFont(ofSize: 17.0, weight: .regular)
        view.text = "Min. 8°"
        return view
    }()
    
    let currentTemperatureLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .systemFont(ofSize: 30.0, weight: .bold)
        view.text = "17°"
        return view
    }()
    
    let weatherImageView: UIImageView = {
        let view = UIImageView()
        view.frame = .init(x: 0, y: 0, width: 80.0, height: 80.0)
        return view
    }()
    
    let mainContainerStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.spacing = 50
        return view
    }()
    
    let choosenCityStackView: UIStackView  = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.spacing = 0
        return view
    }()
    
    let mainCityWeatherContainerStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.spacing = 50
        return view
    }()
    
    let weatherDescriptionStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 5
        return view
    }()
    
    let temperatureAndImageDescriptionStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 10
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() -> Void {
        contentView.backgroundColor = UIColor.weatherCellsBackground
        
        choosenCityStackView.addArrangedSubview(cityNameLabel)
        choosenCityStackView.addArrangedSubview(displayCitiesButton)
        
        weatherDescriptionStackView.addArrangedSubview(weatherDescriptionLabel)
        weatherDescriptionStackView.addArrangedSubview(maxTemperatureLabel)
        weatherDescriptionStackView.addArrangedSubview(minTemperatureLabel)
        
        temperatureAndImageDescriptionStackView.addArrangedSubview(currentTemperatureLabel)
        temperatureAndImageDescriptionStackView.addArrangedSubview(weatherImageView)
        
        mainCityWeatherContainerStackView.addArrangedSubview(weatherDescriptionStackView)
        mainCityWeatherContainerStackView.addArrangedSubview(temperatureAndImageDescriptionStackView)
        
        mainContainerStackView.addArrangedSubview(choosenCityStackView)
        mainContainerStackView.addArrangedSubview(mainCityWeatherContainerStackView)
        
        contentView.addSubview(mainContainerStackView)
        
        NSLayoutConstraint.activate([
            mainContainerStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainContainerStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainContainerStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: 0.0 )
        ])
    }
}

extension UIColor {
class var weatherCellsBackground: UIColor {
    if let color = UIColor(named: "lightBlue") {
        return color
    }
    fatalError("Could not find weatherCellsBackground color")
  }
}

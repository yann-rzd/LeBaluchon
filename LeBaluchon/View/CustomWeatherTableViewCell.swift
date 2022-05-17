//
//  CustomWeatherTableViewCell.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 17/05/2022.
//

import UIKit

class CustomWeatherTableViewCell: UITableViewCell {
    static let identifier = "CustomWeatherTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.weatherCellsBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

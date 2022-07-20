//
//  CustomCityPickerTableViewCell.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 23/05/2022.
//

import UIKit

final class CustomCityPickerTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    // MARK: - INTERNAL: properties
    
    static let identifier = "CustomCityPickerTableViewCell"

    
    // MARK: - PRIVATE: methods
    
    private func commonInit() -> Void {
    }
}

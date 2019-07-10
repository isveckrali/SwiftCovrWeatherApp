//
//  WeatherListCell.swift
//  WeatherAppCovrChallenge
//
//  Created by Mehmet Can Seyhan on 2019-07-09.
//  Copyright © 2019 Mehmet Can Seyhan. All rights reserved.
//

import UIKit

class WeatherListCell: UITableViewCell {
    
    @IBOutlet var lblCityName: UILabel!
    @IBOutlet var lblCountryCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   func configureCell(weatherListModel: WeatherListModel, indexPathRow:Int) {
        lblCityName.text = weatherListModel.name ?? ""
        lblCountryCode.text = weatherListModel.country ?? ""
        crateBorderLine(indexPathRow: indexPathRow)
    }
    
    func crateBorderLine(indexPathRow:Int) {
        self.layer.borderWidth = 4
        if indexPathRow % 2 == 0 {
            self.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            self.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
}

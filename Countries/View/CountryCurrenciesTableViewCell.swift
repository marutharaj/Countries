//
//  CountryCurrenciesTableViewCell.swift
//  Countries
//
//  Created by Marutharaj Kuppusamy on 11/28/18.
//  Copyright © 2018 shell. All rights reserved.
//

import UIKit

class CountryCurrenciesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencySymbolLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

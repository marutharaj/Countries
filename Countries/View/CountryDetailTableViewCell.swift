//
//  CountryDetailTableViewCell.swift
//  Countries
//
//  Created by Marutharaj Kuppusamy on 11/28/18.
//  Copyright © 2018 shell. All rights reserved.
//

import UIKit

class CountryDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryCapitalLabel: UILabel!
    @IBOutlet weak var countryRegionLabel: UILabel!
    @IBOutlet weak var countrySubRegionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

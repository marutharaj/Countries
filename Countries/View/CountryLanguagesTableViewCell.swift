//
//  CountryLanguagesTableViewCell.swift
//  Countries
//
//  Created by Marutharaj Kuppusamy on 11/28/18.
//  Copyright © 2018 shell. All rights reserved.
//

import UIKit

class CountryLanguagesTableViewCell: UITableViewCell {
    @IBOutlet weak var languagesISO6391Label: UILabel!
    @IBOutlet weak var languagesISO6392Label: UILabel!
    @IBOutlet weak var languagesNameLabel: UILabel!
    @IBOutlet weak var languagesNativeNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

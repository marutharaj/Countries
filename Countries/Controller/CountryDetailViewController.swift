//
//  CountryDetailViewController.swift
//  Countries
//
//  Created by Marutharaj Kuppusamy on 11/27/18.
//  Copyright © 2018 shell. All rights reserved.
//
import UIKit
import Reachability

class CountryDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var countryDetailTableView: UITableView!
    @IBOutlet var countryDetailNavigationBar: UINavigationBar!
    @IBOutlet var saveOfflineButton: UIButton!
    var country: Countries?
    var flagData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = self.country?.name
        self.countryDetailNavigationBar.topItem?.title = self.country?.name
        self.saveOfflineButton.layer.cornerRadius = 5.0
        if Reachability()?.connection == .none {
            self.saveOfflineButton.isHidden = true
        }
    }
    
    // MARK: - Private methods
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Countries", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (_: UIAlertAction) in
            print("You've pressed default")
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UIButton action
    
    @IBAction func saveOfflineButtonAction(sender: UIButton) {
        if let country = self.country {
            let cell = self.countryDetailTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CountryDetailTableViewCell
            let flagData = cell?.countryFlagImageView.image?.pngData()
            let recordStatus: RecordStatus = CoreDataManager().createCountryDetailWith(country: country, flagData: flagData ?? Data())
            switch recordStatus {
            case .saved:
                showAlert(message: "Country detail has been saved successfully.")
            case .failed:
                showAlert(message: "Country detail not saved.")
            case .exist:
                showAlert(message: "Country detail already exist.")
            }
        }
    }
    
    // MARK: - Navigation bar button action

    @IBAction func backButtonAction(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view private function and data source
    
    func cellForCountryDetailHeader(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryDetailCellIdentifier", for: indexPath) as? CountryDetailTableViewCell
        
        cell?.countryCapitalLabel.text = self.country?.capital
        cell?.countryRegionLabel.text = self.country?.region
        cell?.countrySubRegionLabel.text = self.country?.subregion
        
        cell?.countryFlagImageView.image = UIImage(data: self.flagData!)
        cell?.countryFlagImageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        return cell!
    }
    
    func cellForCountryCallingCodeHeader(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCallingCodeCellIdentifier", for: indexPath)
        cell.textLabel?.text = self.country?.callingCodes?[indexPath.row] ?? ""
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        return cell
    }
    
    func cellForCountryTimezoneHeader(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryTimezoneCellIdentifier", for: indexPath)
        cell.textLabel?.text = self.country?.timezones?[indexPath.row] ?? ""
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        return cell
    }
    
    func cellForCountryCurrenciesHeader(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCurrenciesCellIdentifier", for: indexPath) as? CountryCurrenciesTableViewCell
        let currency = self.country?.currencies?[indexPath.row]
        if let currencyName = currency?.name, let currencyCode = currency?.code, let currencySymbol = currency?.symbol {
            cell?.currencyNameLabel.text = "Name: " + currencyName
            cell?.currencyCodeLabel.text = "Code: " + currencyCode
            cell?.currencySymbolLabel.text = "Symbol: " + currencySymbol
        } else {
            cell?.currencyNameLabel.text = "Name: "
            cell?.currencyCodeLabel.text = "Code: "
            cell?.currencySymbolLabel.text = "Symbol: "
        }
        return cell!
    }
    
    func cellForCountryLanguagesHeader(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryLanguagesCellIdentifier", for: indexPath) as? CountryLanguagesTableViewCell
        let language = self.country?.languages?[indexPath.row]
        if let languageName = language?.name, let languageNativeName = language?.nativeName, let languageISO6391 = language?.iso6391, let languageISO6392 = language?.iso6392 {
            cell?.languagesNameLabel.text = "Name: " + languageName
            cell?.languagesNativeNameLabel.text = "Native Name: " + languageNativeName
            cell?.languagesISO6391Label.text = "ISO6391: " + languageISO6391
            cell?.languagesISO6392Label.text = "ISO6392: " + languageISO6392
        } else {
            cell?.languagesNameLabel.text = "Name: "
            cell?.languagesNativeNameLabel.text = "Native Name: "
            cell?.languagesISO6391Label.text = "ISO6391: "
            cell?.languagesISO6392Label.text = "ISO6392: "
        }
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.country?.callingCodes?.count ?? 0
        case 2:
            return self.country?.timezones?.count ?? 0
        case 3:
            return self.country?.currencies?.count ?? 0
        case 4:
            return self.country?.languages?.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        switch section {
        case 0:
            label.text = "Details"
        case 1:
            label.text = "Calling Codes"
        case 2:
            label.text = "Time Zones"
        case 3:
            label.text = "Currencies"
        case 4:
            label.text = "Languages"
        default:
            label.text = ""
        }
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100.0
        case 1:
            return 40.0
        case 2:
            return 40.0
        case 3:
            return 70.0
        case 4:
            return 80.0
        default:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return cellForCountryDetailHeader(tableView: tableView, indexPath: indexPath)
        case 1:
            return cellForCountryCallingCodeHeader(tableView: tableView, indexPath: indexPath)
        case 2:
            return cellForCountryTimezoneHeader(tableView: tableView, indexPath: indexPath)
        case 3:
                return cellForCountryCurrenciesHeader(tableView: tableView, indexPath: indexPath)
        case 4:
                return cellForCountryLanguagesHeader(tableView: tableView, indexPath: indexPath)
        default:
                print("Unexpected section")
                return UITableViewCell()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  CountryViewController.swift
//  Countries
//
//  Created by Marutharaj Kuppusamy on 11/26/18.
//  Copyright © 2018 shell. All rights reserved.
//

import UIKit
import Reachability

class CountryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet var countryTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var presenter: CountryPresenter?
    var countries =  [Countries]()
    let activityIndicator = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.presenter = CountryPresenter(delegate: self)
        if Reachability()?.connection == .none {
            self.presenter?.searchCountryOffline(searchCountryKeyword: "", filterON: false)
        }
    }

    // MARK: - Private methods

    func showActivityIndicator() {
        // Add it to the view where you want it to appear
        self.view.addSubview(activityIndicator)
        // Set up its size (the super view bounds usually)
        activityIndicator.frame = view.bounds
        // Start the loading animation
        activityIndicator.startAnimating()
    }
    
    func startSearch(searchText: String) {
        if Reachability()?.connection != .none {
            self.presenter?.searchCountry(searchCountryKeyword: searchText)
        } else {
            self.presenter?.searchCountryOffline(searchCountryKeyword: searchText, filterON: true)
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCellIdentifier", for: indexPath) as? CountryTableViewCell
        
        let country = self.countries[indexPath.row]
        
        cell?.countryNameLabel.text = country.name
        if Reachability()?.connection != .none {
            cell?.countryFlagImageView.downloadFlagFrom(flagUrl: country.flag!, contentMode: UIView.ContentMode.scaleAspectFit)
        } else {
            cell?.countryFlagImageView.image = UIImage(data: country.flagData!)
            cell?.countryFlagImageView.contentMode = UIView.ContentMode.scaleAspectFit
        }
        
        return cell!
    }
    
    // MARK: - Search Bar Delegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            print("Country search keyword can't be blank.")
            if !self.countries.isEmpty {
                self.countries = []
                countryTableView.reloadData()
            }
        } else {
            startSearch(searchText: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchBarText = searchBar.text {
            if let searchBarTextCount = searchBar.text?.count {
                if searchBarTextCount > 0 {
                    startSearch(searchText: searchBarText)
                } else {
                    if !self.countries.isEmpty {
                        self.countries = []
                        countryTableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "countryDetailSegueIdentifier" {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as? CountryDetailViewController
            // your new view controller should have property that will store passed value
            let indexPath: IndexPath = self.countryTableView.indexPathForSelectedRow!
            viewController?.country = self.countries[indexPath.row]
            let cell = self.countryTableView.cellForRow(at: indexPath) as? CountryTableViewCell
            viewController?.flagData = cell?.countryFlagImageView.image?.pngData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CountryViewController: CountryDelegate {
    func searchCountryDidSucceed(countries: [Countries]) {
        DispatchQueue.main.async {
            self.countries = countries
            self.countryTableView.reloadData()
        }
    }
    
    func searchCountryDidFailed(message: String) {
        print(message)
        self.countries = []
        countryTableView.reloadData()
    }
    
    func showProgress() {
        showActivityIndicator()
    }
    
    func hideProgress() {
        self.activityIndicator.removeFromSuperview()
    }
}


/*
 XCode version: 10.1
 Swift version: 4.2
 Design Pattern : Model View Presenter(MVP)
 UI Design: Storyboard and Autolayout
 Unit Testing framework: Quick and Nimble
 UI Testing framework: XCTest
 Dependency Manager: Cocoapod
 Persistence framework: CoreData
 Thirdparty Library:
    SwiftLint: To enforce swift style and conventions
    Alamofire: To communicate restcountries server
    ReachabilitySwift: To find network reachability
    OHHTTPStubs: To create mock web service call for unit testing
    SVGKit: To render svg file on UIImageView
 
 Architecture:
    Presentation Layer:
        CountryTableViewCell.swift
        CountryDetailTableViewCell.swift
        CountryCurrenciesTableViewCell.swift
        CountryLanguagesTableViewCell.swift
        CountryViewController.swift
        CountryDetailViewController.swift
    Business Layer:
        Countries.swift
        CountryPresenter.swift
    Data Access Layer:
        CoreDataManager.swift
        CountryService.swift
 */

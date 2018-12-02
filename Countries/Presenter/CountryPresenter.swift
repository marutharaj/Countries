//
//  CountryPresenter.swift
//  Countries
//
//  Created by Marutharaj Kuppusamy on 11/27/18.
//  Copyright © 2018 shell. All rights reserved.
//

import Foundation

protocol CountryDelegate {
    func showProgress()
    func hideProgress()
    func searchCountryDidSucceed(countries: [Countries])
    func searchCountryDidFailed(message: String)
}

class CountryPresenter {
    var delegate: CountryDelegate
    
    init(delegate: CountryDelegate) {
        self.delegate = delegate
    }
    
    func searchCountryFailed(message: String) {
        DispatchQueue.main.async {
            self.delegate.hideProgress()
            self.delegate.searchCountryDidFailed(message: message)
        }
    }
    
    func searchCountryOffline(searchCountryKeyword: String, filterON: Bool) {
        var countries: [Countries]
        countries = CoreDataManager().loadSavedCountries()
        if filterON {
            let filteredCountries = countries.filter { $0.name?.range(of: searchCountryKeyword, options: [.caseInsensitive]) != nil }
            self.delegate.searchCountryDidSucceed(countries: filteredCountries)
        } else {
            self.delegate.searchCountryDidSucceed(countries: countries)
        }
    }
    
    func searchCountry(searchCountryKeyword: String) {
        self.delegate.showProgress()
        CountryService().sendRequest(searchString: searchCountryKeyword, completionHandler: { response in
            // check for errors
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print(response.result.error!)
                self.searchCountryFailed(message: "Country search service returning error.")
                return
            }
                
            guard let data = response.data else {
                self.searchCountryFailed(message: "Country search service not returning data.")
                return
            }
                
            do {
                let decoder = JSONDecoder()
                let countries = try decoder.decode([Countries].self, from: data)
                DispatchQueue.main.async {
                    self.delegate.hideProgress()
                    self.delegate.searchCountryDidSucceed(countries: countries)
                }
            } catch let err {
                print("Err", err)
                self.searchCountryFailed(message: "Country search service data parsing error.")
            }
        })
    }
}

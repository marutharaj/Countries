//
//  CountryDetailViewControllerSpec.swift
//  CountriesTests
//
//  Created by Marutharaj Kuppusamy on 11/29/18.
//  Copyright © 2018 shell. All rights reserved.
//

import Quick
import Nimble
@testable import Countries

class CountryDetailViewControllerSpec: QuickSpec {
    override func spec() {
        var subject: CountryDetailViewController!
        
        describe("CountryDetailViewControllerSpec") {
            beforeEach {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                subject = storyBoard.instantiateViewController(withIdentifier: "CountryDetailViewController") as? CountryDetailViewController
                let countries = TestHelper().getFakeCountries(bundleTypeOf: self, jsonFileName: "MultipleCountry")
                subject?.country = countries[0]
                subject?.flagData = TestHelper().getFakeFlagData(bundleTypeOf: self)
                
                //Trigger the view to load and assert that it's not nil
                expect(subject.view).notTo(beNil())
                expect(subject.countryDetailTableView).notTo(beNil())
                expect(subject.countryDetailNavigationBar).notTo(beNil())
                expect(subject.saveOfflineButton).notTo(beNil())
                subject?.countryDetailTableView.reloadData()
            }
            
            context("when view is loaded") {
                it("should display country name in the navigation bar") {
                    expect(subject?.countryDetailNavigationBar.topItem?.title).to(equal("Australia"))
                }
                
                context("when network is online") {
                    it("should display save offline button") {
                        expect(subject.saveOfflineButton.isHidden).to(equal(false))
                    }
                }
                
                context("when network is offline") {
                    it("should not display save offline button") {
                        expect(subject.saveOfflineButton.isHidden).to(equal(true))
                    }
                }
                
                context("Country Detail Table View") {
                    it("should have 5 sections") {
                        expect(subject?.countryDetailTableView.numberOfSections).to(equal(5))
                    }
                    it("should display country detail") {
                        var cellCountyDetail: CountryDetailTableViewCell!
                        let indexPath = IndexPath(row: 0, section: 0)
                        cellCountyDetail = subject?.countryDetailTableView.cellForRow(at: indexPath) as? CountryDetailTableViewCell
                        expect(cellCountyDetail.countryCapitalLabel.text).to(equal("Canberra"))
                        expect(cellCountyDetail.countryRegionLabel.text).to(equal("Oceania"))
                        expect(cellCountyDetail.countrySubRegionLabel.text).to(equal("Australia and New Zealand"))
                    }
                    it("should display calling code") {
                        var cellCallingCode: UITableViewCell!
                        cellCallingCode = subject?.countryDetailTableView.cellForRow(at: IndexPath(row: 0, section: 1))
                        expect(cellCallingCode.textLabel?.text).to(equal("61"))
                    }
                    it("should display timezone") {
                        var cellTimeZone: UITableViewCell!
                        cellTimeZone = subject?.countryDetailTableView.cellForRow(at: IndexPath(row: 0, section: 2))
                        expect(cellTimeZone.textLabel?.text).to(equal("UTC+05:00"))
                    }
                    it("should display currencies") {
                        subject?.countryDetailTableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: UITableView.ScrollPosition.top, animated: true)
                        var cellCurrency: CountryCurrenciesTableViewCell!
                        let indexPath = IndexPath(row: 0, section: 3)
                        cellCurrency = subject?.countryDetailTableView.cellForRow(at: indexPath) as? CountryCurrenciesTableViewCell
                        expect(cellCurrency.currencyCodeLabel.text).to(equal("Code: AUD"))
                        expect(cellCurrency.currencyNameLabel.text).to(equal("Name: Australian dollar"))
                        expect(cellCurrency.currencySymbolLabel.text).to(equal("Symbol: $"))
                    }
                    it("should display languages") {
                        subject?.countryDetailTableView.scrollToRow(at: IndexPath(row: 0, section: 4), at: UITableView.ScrollPosition.top, animated: true)
                        var cellLanguage: CountryLanguagesTableViewCell!
                        cellLanguage = subject?.countryDetailTableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? CountryLanguagesTableViewCell
                        expect(cellLanguage.languagesNameLabel.text).to(equal("Name: English"))
                        expect(cellLanguage.languagesNativeNameLabel.text).to(equal("Native Name: English"))
                        expect(cellLanguage.languagesISO6391Label.text).to(equal("ISO6391: en"))
                        expect(cellLanguage.languagesISO6392Label.text).to(equal("ISO6392: eng"))
                    }
                }
            }
        }
    }
}

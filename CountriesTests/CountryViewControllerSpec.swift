//
//  CountryViewControllerSpec.swift
//  CountriesTests
//
//  Created by Marutharaj Kuppusamy on 11/29/18.
//  Copyright © 2018 shell. All rights reserved.
//

import Quick
import Nimble

@testable import Countries

class CountryViewControllerSpec: QuickSpec {
    override func spec() {
        var subject: CountryViewController!
        
        describe("CountryViewControllerSpec") {
            beforeEach {
                subject = UIStoryboard(name: "Main", bundle:
                    nil).instantiateViewController(withIdentifier:
                        "CountryViewController") as? CountryViewController
            
                TestHelper().fakeDownloadCountriesService()
                
                //Trigger the view to load and assert that it's not nil
                expect(subject.view).notTo(beNil())
                expect(subject.searchBar).notTo(beNil())
                expect(subject.countryTableView).notTo(beNil())
                expect(subject.presenter).notTo(beNil())
                
                waitUntil { done in
                    CountryService().sendRequest(searchString: "a", completionHandler: { response in
                        do {
                            let decoder = JSONDecoder()
                            subject.countries = try decoder.decode([Countries].self, from: response.data!)
                            done()
                        } catch {
                            fail("JSON Parsing error.")
                        }
                    })
                }
                subject.countryTableView.reloadData()
            }
            afterEach {
                TestHelper().removeAllStubs()
            }
            
            context("when view is loaded") {
                it("should have 13 countries loaded") {
                    expect(subject?.countryTableView.numberOfRows(inSection: 0)).to(equal(13))
                }
            }
            
            context("Country Table View") {
                var cell: CountryTableViewCell!
                
                beforeEach {
                    TestHelper().fakeDownloadFlagService()
                }
                
                it("should show country name and flag") {
                    cell = subject.countryTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CountryTableViewCell
                    expect(cell.countryNameLabel.text).to(equal("Australia"))
                    //expect(cell.countryFlagImageView.image?.pngData()).toNot(beNil())
                }
            }
        }
    }
}

//
//  CoreDataManagerSpec.swift
//  CountriesTests
//
//  Created by Marutharaj Kuppusamy on 11/30/18.
//  Copyright © 2018 shell. All rights reserved.
//

import Quick
import Nimble

@testable import Countries

class CoreDataManagerSpec: QuickSpec {
    
    override func spec() {
        var subject: CoreDataManager!
        var country: Countries?
        var flagData: Data?
        
        describe("CoreDataManagerSpec") {
            beforeEach {
                subject = CoreDataManager()
                country = TestHelper().getFakeCountries(bundleTypeOf: self, jsonFileName: "MultipleCountry").first!
                flagData = TestHelper().getFakeFlagData(bundleTypeOf: self)
            }
            context("when save offline button clicked") {
                context("if country detail not exist") {
                    beforeEach {
                        let countries = TestHelper().getFakeCountries(bundleTypeOf: self, jsonFileName: "MultipleCountry")
                        country = countries[8]
                    }
                    it("should save country information") {
                        let recordStatus = subject.createCountryDetailWith(country: country!, flagData: flagData!)
                        expect(recordStatus).to(equal(RecordStatus.saved))
                    }
                }
                context("if country detail  exist") {
                    beforeEach {
                        country = TestHelper().getFakeCountries(bundleTypeOf: self, jsonFileName: "MultipleCountry").first
                    }
                    it("should not save country information") {
                        let recordStatus = subject.createCountryDetailWith(country: country!, flagData: flagData!)
                        expect(recordStatus).to(equal(RecordStatus.exist))
                    }
                }
            }
            
            context("when launch app in offline") {
                it("should load countries from locally") {
                    let countries = subject.loadSavedCountries()
                    expect(countries.isEmpty).to(equal(false))
                }
            }
        }
    }
}

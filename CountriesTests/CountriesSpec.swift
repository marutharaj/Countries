//
//  CountriesSpec.swift
//  CountriesTests
//
//  Created by Marutharaj Kuppusamy on 11/29/18.
//  Copyright © 2018 shell. All rights reserved.
//

import Quick
import Nimble

@testable import Countries

public class CountriesSpec: QuickSpec {
    
    override public func spec() {
        var countries =  [Countries]()

        describe("CountriesSpec") {
            context("When get response from the country service") {
                beforeEach {
                    countries = TestHelper().getFakeCountries(bundleTypeOf: self, jsonFileName: "SingleCountry")
                }
                it("should have one country information") {
                    expect(countries.count).to(equal(1))
                }
                it("should parse country information") {
                    let country = countries[0]
                    expect(country.name).to(equal("Australia"))
                    expect(country.topLevelDomain?.count).to(equal(1))
                    expect(country.alpha2Code).to(equal("AU"))
                    expect(country.alpha3Code).to(equal("AUS"))
                    expect(country.callingCodes?.count).to(equal(1))
                    expect(country.capital).to(equal("Canberra"))
                    expect(country.altSpellings?.count).to(equal(1))
                    expect(country.region).to(equal("Oceania"))
                    expect(country.subregion).to(equal("Australia and New Zealand"))
                    expect(country.population).to(equal(24117360))
                    expect(country.latlng?.count).to(equal(2))
                    expect(country.latlng?[0]).to(equal(-27.0))
                    expect(country.latlng?[1]).to(equal(133.0))
                    expect(country.demonym).to(equal("Australian"))
                    expect(country.area).to(equal(7692024.0))
                    expect(country.gini).to(equal(30.5))
                    let timeZones = ["UTC+05:00", "UTC+06:30", "UTC+07:00", "UTC+08:00", "UTC+09:30", "UTC+10:00", "UTC+10:30", "UTC+11:30"]
                    expect(country.timezones?.count).to(equal(8))
                    expect(country.timezones).to(equal(timeZones))
                    expect(country.borders?.count).to(equal(0))
                    expect(country.nativeName).to(equal("Australia"))
                    expect(country.numericCode).to(equal("036"))
                    expect(country.currencies?.count).to(equal(1))
                    expect(country.currencies?[0].code).to(equal("AUD"))
                    expect(country.currencies?[0].name).to(equal("Australian dollar"))
                    expect(country.currencies?[0].symbol).to(equal("$"))
                    expect(country.languages?.count).to(equal(1))
                    expect(country.languages?[0].name).to(equal("English"))
                    expect(country.languages?[0].nativeName).to(equal("English"))
                    expect(country.languages?[0].iso6391).to(equal("en"))
                    expect(country.languages?[0].iso6392).to(equal("eng"))
                    expect(country.translations?.translationde).to(equal("Australien"))
                    expect(country.translations?.translationes).to(equal("Australia"))
                    expect(country.translations?.translationfr).to(equal("Australie"))
                    expect(country.translations?.translationja).to(equal("オーストラリア"))
                    expect(country.translations?.translationit).to(equal("Australia"))
                    expect(country.translations?.translationbr).to(equal("Austrália"))
                    expect(country.translations?.translationpt).to(equal("Austrália"))
                    expect(country.translations?.translationnl).to(equal("Australië"))
                    expect(country.translations?.translationhr).to(equal("Australija"))
                    expect(country.translations?.translationfa).to(equal("استرالیا"))
                    expect(country.flag).to(equal("https://restcountries.eu/data/aus.svg"))
                    expect(country.regionalBlocs?.count).to(equal(0))
                    expect(country.cioc).to(equal("AUS"))
                }
            }
        }
    }
}

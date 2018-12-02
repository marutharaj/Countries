//
//  TestHelper.swift
//  Countries
//
//  Created by Marutharaj Kuppusamy on 11/30/18.
//  Copyright © 2018 shell. All rights reserved.
//

import Foundation
import Quick
import Nimble
import OHHTTPStubs

@testable import Countries

class TestHelper {
    func getFakeCountries(bundleTypeOf: QuickSpec, jsonFileName: String) -> [Countries] {
        var countries: [Countries] = []
        
        if let path = Bundle(for: type(of: bundleTypeOf)).path(forResource: jsonFileName,
                                                               ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                    options: .alwaysMapped)
                let decoder = JSONDecoder()
                countries = try decoder.decode([Countries].self, from: data)
            } catch {
                print("JSON parsing error.")
            }
        }
        return countries
    }
    
    func getFakeFlagData(bundleTypeOf: QuickSpec) -> Data {
        let path = Bundle(for: type(of: bundleTypeOf)).path(forResource: "aus", ofType: "svg")
        var data: Data?
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: path!),
                            options: .alwaysMapped)
        } catch {
            fail("Data framing error.")
        }
        return data!
    }
    
    func fakeDownloadCountriesService() {
        stub(condition: isHost("restcountries.eu") && isPath("/rest/v2/name/a")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("MultipleCountry.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }
    }
    
    func fakeCountryServiceWithSuccess() {
        stub(condition: isHost("restcountries.eu") && isPath("/rest/v2/name/austra")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("SingleCountry.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }
    }
    
    func fakeCountryServiceWithError() {
        let error = NSError(domain: "Country service not found.", code: 404, userInfo: nil)
        stub(condition: isHost("restcountries.eu") && isPath("/rest/v2/name/e")) { _ in
            return OHHTTPStubsResponse(error: error)
        }
    }
    
    func fakeDownloadFlagService() {
        stub(condition: isHost("restcountries.eu") && isPath("/data/aus.svg")) { _ in
            let path = Bundle(for: type(of: self)).path(forResource: "aus", ofType: "svg")
            var data: Data?
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path!),
                                options: .alwaysMapped)
            } catch {
                fail("Data framing error.")
            }
            return OHHTTPStubsResponse(
                data: data!, statusCode: 200, headers: ["Content-Type": "application/json"]
            )
        }
    }
    
    func removeAllStubs() {
        OHHTTPStubs.removeAllStubs()
    }
}

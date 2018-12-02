//
//  CountryServiceSpec.swift
//  CountriesTests
//
//  Created by Marutharaj Kuppusamy on 11/29/18.
//  Copyright © 2018 shell. All rights reserved.
//

import Quick
import Nimble

@testable import Countries

class CountryServiceSpec: QuickSpec {
    
    override func spec() {
        describe("CountryServiceSpec") {
            afterEach {
                TestHelper().removeAllStubs()
            }
            
            context("when presenter call search service in online") {
                it("should return countries") {

                    TestHelper().fakeCountryServiceWithSuccess()
                    
                    CountryService().sendRequest(searchString: "austra", completionHandler: { response in
                        expect(response.data).toNot(beNil())
                    })
                }
            }
            
            context("when presenter call search service in offline") {
                it("should return error") {
                    var returnedError: Error?
                    
                    TestHelper().fakeCountryServiceWithError()
                    
                    CountryService().sendRequest(searchString: "e", completionHandler: { response in
                        returnedError = response.error
                        expect(returnedError).toNot(beNil())
                        expect(returnedError?.localizedDescription).to(equal("Country service not found."))
                    })
                }
            }
        }
    }
}

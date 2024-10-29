//
//  CurrencyConverter_TymeXTests.swift
//  CurrencyConverter_TymeXTests
//
//  Created by Huynh Nguyen Tuan Duy on 27/10/24.
//

import Testing
@testable import CurrencyConverter_TymeX

struct CurrencyConverter_TymeXTests {

    @Test("Test date formmater")
    func testUnixDateFormatter() {
        let sampleUnixTime = 1729728001
        let formattedDatefromUnixTime = sampleUnixTime.toFormattedDate()
        #expect(formattedDatefromUnixTime == "24/10/2024 07:00:01")
    }
    
    
    
}


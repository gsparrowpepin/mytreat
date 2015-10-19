//
//  MyTreatTests.swift
//  MyTreatTests
//
//  Created by GMSW on 10/14/15.
//  Copyright © 2015 GMSW. All rights reserved.
//

import XCTest
@testable import MyTreat

class MyTreatTests: XCTestCase {
    
    // MARK: MyTreat Tests
    
    func testMealInitialization(){
        //Success case
        let potentialItem = Meal(restaurantName: "Shin La", whoPaid: "Amelia", amount: 24.5, date: NSDate())
        
        let noName = Meal(restaurantName: "", whoPaid: "Amelia", amount: 24.5, date: NSDate())
        XCTAssertNil(noName, "Empty name is invalid")
    }
    
}

//
//  Meal.swift
//  MyTreat
//
//  Created by GMSW on 10/14/15.
//  Copyright © 2015 GMSW. All rights reserved.
//

import UIKit

class Meal {
    
    // MARK: Properties
    
    var restaurantName: String
    var whoPaid: String
    var amount: Float
    var date: NSDate
    
    init?(restaurantName: String, whoPaid: String, amount: Float, date: NSDate) {
        self.restaurantName = restaurantName
        self.whoPaid = whoPaid
        self.amount = amount
        self.date = date
        
        if restaurantName.isEmpty || whoPaid.isEmpty || amount < 0 {
            return nil
        }
    }
}

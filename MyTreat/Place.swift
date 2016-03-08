//
//  Place.swift
//  MyTreat
//
//  Created by GMSW on 11/24/15.
//  Copyright © 2015 GMSW. All rights reserved.
//

import UIKit

class Place {
    
    // MARK: Properties
    
    var placeName: String
    var placeAddress: String
    
    init?(placeName: String, placeAddress: String) {
        self.placeName = placeName
        self.placeAddress = placeAddress
        
        if placeName.isEmpty{
            return nil
        }
    }
}

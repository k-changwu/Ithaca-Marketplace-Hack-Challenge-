//
//  Listing.swift
//  Ithaca Marketplace
//
//  Created by Vivian Zhao on 11/26/22.
//

import UIKit
import Foundation

class Listing: NSObject {
    var listingName: String
    var listingDescription: String
    var listingPrice: Double
    
    required init(listingName: String, listingDescription: String, listingPrice: Double) {
        self.listingName = listingName
        self.listingDescription = listingDescription
        self.listingPrice = listingPrice
    }
    
    
}

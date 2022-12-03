//
//  Listing.swift
//  Ithaca Marketplace
//
//  Created by Vivian Zhao on 11/26/22.
//

import UIKit
import Foundation

struct Listing: Codable{
    var listingName: String
    var listingDescription: String
    var listingPrice: Double
}

struct ListingResponse: Codable {
    let success: Bool
    let data: [Listing]
}


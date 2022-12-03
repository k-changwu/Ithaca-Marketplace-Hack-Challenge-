//
//  User.swift
//  Ithaca Marketplace
//
//  Created by Vivian Zhao on 11/24/22.
//

import Foundation
import UIKit

//class User: NSObject{
//    var userName: String
//    var userRating: Double
//    var userFollowers: Int
//    var userFollowing: Int
//    var userImageName: String
//    var userListings: [Listing]
//
//    required init(userName: String, userRating: Double, userFollowers: Int, userFollowing: Int, userImageName: String, userListings: [Listing]) {
//        self.userName = userName
//        self.userRating = userRating
//        self.userFollowers = userFollowers
//        self.userFollowing = userFollowing
//        self.userImageName = userImageName
//        self.userListings = userListings
//    }
//
//}

struct User: Codable{
    var userName: String
    var userRating: Double
    var userFollowers: Int
    var userFollowing: Int
    var userImageName: String
    var userListings: [Listing]
}


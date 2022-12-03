//
//  NetworkManager.swift
//  Ithaca Marketplace
//
//  Created by Katherine Chang on 12/2/22.
//

import Alamofire
import Foundation

class NetworkManager {
    static let host = "34.139.125.237"
    
    static func getAllListings(completion: @escaping ([Listing]) -> Void){
        let endpoint = "\(host)/items/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode([Listing].self, from : data){
                    completion(userResponse)
                }else{
                    print("Failed to decode getAllListings")
                }
            case .failure(let error):
                print(error.localizedDescription)
                
                
            }
            
        }
    }
    
    static func createListing(listingName: String, listingDescription: String, listingPrice: Double, completion: @escaping (Listing) -> Void) {
        let endpoint = "\(host)/items/users/1"
        let params : Parameters = [
            "title": listingName,
            "description": listingDescription,
            "price": listingPrice
        ]
        
        AF.request(endpoint, method: .post, parameters: params).validate().responseData { response in
            switch response.result{
            case.success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode(Listing.self, from: data){
                    completion(userResponse)
                }else{
                    print("Failed to decode createListing")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    static func createUser(userName: String, description: String, completion: @escaping (User) -> Void){
        let endpoint = "\(host)/users/"
        let params : Parameters = [
            "name": userName,
            "description": description
        ]
        AF.request(endpoint, method: .post, parameters: params).validate().responseData{ response in
            switch response.result{
            case.success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode(User.self, from: data){
                    completion(userResponse)
                }else{
                    print("Failed to decode createUser")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

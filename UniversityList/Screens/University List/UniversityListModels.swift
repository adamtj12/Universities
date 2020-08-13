//  UniversityListModels.swift

import UIKit

enum UniversityList
{
    struct University: Codable, Equatable {
        var webPages: [String]
        var name: String
        var alphaCode: String?
        var stateProvince: String?
        var domains: [String]
        var country: String?
        
        enum CodingKeys: String, CodingKey {
               case webPages = "web_pages"
               case name
               case alphaCode = "alpha_two_code"
               case stateProvince = "state-province"
               case domains
               case country
        }
    }
     typealias UniversityList = [University]
}

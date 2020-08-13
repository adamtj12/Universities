//  UniversityListWorker.swift

import UIKit
import Alamofire
import SwiftyJSON

class UniversityListWorker {
    func getDataFromAPI(completion: @escaping ((_ values: UniversityList.UniversityList?, _ errorMessage: String?) -> Void)) {
        let domainURL = ReuseableStrings.apiString
        
        Alamofire.request(domainURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: [
            "Accept": "application/json"
        ]).responseJSON { (response) in
            if response.response?.statusCode == 200 {
                if let values: UniversityList.UniversityList =  try?
                    JSONDecoder().decode(UniversityList.UniversityList.self, from: response.data!) {
                    completion(values, nil)
                }
            }
            else {
                let error = response.result.error
                let errorMessage = error?.localizedDescription
                completion(nil, errorMessage)
            }
        }
    }
}

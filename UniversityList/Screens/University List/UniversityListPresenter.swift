//  UniversityListPresenter.swift

import UIKit
import SwiftyJSON

protocol UniversityListPresentationLogic
{
  var viewController: UniversityListDisplayLogic? {get set}
  func presentUniversityList(list: UniversityList.UniversityList?)
  func presentError(error: String)
}

class UniversityListPresenter: UniversityListPresentationLogic
{
    weak var viewController: UniversityListDisplayLogic?
  
    func presentUniversityList(list: UniversityList.UniversityList?) {
        viewController?.displayUniversityData(viewModel: list)
    }
    
    func presentError(error: String) {
        viewController?.displayError(error: error)
    }
}

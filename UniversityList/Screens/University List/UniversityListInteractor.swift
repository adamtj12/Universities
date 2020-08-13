//  UniversityListInteractor.swift

import UIKit

protocol UniversityListBusinessLogic {
  func configureUniversityList()
}

class UniversityListInteractor: UniversityListBusinessLogic {
  var presenter: UniversityListPresentationLogic?
  var worker: UniversityListWorker?

  func configureUniversityList() {
    worker = UniversityListWorker()
    worker?.getDataFromAPI(completion: { list, error  in
        if error != nil {
            self.presenter?.presentError(error: error!)
        } else {
            self.presenter?.presentUniversityList(list: list)
    }})
  }
}

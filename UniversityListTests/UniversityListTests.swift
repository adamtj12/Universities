//
//  UniversityListTests.swift
//  UniversityListTests
//
//  Created by Adam Johnston on 24/04/2020.
//  Copyright © 2020 Adam Johnston. All rights reserved.
//

@testable import UniversityList
import XCTest

class UniversityListTests: XCTestCase {

    var sut: UniversityListViewController!
    var window: UIWindow!

    override func setUp()
    {
        super.setUp()
        window = UIWindow()
        setupUniversityListViewController()
    }
    
    func setupUniversityListViewController()
    {
        let storyboard = Storyboards.UniversityList
        sut = storyboard
    }

    func loadView()
    {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    class UniversityListLogicSpy: UniversityListBusinessLogic
    {
        var interactor: UniversityListInteractor?
        var presenter: UniversityListPresenter?
        var worker: UniversityListWorker?

        init(){
          self.interactor = UniversityListInteractor()
          self.presenter = UniversityListPresenter()
          self.worker = UniversityListWorker()
        }
        
        var configureUniversityListCalled = false
        
        func configureUniversityList() {
            configureUniversityListCalled = true
        }
        
        var getAPIData = false
        func getDataFromAPI() {
            getAPIData = true
        }
    }
    
    // MARK: Tests
    
    func testShouldRequestUniversityListWhenViewIsLoaded()
    {
        let spy = UniversityListLogicSpy()
        sut.interactor = spy
        loadView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                XCTAssertTrue(spy.configureUniversityListCalled, "viewDidLoad() should ask the interactor to begin retrieving University list")
           }
    }


    func testShouldDisplayUniversityListWhenViewIsLoaded()
    {
        let viewModel = UniversityList.UniversityList.init(arrayLiteral: UniversityList.University.init(webPages: [""], name: "", aplhaCode: "", stateProvince: "", domains: [""], country: ""))
        loadView()
        sut.displayUniversityData(viewModel: viewModel)
        let Universities = sut.universityDecodedList
        XCTAssert(Universities == viewModel, "displayUniversityData should update the University records")
    }
}

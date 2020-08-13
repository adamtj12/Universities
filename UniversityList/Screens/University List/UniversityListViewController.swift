//  UniversityListViewController.swift

import UIKit
import RSLoadingView

protocol UniversityListDisplayLogic: class {
    func displayUniversityData(viewModel: UniversityList.UniversityList?)
    func displayError(error: String)
}

class UniversityListViewController: UIViewController, UniversityListDisplayLogic, UISearchBarDelegate {
    
    var interactor: UniversityListBusinessLogic?
    var router: (NSObjectProtocol & UniversityListRoutingLogic)?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var universityTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorMessage: UILabel!
    var filteredTableData = [UniversityList.University]()
    var universityDecodedList: UniversityList.UniversityList!
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        setupCleanSwiftArchitecture()
        super.viewDidLoad()
        interactor?.configureUniversityList()
        setUpView()
    }
    
    private func setupCleanSwiftArchitecture() {
        let viewController = self
        let interactor = UniversityListInteractor()
        let presenter = UniversityListPresenter()
        let router = UniversityListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        universityDecodedList = UniversityList.UniversityList.init()
    }
    
    func setUpView() {
        universityTableView.delegate = self
        universityTableView.dataSource = self
        universityTableView.isHidden = true
        universityTableView.rowHeight = UITableView.automaticDimension
        setUpSearch()
        self.beginLoadingUI()
    }
    
    func setUpSearch() {
        searchBar.delegate = self
    }
    
    func beginLoadingUI() {
        let loadingView = RSLoadingView()
        loadingView.show(on: view)
    }
    
    // MARK: UI Action lifecycle
    func displayUniversityData(viewModel: UniversityList.UniversityList?) {
        universityDecodedList = viewModel
        universityTableView.isHidden = false
        RSLoadingView.hide(from: view)
        universityTableView.reloadData()
    }
    
    func displayError(error: String) {
        RSLoadingView.hide(from: view)
        universityTableView.reloadData()
        universityTableView.isHidden = true
        errorView.isHidden = false
        errorMessage.text = error
    }
    
    @IBAction func tryAgainPressed(_ sender: Any) {
        interactor?.configureUniversityList()
        searchBar.text = ""
        searchBar.resignFirstResponder()
        cancelSearchData()
    }
}

// MARK: Table lifecycle
extension UniversityListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UniversityCellConfig.rowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return UniversityCellConfig.sectionCount    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (filteredTableData.count > 0) {
            return filteredTableData.count
        } else {
            return universityDecodedList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: UniversityListCellNames.UniversityCell) as? UniversityViewCell

        if (filteredTableData.count > 0) {
            let thisUniversity = filteredTableData[indexPath.row]
            cell = setCellContentsWithSelectedContent(university: thisUniversity, cell: cell!)
        } else {
            let thisUniversity = universityDecodedList[indexPath.row]
            cell = setCellContentsWithSelectedContent(university: thisUniversity, cell: cell!)
        }
        
        return cell ?? UniversityViewCell.init()
    }
    
    func setCellContentsWithSelectedContent(university: UniversityList.University, cell: UniversityViewCell) -> UniversityViewCell {
        cell.nameLabel.text = String(format: "Name: %@", university.name)
        cell.websitesView.text = setLinks(value: university.webPages)
        cell.domainsView.text = setLinks(value: university.domains)
        cell.alphaCodeLabel.text = String(format: "Alpha Code: %@", university.aplhaCode ?? "No data found")
        cell.countryLabel.text = String(format: "Country: %@", university.country ?? "No data found")
        cell.provinceLabel.text = String(format: "State Province: %@", university.stateProvince ?? "No data found")
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count > 0 {
            let filteredArray = self.universityDecodedList.filter({($0.name.localizedCaseInsensitiveContains(searchBar.text!))})
            filteredTableData = filteredArray
            if filteredTableData.count == 0 {
                self.displayError(error: ReuseableStrings.NoSearchResults)
            } else {
                cancelSearchData()
            }
        } else {
            cancelSearchData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            cancelSearchData()
        }
    }
    
    func cancelSearchData() {
        filteredTableData.removeAll()
        errorView.isHidden = true
        universityTableView.isHidden = false
        universityTableView.reloadData()
    }
    
    func setLinks(value: [String]) -> String {
        var string : String = ""
        if value.count > 0 {
            for url in value {
                string = string + url + "\n"
            }
        }
        return string
    }
}

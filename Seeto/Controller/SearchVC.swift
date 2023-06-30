//
//  SearchVC.swift
//  demo
//
//  Created by Paramveer Singh on 22/01/23.
//

import UIKit
import GooglePlaces
import GoogleMaps

var g_address: String!


protocol SearchAddressProtocol {
    func adressMap(address: String)
}
protocol SearchIndustryProtocol {
    func industryString(string: String,id : Int)
}
class SearchVC: UIViewController{
    @IBOutlet var topBtnConst: NSLayoutConstraint!
    
    @IBOutlet var btnBack: UIButton!
    let searchController = UISearchController(searchResultsController: nil)
    var searchAdressDelegate : SearchAddressProtocol!
    var searchIndustryDelegate : SearchIndustryProtocol!
    var placeIDArray = [String]()
    var resultsArray = [String]()
    var primaryAddressArray = [String]()
    var searchResults = [String]()
    var searhPlacesName = [String]()
    @IBOutlet var tableV: UITableView!
    var forIndustry = false
    var mainArray =  [String]()
    var industryIdArray = [Int?]()
    @IBOutlet var tfSearch: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = blueButtonColor;
//        let button = UIBarButtonItem(title: "YourTitle", style: .plain, target: self, action: #selector(self.goBack))
//        self.navigationItem.backBarButtonItem = button
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.searchController.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        tableViewSetup()
        setSearchController()
        // Do any additional setup after loading the view.
    }
    //function for autocomplete
    @objc func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableViewSetup(){
        self.tableV.delegate = self
        self.tableV.dataSource = self
        self.tableV.tableHeaderView = searchController.searchBar
        self.tableV.backgroundColor = backGroundColor
    }
    func setSearchController() {
        if forIndustry == true
        {
            searchResults = self.mainArray
        }
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor:blueButtonColor,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = forIndustry == false ? "Search Location" : "Search Industry"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.backgroundColor = backGroundColor
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.tintColor = .white
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: forIndustry == false ? "Search Location" : "Search Industry", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchController.searchBar.setSearchImage(color: UIColor.lightGray)


    }
    //search bar controller function methods
      
      func searchBarIsEmpty() -> Bool {
          // Returns true if the text is empty or nil
          return searchController.searchBar.text?.isEmpty ?? true
      }
      
      func filterContentForTextSearch(searchText: String){
          if forIndustry == false
          {
              placeAutocomplete(text_input: searchText)
          }
          else
          {
              if searchText == ""
              {
                  self.searchResults = mainArray
              }
              else
              {
                  self.searchResults = mainArray.filter { $0.contains(searchText) }
              }

          }
          self.tableV.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
      }
      
      func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//          btnBack.isHidden = true
          topBtnConst.constant = -10
          self.searchController.searchBar.showsCancelButton = true
          self.tableV.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
      }
      
      func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          btnBack.isHidden = false
          topBtnConst.constant = 40
          searchBar.showsCancelButton = false
          searchBar.text = ""
          searchBar.resignFirstResponder()
          self.tableV.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
      }
      func isFiltering() -> Bool{
          return searchController.isActive && !searchBarIsEmpty()
      }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if(searchBarIsEmpty()){
               searchBar.text = ""
               if forIndustry == true
               {
                   self.searchResults = mainArray
               }
           }else{
               if forIndustry == false
               {
                   placeAutocomplete(text_input: searchText)
               }
               else
               {
                   self.searchResults = mainArray.filter { $0.contains(searchText) }
               }
           }
       }
    //function for autocomplete
    func placeAutocomplete(text_input: String) {
        let filter = GMSAutocompleteFilter()
        let placesClient = GMSPlacesClient()
        filter.type = .establishment
        //geo bounds set for bengaluru region
        let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: 13.001356, longitude: 75.174399), coordinate: CLLocationCoordinate2D(latitude: 13.343668, longitude: 80.272055))
        
        placesClient.autocompleteQuery(text_input, bounds: bounds, filter: nil) { (results, error) -> Void in
            self.placeIDArray.removeAll() //array that stores the place ID
            self.resultsArray.removeAll() // array that stores the results obtained
            self.primaryAddressArray.removeAll() //array storing the primary address of the place.
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }

            if let results = results {
                for result in results {
                    
                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    //print("primary text: \(result.attributedPrimaryText.string)")
                    //print("Result \(result.attributedFullText) with placeID \(String(describing: result.placeID!))")
                    self.resultsArray.append(result.attributedFullText.string)
                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    self.placeIDArray.append(result.placeID)
                    
                }
            }

              
            self.searchResults = self.resultsArray
            self.searhPlacesName = self.primaryAddressArray
            self.tableV.reloadData()
        }
    }
    
    func getLongLat(placeId : String) -> (long : CLLocationDegrees,lat : CLLocationDegrees)
    {
        let placeClient = GMSPlacesClient()
        var long = 0.0,lat = 0.0
        placeClient.lookUpPlaceID(placeId) { (place, error) -> Void in
            if let error = error {
                //show error
                print(error)
                return
            }

            if let place = place {
                long = place.coordinate.longitude //longitude
                lat = place.coordinate.latitude
            } else {

            //show error
            }
        }
        return (long : long,lat : lat)
    }

}
extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForTextSearch(searchText: searchController.searchBar.text!)
    }
    
}

extension SearchVC :  UITableViewDelegate, UITableViewDataSource
{
    //Table view methods to be implemented
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .white
        cell.backgroundColor = backGroundColor
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if forIndustry == false
        {
//            print(getLongLat(placeId: placeIDArray[indexPath.row]))
            self.searchController.isActive = false
            searchAdressDelegate.adressMap(address: searchResults[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            searchIndustryDelegate.industryString(string: searchResults[indexPath.row], id: industryIdArray[indexPath.row] ?? 0)
            self.searchController.isActive = false
            self.navigationController?.popViewController(animated: true)
        }
        }
        
    
}

import Foundation
import UIKit
import SnapKit
import MapKit

class LocationViewController: UIViewController{
    let searchBar = SearchBarView()
    let locationTable = UITableView(frame: .zero)
    let headerIdentifier = "headerIdentifier"
    private var networkService = NetworkService()
    var cities: [CityNameModel] = []
    private var dataBaseSource: DataBaseSource!
    private var city: String!
    
    var homeVc: HomeViewController?
    
    private var alertView: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataBaseSource = DataBaseSource()
        
        cities = dataBaseSource.fetchCities()

        styleViews()
        makeConstraints()
    }
    
    func styleViews(){
        
        view.backgroundColor = UIColor(red: 0.384, green: 0.722, blue: 0.965, alpha: 1)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.384, green: 0.722, blue: 0.965, alpha: 1)
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "Location"
        
        view.addSubview(searchBar)
        searchBar.searchInputTextField.delegate = self
        
        locationTable.separatorStyle = .none
        locationTable.showsLargeContentViewer = false
        locationTable.showsHorizontalScrollIndicator = false
        locationTable.showsVerticalScrollIndicator = false
        locationTable.rowHeight = 80
        locationTable.backgroundColor = .clear
        
        view.addSubview(locationTable)
        
        locationTable.register(LocationSelectorCell.self, forCellReuseIdentifier: LocationSelectorCell.cellIdentifier)
        locationTable.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        locationTable.dataSource = self
        locationTable.delegate = self
        
    }
    
    
    func makeConstraints(){
        searchBar.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(50)
        }
        
        locationTable.snp.makeConstraints{
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.equalTo(searchBar.snp.leading)
            $0.trailing.equalTo(searchBar.snp.trailing)
            $0.bottom.equalToSuperview()
        }
    }
}

extension LocationViewController: UITextFieldDelegate{
    
    //provjeri kad pocelo upisivanje filma
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBar.isSelected()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.searchInputTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        city = searchBar.searchInputTextField.text
        
        let cityReduced = city.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        
        networkService.getLocation(cityName: cityReduced, completionHandler: { (result: Result<CityModel, RequestError>) in
            switch result {
                case .failure(let error):
                    print(error)
                    
                    if (cityReduced != "") {
                        DispatchQueue.main.async {
                            let message: String = "There is no such city!"
                            self.alertView = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
                            self.alertView.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                            self.present(self.alertView, animated: true, completion: nil)
                        }
                    }
                
                case .success(let value):
                    DispatchQueue.main.async {
                        self.dataBaseSource.saveCity(name: self.city, lat: value.coord.lat, lon: value.coord.lon)
                        self.cities = self.dataBaseSource.fetchCities()
                        self.locationTable.reloadData()
                        self.homeVc?.reloadWeatherViews()
                }
            }
        })
    }
}

extension LocationViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationSelectorCell.cellIdentifier, for: indexPath) as! LocationSelectorCell
        
        //uzima grad iz arraya gradova i puni odredenu celiju s podacima tog grada
        let city = cities[indexPath.section]
        
        cell.fillWithContent(city: city.name, lat: city.lon, lon: city.lat)
        
        return cell
    }
}

extension LocationViewController: UITableViewDelegate{
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
        guard let header = tableView.dequeueReusableCell(withIdentifier: headerIdentifier)
            else { return nil }
            
        return header
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityToRemove = self.cities[indexPath.section]
        dataBaseSource.deleteCity(name: cityToRemove.name)
        cities = dataBaseSource.fetchCities()
        tableView.reloadData()
        homeVc?.reloadWeatherViews()
    }
}



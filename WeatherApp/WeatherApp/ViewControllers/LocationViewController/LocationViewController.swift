import Foundation
import UIKit
import SnapKit

class LocationViewController: UIViewController{
    let searchBar = SearchBarView()
    let locationTable = UITableView(frame: .zero)
    let headerIdentifier = "headerIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBar.isSelected()
    }
    
}

extension LocationViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationSelectorCell.cellIdentifier, for: indexPath) as! LocationSelectorCell
        
        cell.fillWithContent()
        
        cell.selectionStyle = .none
        
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
            tableView.deselectRow(at: indexPath, animated: true)
    }
}

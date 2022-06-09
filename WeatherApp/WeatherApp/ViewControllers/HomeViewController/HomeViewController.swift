import UIKit
import SnapKit

class HomeViewController: UIViewController, MainViewDelegate, CityChangeDelegate {
        
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var stackView: UIStackView!
    
    //Nikola
    private var mainView: MainScrollView!
    
    //current day forcats
    private var dayForcatsView: UIView!
    private var dayAndDateLabel: UILabel!
    private var dayCollectionView: UICollectionView!

    //seven day forcats
    private var weekForcatsView: UIView!
    private var weekForcatsLabel: UILabel!
    private var forcatsTableView: UITableView!
    
    //network
    private var networkService = NetworkService()
    
    //models
    private var weatherModel: WeatherModel!
    private var allWeatherModels: [WeatherModel] = []
    
    //database
    private var dataBaseSource = DataBaseSource()
    private var cities: [CityNameModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cities = dataBaseSource.fetchCities()
        
        let group = DispatchGroup()
    
        for city in cities{
            group.enter()
            networkService.getWeatherData(cityLat: city.lat, cityLon: city.lon, completionHandler: { (result: Result<WeatherModel, RequestError>) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let value):
                    DispatchQueue.main.async {
                        self.allWeatherModels.append(value)
                        group.leave()
                    }
                }
            })
        }
    
        group.enter()
        networkService.getWeatherData(cityLat: 45.8131, cityLon: -15.9775, completionHandler: { (result: Result<WeatherModel, RequestError>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let value):
                DispatchQueue.main.async {
                    self.weatherModel = value
                    group.leave()
                }
            }
        })
        
        group.enter()
        networkService.getLocation(cityName: "zagreb", completionHandler: { (result: Result<CityModel, RequestError>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let value):
                DispatchQueue.main.async {
                    self.dataBaseSource.saveCity(name: "Zagreb", lat: value.coord.lat, lon: value.coord.lon)
                    group.leave()
                }
            }
        })
        
        group.notify(queue: .main){
            self.buildViews()
            self.buildConstraints()
        }
    }
    
    private func buildViews() {
        view.backgroundColor = .white
        
        buildScrollViewWithStack()
        buildMainView()
        buildDayForcatsView()
        buildWeekForcatsView()
    }
    
    private func buildConstraints() {
        scrollViewWithStackConstraints()
        mainViewConstraints()
        dayForcatsViewConstraints()
        weekForcatsViewConstraints()
    }
    
    private func buildScrollViewWithStack() {
        scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20

        contentView.addSubview(stackView)
    }
    
    //Nikola
    private func buildMainView() {
        mainView = MainScrollView(cities: cities, weathers: allWeatherModels, delegate: self)
        mainView.cityChangedDelegate = self
        
        stackView.addArrangedSubview(mainView)
    }
    
    private func buildDayForcatsView() {
        dayForcatsView = UIView()
        dayForcatsView.backgroundColor = StyleConstants.AppColors.lightBlue
        stackView.addArrangedSubview(dayForcatsView)
        
        dayAndDateLabel = UILabel()
        dayAndDateLabel.textColor = StyleConstants.AppColors.textColor
        dayAndDateLabel.font = UIFont(name: StyleConstants.FontNames.boldFont, size: StyleConstants.TextSizes.textNormal)
        
        dayAndDateLabel.text = "Forcats for 24 Hours"
        dayForcatsView.addSubview(dayAndDateLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        dayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dayCollectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: DayCollectionViewCell.reuseIdentifier)
        dayCollectionView.backgroundColor = .clear
        dayCollectionView.bounces = false
        dayCollectionView.showsHorizontalScrollIndicator = false
        dayForcatsView.addSubview(dayCollectionView)
        
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
    }
    
    private func buildWeekForcatsView() {
        weekForcatsView = UIView()
        weekForcatsView.backgroundColor = StyleConstants.AppColors.lightBlue
        stackView.addArrangedSubview(weekForcatsView)
        
        weekForcatsLabel = UILabel()
        weekForcatsLabel.textColor = StyleConstants.AppColors.textColor
        weekForcatsLabel.font = UIFont(name: StyleConstants.FontNames.boldFont, size: StyleConstants.TextSizes.textNormal)
        weekForcatsLabel.text = "Forcats for 7 Days"
        weekForcatsView.addSubview(weekForcatsLabel)
        
        forcatsTableView = UITableView()
        forcatsTableView.register(ForcatsTableViewCell.self, forCellReuseIdentifier: ForcatsTableViewCell.reuseIdentifier)
        forcatsTableView.rowHeight = 60
        forcatsTableView.isUserInteractionEnabled = false
        forcatsTableView.separatorColor = .clear
        weekForcatsView.addSubview(forcatsTableView)
        
        forcatsTableView.dataSource = self
    }
    
    //MARK: - Constraints
    
    private func scrollViewWithStackConstraints() {
        scrollView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        })
        
        contentView.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        })
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    //Nikola
    private func mainViewConstraints() {
        mainView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(450)
        })
    }
    
    private func dayForcatsViewConstraints() {
        dayForcatsView.snp.makeConstraints({
            $0.width.equalToSuperview()
            $0.height.equalTo(140)
        })
        
        dayAndDateLabel.snp.makeConstraints({
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        })
        
        dayCollectionView.snp.makeConstraints({
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(dayAndDateLabel.snp.bottom).offset(10)
        })
    }
    
    private func weekForcatsViewConstraints() {
        weekForcatsView.snp.makeConstraints({
            $0.width.equalToSuperview()
            $0.height.equalTo(420+14+10*3)
        })
        
        weekForcatsLabel.snp.makeConstraints({
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        })
        
        forcatsTableView.snp.makeConstraints({
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(weekForcatsLabel.snp.bottom).offset(10)
        })
    }
    
    func buttonTap(name: String) {
        if(name == "Settings"){
            let vc = SettingsViewContoller()
            self.present(vc, animated: true, completion: nil)
        }
        if(name == "Location"){
            let vc = LocationViewController()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func cityChanged(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        dayCollectionView.reloadData()
    }
}

//MARK: - ScrollView - Scroll to top - refresh weather data

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            
            networkService.getWeatherData(cityLat: 55.7522, cityLon: 37.6156, completionHandler: { (result: Result<WeatherModel, RequestError>) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let value):
                    DispatchQueue.main.async {
                        self.weatherModel = value

                        self.dayCollectionView.reloadData()
                        self.forcatsTableView.reloadData()
                    }
                }
            })
            
        }
    }
}

//MARK: - Day Forcast - Collection View

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: collectionView.frame.height)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.reuseIdentifier, for: indexPath) as? DayCollectionViewCell
        else {
            fatalError()
        }
        
        cell.set(inputIndexPath: indexPath.row, inputWeatherModel: weatherModel)
        return cell
    }
}

//MARK: - Week Forcast - Table View

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForcatsTableViewCell.reuseIdentifier) as? ForcatsTableViewCell
        else {
            fatalError()
        }
        
        cell.set(inputIndexPath: indexPath.row, inputWeatherModel: weatherModel)
        return cell
    }
}

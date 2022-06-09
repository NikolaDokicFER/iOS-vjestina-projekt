import UIKit
import SnapKit

class HomeViewController: UIViewController, MainViewDelegate, CityChangeDelegate {
        
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var stackView: UIStackView!
    
    //Nikola
    var mainView: MainScrollView!
    
    //current day forecast
    private var dayForecastView: UIView!
    private var dayAndDateLabel: UILabel!
    var dayCollectionView: UICollectionView!

    //seven day forecast
    private var weekForecastView: UIView!
    private var weekForecastLabel: UILabel!
    var forecastTableView: UITableView!
    
    //network
    private var networkService = NetworkService()
    
    //models
    private var weatherModel: WeatherModel!
    private var allWeatherModels = [String:WeatherModel]()
    
    //database
    private var dataBaseSource = DataBaseSource()
    private var cities: [CityNameModel] = []
    private var group = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData(first: true)
    }
    
    private func setData(first: Bool){
        cities = dataBaseSource.fetchCities()
        allWeatherModels.removeAll()
        
        
        group.enter()
        networkService.getWeatherData(cityLat: 45.8131, cityLon: -15.9775, completionHandler: { (result: Result<WeatherModel, RequestError>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let value):
                DispatchQueue.main.async {
                    self.weatherModel = value
                    self.allWeatherModels["Zagreb"] = value
                    
                    if(self.cities.count == 0){
                        self.cities.append(CityNameModel(name: "Zagreb", lon: 45.8131, lat: -15.9775))
                    }
                }
            }
            self.group.leave()
        })
        
        group.enter()
        networkService.getLocation(cityName: "zagreb", completionHandler: { (result: Result<CityModel, RequestError>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let value):
                DispatchQueue.main.async {
                    self.dataBaseSource.saveCity(name: "Zagreb", lat: value.coord.lat, lon: value.coord.lon)
                }
            }
            self.group.leave()
        })
        
        for city in cities{
            if(city.name != "Zagreb"){
                group.enter()
                networkService.getWeatherData(cityLat: city.lat, cityLon: city.lon, completionHandler: { (result: Result<WeatherModel, RequestError>) in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let value):
                        DispatchQueue.main.async {
                            self.allWeatherModels[city.name] = value
                        }
                    }
                    self.group.leave()
                })
            }
        }
    
        
        group.notify(queue: .main){
            if(first){
                self.buildViews()
                self.buildConstraints()
            }else{
                self.mainView.resetViews(cities: self.cities, weathers: self.allWeatherModels)
            }
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
        dayForecastView = UIView()
        dayForecastView.backgroundColor = StyleConstants.AppColors.lightBlue
        dayForecastView.layer.cornerRadius = 25
        stackView.addArrangedSubview(dayForecastView)
        
        dayAndDateLabel = UILabel()
        dayAndDateLabel.textColor = StyleConstants.AppColors.textColor
        dayAndDateLabel.font = UIFont(name: StyleConstants.FontNames.boldFont, size: StyleConstants.TextSizes.textNormal)
        
        dayAndDateLabel.text = "Forecast for 24 Hours"
        dayForecastView.addSubview(dayAndDateLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        dayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dayCollectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: DayCollectionViewCell.reuseIdentifier)
        dayCollectionView.backgroundColor = .clear
        dayCollectionView.bounces = false
        dayCollectionView.showsHorizontalScrollIndicator = false
        dayForecastView.addSubview(dayCollectionView)
        
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
    }
    
    private func buildWeekForcatsView() {
        weekForecastView = UIView()
        weekForecastView.backgroundColor = StyleConstants.AppColors.lightBlue
        weekForecastView.layer.cornerRadius = 25
        stackView.addArrangedSubview(weekForecastView)
        
        weekForecastLabel = UILabel()
        weekForecastLabel.textColor = StyleConstants.AppColors.textColor
        weekForecastLabel.font = UIFont(name: StyleConstants.FontNames.boldFont, size: StyleConstants.TextSizes.textNormal)
        weekForecastLabel.text = "Forecast for 7 Days"
        weekForecastView.addSubview(weekForecastLabel)
        
        forecastTableView = UITableView()
        forecastTableView.register(ForcatsTableViewCell.self, forCellReuseIdentifier: ForcatsTableViewCell.reuseIdentifier)
        forecastTableView.rowHeight = 60
        forecastTableView.isUserInteractionEnabled = false
        forecastTableView.separatorColor = .clear
        weekForecastView.addSubview(forecastTableView)
        
        forecastTableView.dataSource = self
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
        dayForecastView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(20)
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
        weekForecastView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(420+14+10*3)
        })
        
        weekForecastLabel.snp.makeConstraints({
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        })
        
        forecastTableView.snp.makeConstraints({
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(weekForecastLabel.snp.bottom).offset(10)
        })
    }
    
    func buttonTap(name: String) {
        if(name == "Settings"){
            let vc = SettingsViewContoller()
            vc.homeVc = self
            self.present(vc, animated: true, completion: nil)
        }
        if(name == "Location"){
            let vc = LocationViewController()
            vc.homeVc = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func cityChanged(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        dayCollectionView.reloadData()
        forecastTableView.reloadData()
    }
    
    func reloadWeatherViews() {
        dayCollectionView.reloadData()
        forecastTableView.reloadData()
        mainView.setUnits()
        setData(first: false)
    }
}

//MARK: - ScrollView - Scroll to top - refresh weather data

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            
            dayCollectionView.reloadData()
            forecastTableView.reloadData()
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

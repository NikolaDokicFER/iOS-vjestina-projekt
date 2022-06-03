import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var stackView: UIStackView!
    
    //Nikola
    private var mainView: MainView!
    
    //current day forcats
    private var dayForcatsView: UIView!
    private var dayAndDateLabel: UILabel!
    private var dayCollectionView: UICollectionView!

    //seven day forcats
    private var weekForcatsView: UIView!
    private var weekForcatsLabel: UILabel!
    private var forcatsTableView: UITableView!
    
    //forcats buttons
    private var openWeekForcatsButton: UIButton!
    private var closeWeekForcatsButton: UIButton!
    
    //network
    private var networkService = NetworkService()
    
    //models
    private var weatherModel: WeatherModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        buildViews()
//        buildConstraints()
        
        networkService.getWeatherData(cityLat: 45.8131, cityLon: -15.9775, completionHandler: { (result: Result<WeatherModel, RequestError>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let value):
                DispatchQueue.main.async {
                    self.weatherModel = value

                    //print(self.weatherModel)

                    self.buildViews()
                    self.buildConstraints()
                    
                    //self.collectionView.dataSource = self
                }
            }
        })
        
//
//        //Adrian
//        //to nam sluzi da spremimo lokacije grada, npr za Zagreb
//        //das ovoj funkciji ime grada (malim slovima) i ona fetcha s api-a njegove lokacije i onda bi to trebalo sve pospremiti u bazu
//        networkService.getLocation(cityName: "zagreb", completionHandler: { (result: Result<CityModel, RequestError>) in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let value):
//                DispatchQueue.main.async {
//
//                    //tuj ide kod za spremanje u bazu
//
//                    // ove vrijednosti spremas u bazu
//                    // OBAVEZNO spremiti i ime grada malim slovima, npr. "zagreb" jer prek toga pristupamo kasnije
//                    //print(value.coord.lat)
//                    //print(value.coord.lon)
//
//                }
//            }
//        })
//
        
        
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
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
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
        mainView = MainView()
        mainView.backgroundColor = StyleConstants.AppColors.lightBlue
        mainView.layer.cornerRadius = 30
        stackView.addArrangedSubview(mainView)
    }
    
    private func buildDayForcatsView() {
        dayForcatsView = UIView()
        dayForcatsView.backgroundColor = StyleConstants.AppColors.lightBlue
        stackView.addArrangedSubview(dayForcatsView)
        
        dayAndDateLabel = UILabel()
        dayAndDateLabel.textColor = StyleConstants.AppColors.textColor
        dayAndDateLabel.font = UIFont(name: StyleConstants.FontNames.boldFont, size: StyleConstants.TextSizes.textNormal)
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE | MMM dd"
        let dayOfTheWeekString = dateFormatter.string(from: date)
        dayAndDateLabel.text = dayOfTheWeekString
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
    
    private func buildOpenForcatsButton() {
        openWeekForcatsButton = UIButton()
        openWeekForcatsButton.setTitle("Forcats for 7 Days ▽↓", for: .normal)
        openWeekForcatsButton.tintColor = StyleConstants.AppColors.textColor
        
        stackView.addArrangedSubview(openWeekForcatsButton)
    }
    
    private func buildCloseForcatsButton() {
        closeWeekForcatsButton = UIButton()
        closeWeekForcatsButton.setTitle("Forcats for 7 Days ↑", for: .normal)
        closeWeekForcatsButton.tintColor = StyleConstants.AppColors.textColor
        
        stackView.addArrangedSubview(closeWeekForcatsButton)
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
    
    private func openForcatsButtonConstraints() {
        
    }
    
    private func closeForcatsButtonConstraints() {
        
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

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        buildConstraints()
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
        mainView.backgroundColor = .systemBlue
        mainView.layer.cornerRadius = 30
        stackView.addArrangedSubview(mainView)
        
    }
    
    private func buildDayForcatsView() {
        dayForcatsView = UIView()
        dayForcatsView.backgroundColor = .systemBlue
        stackView.addArrangedSubview(dayForcatsView)
        
        dayAndDateLabel = UILabel()
        dayAndDateLabel.textColor = .white
        dayAndDateLabel.font = UIFont(name: "Helvetica Neue Bold", size: 14)
        dayAndDateLabel.text = "Sunday | Nov 14" //.......
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
        weekForcatsView.backgroundColor = .systemBlue
        stackView.addArrangedSubview(weekForcatsView)
        
        weekForcatsLabel = UILabel()
        weekForcatsLabel.textColor = .white
        weekForcatsLabel.font = UIFont(name: "Helvetica Neue", size: 14)
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
        openWeekForcatsButton.tintColor = .white
        
        stackView.addArrangedSubview(openWeekForcatsButton)
    }
    
    private func buildCloseForcatsButton() {
        closeWeekForcatsButton = UIButton()
        closeWeekForcatsButton.setTitle("Forcats for 7 Days ↑", for: .normal)
        closeWeekForcatsButton.tintColor = .white
        
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
            $0.top.leading.trailing.equalToSuperview().inset(20)
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
    //cell dimensions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: collectionView.frame.height)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.reuseIdentifier, for: indexPath) as? DayCollectionViewCell
        else {
            fatalError()
        }
        
        cell.set(inputThing: indexPath.row)
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
        
        cell.set(inputThing: indexPath.row)
        return cell
    }
}

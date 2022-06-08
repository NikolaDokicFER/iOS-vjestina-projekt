import Foundation
import UIKit

class SettingsViewContoller: UIViewController{
    let unitLabel = UILabel()
    let temperatureLabel = UILabel()
    let temperatureButton = UIButton()
    let windLabel = UILabel()
    let windButton = UIButton()
    let atmosphereLabel = UILabel()
    let atmosphereButton = UIButton()
    let lineBreak = UIView()
    let extraLabel = UILabel()
    let aboutLabel = UILabel()
    let temperatureArray: [temperatureUnit] = [.C, .F]
    let windArray: [windUnit] = [.kmh, .mph, .mps, .knots]
    let pressureArray: [pressureUnit] = [.atm, .hpa, .inhg, .mbar, .mmhg]
    var loadingTemp: temperatureUnit?
    var loadingWind: windUnit?
    var loadingPressure: pressureUnit?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //trying out loading
        loadingTemp = .C
        loadingWind = .kmh
        loadingPressure = .atm
        
        fetchUnits()
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
        navigationItem.title = "Settings"
        
        unitLabel.text = "UNIT"
        unitLabel.font = UIFont.systemFont(ofSize: 14)
        unitLabel.textColor = .white
        view.addSubview(unitLabel)
        
        temperatureLabel.text = "Temperature unit"
        temperatureLabel.font = UIFont.systemFont(ofSize: 20)
        temperatureLabel.textColor = .white
        view.addSubview(temperatureLabel)
        
        temperatureButton.setTitle(loadingTemp?.rawValue, for: .normal)
        temperatureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        temperatureButton.backgroundColor = .clear
        temperatureButton.titleLabel?.textColor = .black
        temperatureButton.addTarget(self, action: #selector(toggleTemperature(sender:)), for: .touchUpInside)
        view.addSubview(temperatureButton)
        
        windLabel.text = "Wind unit"
        windLabel.font = UIFont.systemFont(ofSize: 20)
        windLabel.textColor = .white
        view.addSubview(windLabel)
        
        windButton.setTitle(loadingWind?.rawValue, for: .normal)
        windButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        windButton.backgroundColor = .clear
        windButton.titleLabel?.textColor = .black
        windButton.addTarget(self, action: #selector(toggleWind(sender:)), for: .touchUpInside)
        view.addSubview(windButton)
        
        atmosphereLabel.text = "Atmospheric pressure unit"
        atmosphereLabel.font = UIFont.systemFont(ofSize: 20)
        atmosphereLabel.textColor = .white
        view.addSubview(atmosphereLabel)
        
        atmosphereButton.setTitle(loadingPressure?.rawValue, for: .normal)
        atmosphereButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        atmosphereButton.backgroundColor = .clear
        atmosphereButton.titleLabel?.textColor = .yellow
        atmosphereButton.addTarget(self, action: #selector(togglePressure(sender:)), for: .touchUpInside)
        view.addSubview(atmosphereButton)
        
        lineBreak.backgroundColor = .white
        view.addSubview(lineBreak)
        
        extraLabel.text = "EXTRA"
        extraLabel.font = UIFont.systemFont(ofSize: 14)
        extraLabel.textColor = .white
        view.addSubview(extraLabel)
        
        aboutLabel.text = "About"
        aboutLabel.font = UIFont.systemFont(ofSize: 20)
        aboutLabel.textColor = .white
        view.addSubview(aboutLabel)
        
    }
    
    func makeConstraints(){
        unitLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
            $0.leading.equalToSuperview().offset(15)
        }
        
        temperatureLabel.snp.makeConstraints{
            $0.top.equalTo(unitLabel.snp.bottom).offset(20)
            $0.leading.equalTo(unitLabel.snp.leading)
        }
        
        temperatureButton.snp.makeConstraints{
            $0.bottom.equalTo(temperatureLabel.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        windLabel.snp.makeConstraints{
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(20)
            $0.leading.equalTo(temperatureLabel)
        }
        
        windButton.snp.makeConstraints{
            $0.bottom.equalTo(windLabel.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        atmosphereLabel.snp.makeConstraints{
            $0.top.equalTo(windLabel.snp.bottom).offset(20)
            $0.leading.equalTo(windLabel)
        }
        
        atmosphereButton.snp.makeConstraints{
            $0.bottom.equalTo(atmosphereLabel.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        lineBreak.snp.makeConstraints{
            $0.top.equalTo(atmosphereLabel.snp.bottom).offset(30)
            $0.height.equalTo(2)
            $0.leading.equalTo(unitLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        extraLabel.snp.makeConstraints{
            $0.top.equalTo(lineBreak.snp.bottom).offset(20)
            $0.leading.equalTo(lineBreak)
        }
        
        aboutLabel.snp.makeConstraints{
            $0.top.equalTo(extraLabel.snp.bottom).offset(20)
            $0.leading.equalTo(extraLabel)
        }
    }
    
    @objc
    func toggleTemperature(sender: UIButton) {
        let currentUnit = loadingTemp
        guard let unit = currentUnit,
            var index = temperatureArray.firstIndex(of: unit)
        else {
            return
        }
        
        if (index == temperatureArray.count - 1) {
            index = -1
        }
        
        let nextUnit = temperatureArray[index + 1]
        loadingTemp = nextUnit
        sender.setTitle(loadingTemp?.rawValue, for: .normal)
        
        saveUnits()
        
    }
    
    @objc
    func togglePressure(sender: UIButton) {
        let currentUnit = loadingPressure
        guard let unit = currentUnit,
            var index = pressureArray.firstIndex(of: unit)
        else {
            return
        }
        
        if (index == pressureArray.count - 1) {
            index = -1
        }
        
        let nextUnit = pressureArray[index + 1]
        loadingPressure = nextUnit
        sender.setTitle(loadingPressure?.rawValue, for: .normal)
        
        saveUnits()
    }
    
    @objc
    func toggleWind(sender: UIButton) {
        let currentUnit = loadingWind
        guard let unit = currentUnit,
            var index = windArray.firstIndex(of: unit)
        else {
            return
        }
        
        if (index == windArray.count - 1) {
            index = -1
        }
        
        let nextUnit = windArray[index + 1]
        loadingWind = nextUnit
        sender.setTitle(loadingWind?.rawValue, for: .normal)
        
        saveUnits()
    }
    
    func saveUnits() {
        guard let loadingTemp = loadingTemp,
            let loadingWind = loadingWind,
            let loadingPressure = loadingPressure
        else {
            return
        }

        let settingsModel = SettingsModel(temperatureUnit: loadingTemp, windUnit: loadingWind, pressureUnit: loadingPressure)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(settingsModel)
            UserDefaults.standard.set(data, forKey: "key")
        } catch {
            print("Error when encoding SettingsModel")
        }
    }
    
    func fetchUnits() {
        guard let data = UserDefaults.standard.data(forKey: "key") else {
            return
        }
        do {
            let decoder = JSONDecoder()
            let settingsModel = try decoder.decode(SettingsModel.self, from: data)
            self.loadingTemp = settingsModel.temperatureUnit
            self.loadingWind = settingsModel.windUnit
            self.loadingPressure = settingsModel.pressureUnit
        } catch {
            print("Error when decoding SettingsModel")
        }
    }
}

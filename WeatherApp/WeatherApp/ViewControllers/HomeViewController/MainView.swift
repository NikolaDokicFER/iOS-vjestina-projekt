//
//  MainView.swift
//  WeatherApp
//
//  Created by Nikola Đokić on 02.06.2022..
//

import Foundation
import UIKit
import SnapKit

class MainView: UIView{
    
    var delegate: MainViewDelegate?
    private var addLocationButton: UIButton!
    private var settingsButton: UIButton!
    private var locationNameLabel: UILabel!
    private var currentWeatherImageView: UIImageView!
    private var currentDateLabel: UILabel!
    private var currentDegreesLabel: UILabel!
    private var weatherDescriptionLabel: UILabel!
    private var separatorLine: UIView!
    private var bottomView: BottomView!
    private var weatherModel: WeatherModel!
    private var tempUnit: temperatureUnit?
    private var conversionFunctions = ConversionFunctions()
    private var weatherIcons = WeatherIcons()
    private var cityName: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = StyleConstants.AppColors.lightBlue
        layer.cornerRadius = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews(){
        
        addLocationButton = UIButton()
        self.addSubview(addLocationButton)
        
        settingsButton = UIButton()
        self.addSubview(settingsButton)
        
        locationNameLabel = UILabel()
        self.addSubview(locationNameLabel)
        
        let image = weatherIcons.weatherIcon(conditionId: weatherModel.current.weather[0].id)
        let uiImage = UIImage(systemName: image)
        uiImage?.withRenderingMode(.automatic)
        let config = UIImage.SymbolConfiguration.preferringMulticolor()
        currentWeatherImageView = UIImageView(image: uiImage!.applyingSymbolConfiguration(config))
        
        self.addSubview(currentWeatherImageView)
        
        currentDateLabel = UILabel()
        self.addSubview(currentDateLabel)
        
        currentDegreesLabel = UILabel()
        self.addSubview(currentDegreesLabel)
        
        weatherDescriptionLabel = UILabel()
        self.addSubview(weatherDescriptionLabel)
        
        separatorLine = UIView()
        self.addSubview(separatorLine)
        
        bottomView = BottomView(weather: weatherModel)
        self.addSubview(bottomView)
    }
    
    private func styleViews(){
        
        addLocationButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        addLocationButton.addTarget(self, action: #selector(addLocationButtonTap), for: .touchUpInside)
        addLocationButton.tintColor = UIColor.white
        
        settingsButton.transform = settingsButton.transform.rotated(by: .pi / 2)
        settingsButton.setImage(UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTap), for: .touchUpInside)
        settingsButton.tintColor = UIColor.white
        
        currentWeatherImageView.tintColor = .white
        
        locationNameLabel.text = cityName
        locationNameLabel.font = UIFont(name: StyleConstants.FontNames.boldFont, size: StyleConstants.TextSizes.textMedium)
        locationNameLabel.textColor = .white
        
        let date = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE | MMM dd"
        let dayOfTheWeekString = dateFormatter.string(from: date!)
        
        currentDateLabel.text = dayOfTheWeekString
        currentDateLabel.font = UIFont(name: StyleConstants.FontNames.normalFont, size: StyleConstants.TextSizes.textNormal)
        currentDateLabel.textColor = .white
        
        currentDegreesLabel.font = UIFont(name: StyleConstants.FontNames.boldFont, size: StyleConstants.TextSizes.textLarge)
        currentDegreesLabel.textColor = .white
        
        if (tempUnit == temperatureUnit.C) {
            let temp = conversionFunctions.toCelsius(kelvin: weatherModel.current.temp)
            currentDegreesLabel.text = "\(temp)°C"
        }
        else {
            let temp = conversionFunctions.toFahrenheit(kelvin: weatherModel.current.temp)
            currentDegreesLabel.text = "\(temp)°F"
        }
        
        weatherDescriptionLabel.text = "\(weatherModel.current.weather[0].main)"
        weatherDescriptionLabel.font = UIFont(name: StyleConstants.FontNames.normalFont, size: StyleConstants.TextSizes.textNormal)
        weatherDescriptionLabel.textColor = .white
        
        separatorLine.backgroundColor = .white
        
    }
    
    private func constraintViews(){
        
        addLocationButton.snp.makeConstraints({
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(25)
        })
        
        settingsButton.snp.makeConstraints({
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(25)
        })
        
        locationNameLabel.snp.makeConstraints({
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        })
        
        currentWeatherImageView.snp.makeConstraints({
            $0.top.equalTo(locationNameLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(130)
        })
        
        currentDateLabel.snp.makeConstraints({
            $0.top.equalTo(currentWeatherImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        })
        
        currentDegreesLabel.snp.makeConstraints({
            $0.top.equalTo(currentDateLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        })
        
        weatherDescriptionLabel.snp.makeConstraints({
            $0.top.equalTo(currentDegreesLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        })
        
        separatorLine.snp.makeConstraints({
            $0.top.equalTo(weatherDescriptionLabel.snp.bottom).offset(5)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(10)
        })
        
        bottomView.snp.makeConstraints(){
            $0.top.equalTo(separatorLine.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setWeather(weather: WeatherModel){
        self.weatherModel = weather
        fetchUnits()
        buildViews()
        styleViews()
        constraintViews()
    }
    
    func setCity(name: String){
        cityName = name
    }
    
    func setUnits(){
        fetchUnits()
        if (tempUnit == temperatureUnit.C) {
            let temp = conversionFunctions.toCelsius(kelvin: weatherModel.current.temp)
            currentDegreesLabel.text = "\(temp)°C"
        }
        else {
            let temp = conversionFunctions.toFahrenheit(kelvin: weatherModel.current.temp)
            currentDegreesLabel.text = "\(temp)°F"
        }
        
        bottomView.setUnits()
    }
    
    @objc private func settingsButtonTap() {
        delegate?.buttonTap(name: "Settings")
    }
    
    @objc private func addLocationButtonTap() {
        delegate?.buttonTap(name: "Location")
    }
    
    func fetchUnits() {
        guard let data = UserDefaults.standard.data(forKey: "key") else {
            return
        }
        do {
            let decoder = JSONDecoder()
            let settingsModel = try decoder.decode(SettingsModel.self, from: data)
            self.tempUnit = settingsModel.temperatureUnit
        } catch {
            print("Error when decoding SettingsModel")
        }
    }
}

protocol MainViewDelegate{
    func buttonTap(name: String)
}

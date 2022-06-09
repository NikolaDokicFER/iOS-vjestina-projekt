//
//  BottomView.swift
//  WeatherApp
//
//  Created by Nikola Đokić on 02.06.2022..
//

import Foundation
import UIKit
import SnapKit

class BottomView: UIView{
    private var stackView1: UIStackView!
    private var stackView2: UIStackView!
    private var viewCell1: BottomViewCell!
    private var viewCell2: BottomViewCell!
    private var viewCell3: BottomViewCell!
    private var viewCell4: BottomViewCell!
    private var weatherModel: WeatherModel!
    private var weatherIcons = WeatherIcons()
    private var windsUnit: windUnit?
    private var pressuresUnit: pressureUnit?
    
    init(weather: WeatherModel) {
        super.init(frame: CGRect.zero)
        
        weatherModel = weather
        
        fetchUnits()
        buildViews()
        constraintViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews(){
        stackView1 = UIStackView()
        stackView1.axis = .horizontal
        stackView1.spacing = 30
        stackView1.distribution = .fillEqually
        self.addSubview(stackView1)
        
        stackView2 = UIStackView()
        stackView2.axis = .horizontal
        stackView2.spacing = 30
        stackView2.distribution = .fillEqually
        self.addSubview(stackView2)
        
        viewCell1 = BottomViewCell()
        let weatherDirectionImage = weatherIcons.windIcon(degree: weatherModel.current.windDeg)
        if(windsUnit == windUnit.kmh){
            viewCell1.setData(image: UIImage(systemName: weatherDirectionImage, withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "\(weatherModel.current.windSpeed) km/h", bottomText: "Wind")
        }else if(windsUnit == windUnit.knots){
            viewCell1.setData(image: UIImage(systemName: weatherDirectionImage, withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "\(weatherModel.current.windSpeed) knots", bottomText: "Wind")
        }else if(windsUnit == windUnit.mph){
            viewCell1.setData(image: UIImage(systemName: weatherDirectionImage, withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "\(weatherModel.current.windSpeed) mph", bottomText: "Wind")
        }else{
            viewCell1.setData(image: UIImage(systemName: weatherDirectionImage, withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "\(weatherModel.current.windSpeed) mps", bottomText: "Wind")
        }
        stackView1.addArrangedSubview(viewCell1)
        
        viewCell2 = BottomViewCell()
        viewCell2.setData(image: UIImage(systemName: "sun.max", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "\(weatherModel.current.uvi)", bottomText: "UV radiation")
        stackView1.addArrangedSubview(viewCell2)

        viewCell3 = BottomViewCell()
        if(pressuresUnit == pressureUnit.atm){
            viewCell3.setData(image: UIImage(systemName: "thermometer", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "\(weatherModel.current.pressure) atm", bottomText: "Pressure")
        }else if(pressuresUnit == pressureUnit.hpa){
            viewCell3.setData(image: UIImage(systemName: "thermometer", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "\(weatherModel.current.pressure) hpa", bottomText: "Pressure")
        }else if(pressuresUnit == pressureUnit.inhg){
            viewCell3.setData(image: UIImage(systemName: "thermometer", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "\(weatherModel.current.pressure) inhf", bottomText: "Pressure")
        }else if(pressuresUnit == pressureUnit.mmhg){
            viewCell3.setData(image: UIImage(systemName: "thermometer", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "\(weatherModel.current.pressure) mmhg", bottomText: "Pressure")
        }else{
            viewCell3.setData(image: UIImage(systemName: "thermometer", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "\(weatherModel.current.pressure) mbar", bottomText: "Pressure")
        }
        stackView2.addArrangedSubview(viewCell3)

        viewCell4 = BottomViewCell()
        viewCell4.setData(image: UIImage(systemName: "drop", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "\(weatherModel.current.humidity)%", bottomText: "Humidity")
        stackView2.addArrangedSubview(viewCell4)

    }
    
    private func constraintViews(){
        stackView1.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(45)
            $0.top.equalToSuperview()
            $0.height.equalTo(50)
        })
        
        
        stackView2.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.top.equalTo(stackView1.snp.bottom)
            $0.height.equalTo(50)
        })
    }
    
    func fetchUnits() {
        guard let data = UserDefaults.standard.data(forKey: "key") else {
            return
        }
        do {
            let decoder = JSONDecoder()
            let settingsModel = try decoder.decode(SettingsModel.self, from: data)
            self.windsUnit = settingsModel.windUnit
            self.pressuresUnit = settingsModel.pressureUnit
        } catch {
            print("Error when decoding SettingsModel")
        }
    }
}

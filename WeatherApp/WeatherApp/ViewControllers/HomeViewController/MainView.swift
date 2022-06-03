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
    private var addLocationImageView: UIImageView!
    private var settingsImageView: UIImageView!
    private var locationNameLabel: UILabel!
    private var currentWeatherImageView: UIImageView!
    private var currentDateLabel: UILabel!
    private var currentDegreesLabel: UILabel!
    private var celsiusSymbol: UILabel!
    private var weatherDescriptionLabel: UILabel!
    private var separatorLine: UIView!
    private var bottomView: BottomView!
    private var pageControl: UIPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildViews()
        styleViews()
        constraintViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews(){
        addLocationImageView = UIImageView(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(scale: .large)))
        self.addSubview(addLocationImageView)
        
        settingsImageView = UIImageView(image: UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(scale: .large)))
        self.addSubview(settingsImageView)
        
        locationNameLabel = UILabel()
        self.addSubview(locationNameLabel)
        
        currentWeatherImageView = UIImageView(image: UIImage(systemName: "cloud.sun.fill"))
        self.addSubview(currentWeatherImageView)
        
        currentDateLabel = UILabel()
        self.addSubview(currentDateLabel)
        
        currentDegreesLabel = UILabel()
        self.addSubview(currentDegreesLabel)
        
        celsiusSymbol = UILabel()
        self.addSubview(celsiusSymbol)
        
        weatherDescriptionLabel = UILabel()
        self.addSubview(weatherDescriptionLabel)
        
        separatorLine = UIView()
        self.addSubview(separatorLine)
        
        bottomView = BottomView()
        self.addSubview(bottomView)
        
        pageControl = UIPageControl()
        self.addSubview(pageControl)
    }
    
    private func styleViews(){
        addLocationImageView.tintColor = .white
        
        settingsImageView.tintColor = .white
        settingsImageView.transform = settingsImageView.transform.rotated(by: .pi / 2)
        
        currentWeatherImageView.tintColor = .white
        
        locationNameLabel.text = "Zagreb"
        locationNameLabel.font = UIFont(name: "Helvetica Neue Bold", size: 14)
        locationNameLabel.textColor = .white
        
        currentDateLabel.text = "Monday | Jun 6"
        currentDateLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        currentDateLabel.textColor = .white
        
        currentDegreesLabel.text = "28"
        currentDegreesLabel.font = UIFont(name: "Helvetica Neue Bold", size: 60)
        currentDegreesLabel.textColor = .white
        
        celsiusSymbol.text = "°"
        celsiusSymbol.font = UIFont(name: "Helvetica Neue", size: 50)
        celsiusSymbol.textColor = .white
        
        weatherDescriptionLabel.text = "Sunny"
        weatherDescriptionLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        weatherDescriptionLabel.textColor = .white
        
        separatorLine.backgroundColor = .white
        
        pageControl.numberOfPages = 2
    }
    
    private func constraintViews(){
        addLocationImageView.snp.makeConstraints({
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(25)
        })
        
        settingsImageView.snp.makeConstraints({
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(25)
        })
        
        locationNameLabel.snp.makeConstraints({
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        })
        
        pageControl.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(locationNameLabel.snp.bottom)
        })
        
        currentWeatherImageView.snp.makeConstraints({
            $0.top.equalTo(pageControl.snp.bottom).offset(10)
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
        
        celsiusSymbol.snp.makeConstraints({
            $0.top.equalTo(currentDegreesLabel.snp.top).offset(-5)
            $0.trailing.equalTo(currentDegreesLabel.snp.trailing).offset(15)
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
}

//
//  MainScrollView.swift
//  WeatherApp
//
//  Created by Nikola Đokić on 09.06.2022..
//

import Foundation
import UIKit

class MainScrollView: UIView, UIScrollViewDelegate{
    
    var cityChangedDelegate: CityChangeDelegate?
    private var weather: [WeatherModel] = []
    private var city: [CityNameModel] = []
    private var pageControl: UIPageControl!
    private var scrollview: UIScrollView!
    private var delegate: MainViewDelegate!
    var frames: CGRect = CGRect(x:0, y:0, width:0, height:0)

    
    init(cities: [CityNameModel], weathers: [WeatherModel], delegate: MainViewDelegate) {
        super.init(frame: CGRect.zero)
        self.city = cities
        self.weather = weathers;
        self.delegate = delegate
        
        buildViews()
        constraintViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews(){
        scrollview = UIScrollView(frame: CGRect(x:0, y:0, width:350, height: 450))
        self.addSubview(scrollview)
        
        scrollview.delegate = self
        scrollview.isPagingEnabled = true
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.bounces = false
        
        scrollview.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
        })
        
        pageControl = UIPageControl()
        self.addSubview(pageControl)
        
        pageControl.snp.makeConstraints({
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        })
        
        for index in 0...city.count - 1{
            frames.origin.x = self.scrollview.frame.size.width * CGFloat(index)
            frames.size = self.scrollview.frame.size
            
            let mainView = MainView(frame: frames)
            mainView.delegate = delegate
            
            self.scrollview.addSubview(mainView)
            mainView.setCity(name: city[index].name)
            mainView.setWeather(weather: weather[index])
            
        }
        
        self.scrollview.contentSize = CGSize(width:self.scrollview.frame.size.width * 3,height: self.scrollview.frame.size.height)

        
        pageControl.numberOfPages = city.count
        pageControl.currentPage = 0
        
    }
    
    private func constraintViews(){
       
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
        cityChangedDelegate?.cityChanged(weatherModel: weather[Int(pageNumber)])
    }
}

protocol CityChangeDelegate{
    func cityChanged(weatherModel: WeatherModel)
}

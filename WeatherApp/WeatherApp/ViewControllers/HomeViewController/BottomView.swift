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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        viewCell1.setData(image: UIImage(systemName: "arrow.up.left.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "3.7km/h", bottomText: "Wind")
        stackView1.addArrangedSubview(viewCell1)
        
        viewCell2 = BottomViewCell()
        viewCell2.setData(image: UIImage(systemName: "cloud.rain", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "74%", bottomText: "Chance of rain")
        stackView1.addArrangedSubview(viewCell2)

        viewCell3 = BottomViewCell()
        viewCell3.setData(image: UIImage(systemName: "thermometer", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "1010mbar", bottomText: "Pressure")
        stackView2.addArrangedSubview(viewCell3)

        viewCell4 = BottomViewCell()
        viewCell4.setData(image: UIImage(systemName: "drop", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!, topText: "83%", bottomText: "Humidity")
        stackView2.addArrangedSubview(viewCell4)

    }
    
    private func constraintViews(){
        stackView1.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.top.equalToSuperview()
            $0.height.equalTo(50)
        })
        
        
        stackView2.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.top.equalTo(stackView1.snp.bottom)
            $0.height.equalTo(50)
        })
    }
}

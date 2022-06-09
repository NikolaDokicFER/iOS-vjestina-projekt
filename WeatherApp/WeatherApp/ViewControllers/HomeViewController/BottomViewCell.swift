//
//  BottomViewCell.swift
//  WeatherApp
//
//  Created by Nikola Đokić on 02.06.2022..
//

import Foundation
import SnapKit
import UIKit

class BottomViewCell: UIView{
    private var image: UIImageView!
    private var topText: UILabel!
    private var bottomText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        buildViews()
        constraintViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews(){
        image = UIImageView()
        image.tintColor = .white
        self.addSubview(image)
        
        topText = UILabel()
        topText.font = UIFont(name: StyleConstants.FontNames.boldFont, size: 14)
        topText.textColor = .white
        self.addSubview(topText)
        
        bottomText = UILabel()
        bottomText.font = UIFont(name: StyleConstants.FontNames.normalFont, size: 14)
        bottomText.textColor = .white
        self.addSubview(bottomText)
    }
    
    
    private func constraintViews(){
        image.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        })
        
        topText.snp.makeConstraints({
            $0.top.equalTo(image.snp.top)
            $0.leading.equalTo(image.snp.trailing).offset(5)
        })
        
        bottomText.snp.makeConstraints({
            $0.top.equalTo(topText.snp.bottom)
            $0.leading.equalTo(image.snp.trailing).offset(5)
        })
    }
    
    public func setData(image: UIImage, topText: String, bottomText: String){
        self.image.image = image
        self.topText.text = topText
        self.bottomText.text = bottomText
    }
    
}

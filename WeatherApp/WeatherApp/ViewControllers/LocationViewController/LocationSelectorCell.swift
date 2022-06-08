import Foundation
import UIKit
import SnapKit

class LocationSelectorCell: UITableViewCell{
    static let cellIdentifier = "cellId"
    
    var weatherPicture = UIImageView()
    var cityName = UILabel()
    var temperatureMinMax = UILabel()
    var weatherDescription = UILabel()
    let currentLocationSelectedIcon = UIImageView(image: UIImage(systemName: "mappin"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        styleViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleViews(){
        
        backgroundColor = .clear
        layer.masksToBounds = false

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        cityName.font = UIFont.systemFont(ofSize: 18)
        cityName.textColor = UIColor(red: 0.105, green: 0.145, blue: 0.254, alpha: 1)
        contentView.addSubview(cityName)
        
        contentView.addSubview(weatherPicture)
        
        weatherDescription.font = UIFont.systemFont(ofSize: 12)
        weatherDescription.textColor = UIColor(red: 0.329, green: 0.357, blue: 0.439, alpha: 1)
        contentView.addSubview(weatherDescription)
        
        temperatureMinMax.font = UIFont.systemFont(ofSize: 12)
        temperatureMinMax.textColor = UIColor(red: 0.329, green: 0.357, blue: 0.439, alpha: 1)
        contentView.addSubview(temperatureMinMax)
    }
    
    func fillWithContent(){
        cityName.text = "Jakarta"
        weatherPicture.image = UIImage(systemName: "cloud.sun.rain.fill")
        weatherDescription.text = "Heavy rain"
        temperatureMinMax.text = "18/26"
    }
    
    func makeConstraints(){
        cityName.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
//        for subview in contentView.subviews {
//            if let item = subview as? UIImageView{
//                currentLocationSelectedIcon.snp.makeConstraints{
//                    $0.top.equalTo(cityName.snp.top)
//                    $0.leading.equalTo(cityName.snp.trailing).offset(5)
//                }
//            }
//        }
        
        temperatureMinMax.snp.makeConstraints{
            $0.leading.equalTo(cityName.snp.leading)
            $0.top.equalTo(cityName.snp.bottom).offset(3)
        }
        
        weatherPicture.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(cityName.snp.top).offset(-3)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
        
        weatherDescription.snp.makeConstraints{
            $0.centerX.equalTo(weatherPicture.snp.centerX)
            $0.top.equalTo(weatherPicture.snp.bottom).offset(5)
        }
    }
}

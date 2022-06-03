import UIKit
import SnapKit

class DayCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: DayCollectionViewCell.self)

    private var cellView: UIView!
    private var timeLabel: UILabel!
    private var weatherIcon: UIImageView!
    private var tempLabel: UILabel!
    private var mainDescriptionLabel: UILabel!
    
    private var weatherIcons = WeatherIcons()
    private var conversionFunctions = ConversionFunctions()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildCell()
        buildCellConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildCell() {
        cellView = UIView()
        cellView.backgroundColor = .clear
        addSubview(cellView)
        
        timeLabel = UILabel()
        timeLabel.textColor = StyleConstants.AppColors.textColor
        timeLabel.font = UIFont(name: StyleConstants.FontNames.boldFont, size: StyleConstants.TextSizes.textNormal)
        cellView.addSubview(timeLabel)
        
        weatherIcon = UIImageView()
        weatherIcon.tintColor = StyleConstants.AppColors.weatherIconsColor
        cellView.addSubview(weatherIcon)

        mainDescriptionLabel = UILabel()
        mainDescriptionLabel.textColor = StyleConstants.AppColors.textColor
        mainDescriptionLabel.font = UIFont(name: StyleConstants.FontNames.normalFont, size: StyleConstants.TextSizes.textNormal)
        cellView.addSubview(mainDescriptionLabel)
        
        tempLabel = UILabel()
        tempLabel.textColor = StyleConstants.AppColors.textColor
        tempLabel.font = UIFont(name: StyleConstants.FontNames.normalFont, size: StyleConstants.TextSizes.textNormal)
        cellView.addSubview(tempLabel)
    }
    
    func buildCellConstraints() {
        cellView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        timeLabel.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        })
        
        weatherIcon.snp.makeConstraints({
            $0.bottom.equalTo(cellView.snp.centerY)
            $0.centerX.equalToSuperview()
        })

        mainDescriptionLabel.snp.makeConstraints({
            $0.top.equalTo(cellView.snp.centerY).offset(5)
            $0.centerX.equalToSuperview()
        })
        
        tempLabel.snp.makeConstraints({
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        })
    }
    
    func set(inputIndexPath: Int, inputWeatherModel: WeatherModel) {
        
        if (inputIndexPath == 0) {
            timeLabel.text = "Now"
        }
        else {
            let currentDate = Date()
            let hours = (Calendar.current.component(.hour, from: currentDate))
            var timeStamp = hours + inputIndexPath
            if (timeStamp >= 24) {
                timeStamp -= 24
            }
            timeLabel.text = "\(timeStamp):00"
        }
        
        let weatherHourData = inputWeatherModel.hourly[inputIndexPath]
        let systemIcon = weatherIcons.weatherIcon(conditionId: weatherHourData.weather[0].id)
        weatherIcon.image = UIImage(systemName: systemIcon, withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        
        mainDescriptionLabel.text = weatherHourData.weather[0].main
        
        
        let temp = conversionFunctions.toCelsius(kelvin: weatherHourData.temp)
        tempLabel.text = "\(temp)°"
    }
    
}

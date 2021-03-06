import UIKit
import SnapKit

class ForcatsTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ForcatsTableViewCell.self)
    
    private var cellView: UIView!
    private var dayLabel: UILabel!
    private var weatherIcon: UIImageView!
    private var mainDescriptionLabel: UILabel!
    private var tempHLLabel: UILabel!
    
    private var weatherIcons = WeatherIcons()
    private var conversionFunctions = ConversionFunctions()
    
    private var tempUnit: temperatureUnit?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildCell()
        buildCellConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildCell() {
        cellView = UIView()
        cellView.backgroundColor = StyleConstants.AppColors.lightBlue
        addSubview(cellView)
        
        dayLabel = UILabel()
        dayLabel.textColor = StyleConstants.AppColors.textColor
        dayLabel.font = UIFont(name: StyleConstants.FontNames.boldFont, size: StyleConstants.TextSizes.textNormal)
        cellView.addSubview(dayLabel)
        
        weatherIcon = UIImageView()
        weatherIcon.tintColor = StyleConstants.AppColors.weatherIconsColor
        cellView.addSubview(weatherIcon)
        
        mainDescriptionLabel = UILabel()
        mainDescriptionLabel.textColor = StyleConstants.AppColors.textColor
        mainDescriptionLabel.font = UIFont(name: StyleConstants.FontNames.normalFont, size: StyleConstants.TextSizes.textNormal)
        cellView.addSubview(mainDescriptionLabel)
        
        tempHLLabel = UILabel()
        tempHLLabel.textColor = StyleConstants.AppColors.textColor
        tempHLLabel.font = UIFont(name: StyleConstants.FontNames.normalFont, size: StyleConstants.TextSizes.textNormal)
        cellView.addSubview(tempHLLabel)
    }
    
    private func buildCellConstraints() {
        cellView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        dayLabel.snp.makeConstraints({
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        })
        
        mainDescriptionLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview().offset(1.5*5)
            $0.centerY.equalToSuperview()
        })
        
        weatherIcon.snp.makeConstraints({
            $0.trailing.equalTo(mainDescriptionLabel.snp.leading).offset(-5)
            $0.centerY.equalToSuperview()
        })
        
        tempHLLabel.snp.makeConstraints({
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        })
    }
    
    func set(inputIndexPath: Int, inputWeatherModel: WeatherModel) {
        fetchUnits()
        
        let date = Calendar.current.date(byAdding: .day, value: inputIndexPath+1, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfTheWeekString = dateFormatter.string(from: date!)
        dayLabel.text = dayOfTheWeekString
        
        let weatherDayData = inputWeatherModel.daily[inputIndexPath]
        let systemIcon = weatherIcons.weatherIcon(conditionId: weatherDayData.weather[0].id)
        let image = UIImage(systemName: systemIcon, withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        image?.withRenderingMode(.automatic)
        let config = UIImage.SymbolConfiguration.preferringMulticolor()
        weatherIcon.image = image!.applyingSymbolConfiguration(config)
        
        mainDescriptionLabel.text = weatherDayData.weather[0].main
        
        if (tempUnit == temperatureUnit.C) {
            let min = conversionFunctions.toCelsius(kelvin: weatherDayData.temp.min)
            let max = conversionFunctions.toCelsius(kelvin: weatherDayData.temp.max)
            tempHLLabel.text = "\(min)??C/\(max)??C"
        }
        else {
            let min = conversionFunctions.toFahrenheit(kelvin: weatherDayData.temp.min)
            let max = conversionFunctions.toFahrenheit(kelvin: weatherDayData.temp.max)
            tempHLLabel.text = "\(min)??F/\(max)??F"
        }
        
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

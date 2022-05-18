import UIKit
import SnapKit

class ForcatsTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ForcatsTableViewCell.self)
    
    private var cellView: UIView!
    private var dayLabel: UILabel!
    private var weatherIcon: UIImageView!
    private var rainProbabilityLabel: UILabel!
    private var tempHLLabel: UILabel!

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
        cellView.backgroundColor = .systemBlue
        addSubview(cellView)
        
        dayLabel = UILabel()
        dayLabel.textColor = .white
        dayLabel.font = UIFont(name: "Helvetica Neue Bold", size: 14)
        cellView.addSubview(dayLabel)
        
        weatherIcon = UIImageView()
        weatherIcon.tintColor = .white
        cellView.addSubview(weatherIcon)
        
        rainProbabilityLabel = UILabel()
        rainProbabilityLabel.textColor = .white
        rainProbabilityLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        cellView.addSubview(rainProbabilityLabel)
        
        tempHLLabel = UILabel()
        tempHLLabel.textColor = .white
        tempHLLabel.font = UIFont(name: "Helvetica Neue", size: 14)
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
        
        rainProbabilityLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview().offset(1.5*5)
            $0.centerY.equalToSuperview()
        })
        
        weatherIcon.snp.makeConstraints({
            $0.trailing.equalTo(rainProbabilityLabel.snp.leading).offset(-5)
            $0.centerY.equalToSuperview()
        })
        
        tempHLLabel.snp.makeConstraints({
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        })
    }
    
    func set(inputThing: Int) {
        dayLabel.text = "Sun"
        weatherIcon.image = UIImage(systemName: "cloud", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        rainProbabilityLabel.text = "74% rain"
        tempHLLabel.text = "20°/24°"
    }

}

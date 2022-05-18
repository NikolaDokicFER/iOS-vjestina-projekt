import UIKit
import SnapKit

class DayCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: DayCollectionViewCell.self)

    private var cellView: UIView!
    private var timeLabel: UILabel!
    private var weatherIcon: UIImageView!
    private var rainProbabilityLabel: UILabel!
    private var tempHLLabel: UILabel!
    
    //private var someInputModel = SomeModel(results: [])
    
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
        cellView.backgroundColor = .systemBlue
        addSubview(cellView)
        
        timeLabel = UILabel()
        timeLabel.textColor = .white
        timeLabel.font = UIFont(name: "Helvetica Neue Bold", size: 14)
        cellView.addSubview(timeLabel)
        
        weatherIcon = UIImageView()
        weatherIcon.tintColor = .white
        cellView.addSubview(weatherIcon)

        tempHLLabel = UILabel()
        tempHLLabel.textColor = .white
        tempHLLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        cellView.addSubview(tempHLLabel)
        
        rainProbabilityLabel = UILabel()
        rainProbabilityLabel.textColor = .white
        rainProbabilityLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        cellView.addSubview(rainProbabilityLabel)
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

        tempHLLabel.snp.makeConstraints({
            $0.top.equalTo(cellView.snp.centerY)
            $0.centerX.equalToSuperview()
        })
        
        rainProbabilityLabel.snp.makeConstraints({
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        })
    }
    
    func set(inputThing: Int) {
        timeLabel.text = "10:00"
        weatherIcon.image = UIImage(systemName: "cloud", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        tempHLLabel.text = "20°/24°"
        rainProbabilityLabel.text = "74% rain"
    }
    
}

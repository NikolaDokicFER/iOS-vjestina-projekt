import Foundation
import UIKit
import SnapKit

class SearchBarView: UIView {
    
    weak var delegate: UITextFieldDelegate?
    
    let magnifierIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    let searchInputTextField = UITextField()
    let closeCrossButton = UIButton()
    let cancelButton = UIButton()
    let backgroundColorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        styleSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleSubviews() {
        backgroundColorView.backgroundColor = .systemGray
        backgroundColorView.layer.cornerRadius = 10

        magnifierIcon.tintColor = UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1)
                
        closeCrossButton.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        closeCrossButton.tintColor = UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1)
                
        let customSearch = NSAttributedString(string: "Search",
                                              attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18) as Any])
                
        searchInputTextField.attributedPlaceholder = customSearch
        searchInputTextField.rightView = closeCrossButton
        searchInputTextField.rightViewMode = .whileEditing
        closeCrossButton.addTarget(self, action: #selector(crossClearButtonTapped(_:)), for: .touchUpInside)
                
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelButton.setTitleColor(UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        
        self.addSubview(backgroundColorView)
        self.addSubview(magnifierIcon)
        self.addSubview(searchInputTextField)
        self.addSubview(closeCrossButton)
        self.addSubview(cancelButton)
        
        notSelected()
    }
    
    func constraintsWhenSelected(){
        magnifierIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(13)
            $0.height.equalTo(25)
            $0.width.equalTo(25)
        }
                
        searchInputTextField.snp.makeConstraints{
            $0.leading.equalTo(magnifierIcon.snp.trailing).offset(10)
            $0.top.equalTo(magnifierIcon).offset(2)
            $0.height.equalTo(20)
            $0.trailing.equalToSuperview().inset(95)
        }
                
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(searchInputTextField).offset(-7)
            $0.trailing.equalToSuperview().inset(10)
        }
                
        backgroundColorView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(85)
        }
    }
    
    func constraintsWhenNotSelected(){
        magnifierIcon.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(13)
            $0.height.equalTo(25)
            $0.width.equalTo(25)
        }
                
        searchInputTextField.snp.remakeConstraints{
            $0.leading.equalTo(magnifierIcon.snp.trailing).offset(10)
            $0.top.equalTo(magnifierIcon).offset(2)
            $0.height.equalTo(20)
            $0.trailing.equalTo(cancelButton.snp.leading).offset(-10)
        }
                
        cancelButton.snp.remakeConstraints {
            $0.top.equalTo(searchInputTextField).offset(-7)
            $0.trailing.equalToSuperview()
        }
            
        backgroundColorView.snp.remakeConstraints {
            $0.leading.top.bottom.trailing.equalToSuperview()
        }
    }
    
    func notSelected() {
        cancelButton.isHidden = true
        constraintsWhenNotSelected()
        searchInputTextField.text = ""
    }
    
    func isSelected() {
        cancelButton.isHidden = false
        constraintsWhenSelected()
    }
    
    @objc
    func cancelButtonTapped(_ sender: UIButton) {
        searchInputTextField.delegate?.textFieldDidEndEditing?(searchInputTextField)
        searchInputTextField.endEditing(true)
//        backgroundColorView.snp.remakeConstraints {
//            $0.edges.equalToSuperview()
//        }
        notSelected()
    }
    
    @objc
    func crossClearButtonTapped(_ sender: UIButton) {
        searchInputTextField.text = ""
    }
    
}

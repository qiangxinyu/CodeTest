//
//  NetworkFailView.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//

import UIKit

class NetworkFailureView: UIView {
    deinit {
        print("deinit", self)
    }
    
    private let tipLabel = UILabel()
    private let button = UIButton(type: .roundedRect)
    
    init() {
        super.init(frame: .zero)
        isHidden = true
        layoutViews()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var buttonTitle: String? {
        set { button.setTitle(newValue, for: .normal) }
        get { button.titleLabel?.text }
    }
    
    var title: String? {
        set { tipLabel.text = newValue }
        get { tipLabel.text }
    }
    
    var isEnable: Bool {
        set { button.isEnabled = newValue }
        get { button.isEnabled }
    }
    
    func layoutForSuperView(_ superView: UIView, vm: NetworkFailureViewModel?) {
        button.addTarget(vm, action: #selector(NetworkFailureViewModel.clickRefreshButton), for: .touchUpInside)
        vm?.errorView = self
        superView.addSubview(self)

        snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(40)
            make.right.greaterThanOrEqualTo(-40)
            make.center.equalToSuperview()
        }
    }
    
 
    func layoutViews() {
        addSubview(tipLabel)
        addSubview(button)
        tipLabel.numberOfLines = 0
        tipLabel.textAlignment = .center
        
        tipLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        
        button.backgroundColor = button.tintColor
        button.setTitle("Reload", for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(tipLabel.snp.bottom).offset(10)
            make.width.equalTo(120)
            make.height.equalTo(44)
            make.left.greaterThanOrEqualTo(0)
            make.right.greaterThanOrEqualTo(0)
            make.centerX.equalToSuperview()
        }
    }
}

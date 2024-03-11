//
//  SortView.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//

import UIKit

class SortView: UIView {
    deinit {
        print("deinit", self)
    }
    
    weak var vm: HeaderViewModel? {
        didSet {
            vm?.segemntedView = segemntedView
        }
    }

    private let titleLabel = UILabel()
    let segemntedView = UISegmentedControl()
    
    init() {
        super.init(frame: .zero)
        layoutViews()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func layoutViews() {
        addSubview(titleLabel)
        addSubview(segemntedView)
        
        titleLabel.font = .pingFang(size: 12)
        titleLabel.textColor = .HEX("555555")
        titleLabel.text = "Sorting option"
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(Styles.margin)
            make.top.equalToSuperview()
        }
        
        segemntedView.insertSegment(withTitle: "Off", at: 0, animated: true)
        segemntedView.insertSegment(withTitle: "Sort by Price", at: 1, animated: true)
        segemntedView.selectedSegmentIndex = 0

        segemntedView.snp.makeConstraints { make in
            make.left.equalTo(Styles.margin)
            make.right.equalTo(-Styles.margin)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.height.equalTo(30)
            
        }
    }
}

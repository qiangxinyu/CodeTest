//
//  HeaderView.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//

import UIKit

class HeaderView: UIView {
    deinit {
        print("deinit", self)
    }
    
    weak var vm: HeaderViewModel?

    private let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    
    private let titleLabel = UILabel()
    private let titleLineLayer = CALayer.lineLayer()
    var title: String? {
        set { titleLabel.text = newValue }
        get { titleLabel.text }
    }
    
    
    private let searchView = UISearchBar()
    
    private let sortView = SortView()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLineLayer.frame = .init(x: x, y: safeArea.top + 30, width: width, height: 0.5)
    }
    
    
    
    func layoutForSuperView(_ superView: UIView, vm: HeaderViewModel?) {
        self.vm = vm
        searchView.delegate = vm
        sortView.vm = vm

        superView.addSubview(self)
        
        title = "iTunes Music"
        
        snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(150 + safeArea.top)
        }
    }
    
    
    
    private func layoutViews() {
        addSubview(backgroundView)
        addSubview(titleLabel)
        layer.addSublayer(titleLineLayer)
        addSubview(searchView)
        addSubview(sortView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.centerX.equalToSuperview()
        }
        
        
        searchView.placeholder = "Search Artist Or Song Name"
        searchView.backgroundImage = .init()
        searchView.snp.makeConstraints { make in
            make.left.equalTo(3)
            make.right.equalTo(-3)
            make.height.equalTo(60)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        
        
        sortView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
}

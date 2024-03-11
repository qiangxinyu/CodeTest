//
//  LoadingView.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/7.
//

import UIKit


class LoadingView: UIView {
    deinit {
        print("deinit", self)
    }
    
    private let activityView = UIActivityIndicatorView(style: .large)
    
    init() {
        super.init(frame: .zero)
        isHidden = true
        addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override var isHidden: Bool {
        didSet {
            isHidden ? activityView.stopAnimating() : activityView.startAnimating()
        }
    }
    
    func layoutForSuperView(_ superView: UIView, vm: LoadingViewModel?) {
        
        vm?.loadingView = self
        superView.addSubview(self)

        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

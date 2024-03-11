//
//  TableView.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//

import UIKit
import SnapKit


class TableView: UITableView {
    deinit {
        print("deinit", self)
    }
    
    init() {
        super.init(frame: .zero, style: .plain)
        
        register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        
        estimatedRowHeight = 0
        estimatedSectionFooterHeight = 0
        estimatedSectionHeaderHeight = 0
        
        contentInsetAdjustmentBehavior = .never
        
        separatorStyle = .none
        
        contentInset = .init(top: 150 + safeArea.top, left: 0, bottom: safeArea.bottom, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutForSuperView(_ superView: UIView, vm: TableViewModel?) {
        superView.addSubview(self)
        
        delegate = vm
        dataSource = vm
        vm?.tableView = self
        
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}



class Cell: UITableViewCell {
    static let identifier = "SongCellIdentifier"
    
    let previewImageView = UIImageView()
    let nameLabel = UILabel()
    let artistLabel = UILabel()
    let priceLabel = UILabel()
    let lineLayer = CALayer.lineLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("init cell")
        layoutViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineLayer.frame = .init(x: 0, y: height, width: width, height: 0.5)
    }
    
    private func layoutViews() {
        
        contentView.addSubview(previewImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(priceLabel)
        contentView.layer.addSublayer(lineLayer)
        
        previewImageView.layer.masksToBounds = true
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.backgroundColor = .HEX("AAAAAA")
        previewImageView.snp.makeConstraints { make in
            make.left.equalTo(Styles.margin)
            make.centerY.equalToSuperview()
            make.top.equalTo(10)
            make.aspectRatio(1, view: previewImageView)
        }
        
        nameLabel.font = .pingFang(name: .medium, size: 16)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.1
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(previewImageView.snp.right).offset(10)
            make.bottom.equalTo(self.snp.centerY).offset(-3)
            make.right.equalTo(-Styles.margin)
        }
        
        artistLabel.font = .pingFang(size: 14)
        artistLabel.adjustsFontSizeToFitWidth = true
        artistLabel.minimumScaleFactor = 0.1
        artistLabel.snp.makeConstraints { make in
            make.left.equalTo(previewImageView.snp.right).offset(10)
            make.top.equalTo(self.snp.centerY).offset(3)
            make.right.equalTo(priceLabel.snp.left).offset(-10)
        }
        
        priceLabel.font = .pingFang(size: 14)
        priceLabel.textColor = .HEX("666666")
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(previewImageView.snp.bottom)
            make.right.equalTo(-Styles.margin)
        }
    }
}

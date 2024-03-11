//
//  CALayer.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//

import UIKit

extension CALayer {
    static func lineLayer() -> CALayer {
        let lineLayer = CALayer()
        lineLayer.backgroundColor = UIColor.HEX("CCCCCC").cgColor

        return lineLayer
    }
}

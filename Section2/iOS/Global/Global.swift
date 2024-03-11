//
//  Porperty.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit



public func print(_ args: Any...) {
    #if DEBUG
    print("------------------------------ \\_/ ------------------------------", separator: "", terminator: "\n")
    print(args, separator: "--->>>", terminator: "\n")
    print("------------------------------ /_\\ ------------------------------", separator: "", terminator: "\n")
    #endif
}



public let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
public let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad


func refreshScreenInfo() {
    kScreenBounds = UIScreen.main.bounds
    kScreenSize = kScreenBounds.size
    kScreenWidth = kScreenSize.width
    kScreenHeight = kScreenSize.height
}

func refreshSafeArea() {
    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    safeArea = scene?.windows.first?.safeAreaInsets ?? .zero
}

fileprivate(set) var kScreenBounds = UIScreen.main.bounds
fileprivate(set) var kScreenSize: CGSize = kScreenBounds.size
fileprivate(set) var kScreenWidth: CGFloat = kScreenSize.width
fileprivate(set) var kScreenHeight: CGFloat = kScreenSize.height

fileprivate(set) var safeArea: UIEdgeInsets = .zero

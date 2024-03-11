//
//  NetworkAPIConfig.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//

import Foundation
import Alamofire

protocol NetworkAPIConfig {
    
    var domain: String {get}
    
    var path: String {get}
    
    var method: HTTPMethod {get}
    
    func header() -> HTTPHeaders
    
    var parameters: [String: Any]? {get}
    
    var encoder: ParameterEncoding {get}
}

extension NetworkAPIConfig {
    var domain: String  { "https://itunes.apple.com" }

    var method: HTTPMethod { .get }

    func header() -> HTTPHeaders {
        return [:]
    }
    
    var encoder: ParameterEncoding { JSONEncoding.default }
    
    static func ==(v1: Self, v2: NetworkAPIConfig) -> Bool {
        return v1.path == v2.path
    }
}



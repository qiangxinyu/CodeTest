//
//  NetworkAPIConfig_iTunes.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//

import Foundation
import Alamofire

enum NetworkAPIConfig_iTunes: NetworkAPIConfig {
    
    case list(term: String, limit: Int, country: String)
    
    var path: String {
        switch self {
        case .list: return "/search"
        }
    }
    
    var encoder: ParameterEncoding {
        switch self {
        case .list: return URLEncoding.default
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .list(term, limit, country):
            
            var params = [String: Any]()
            params["term"] = term
            params["limit"] = limit
            params["country"] = country
            
            return params
        }
    }
}

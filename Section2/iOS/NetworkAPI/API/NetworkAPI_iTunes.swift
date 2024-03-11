//
//  NetworkAPI_iTunes.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//

import Foundation
import Combine

protocol NetworkAPI_iTunes: NetworkAPI {
    
}

extension NetworkAPI_iTunes {
    func list(term: String, limit: Int, country: String) -> AnyPublisher<NetworkRequestStatus<iTunesModel>, Never> {
        request(config: NetworkAPIConfig_iTunes.list(term: term, limit: limit, country: country), isRefresh: true, timeoutInterval: 20)
    }
}

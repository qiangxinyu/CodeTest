//
//  NetworkAPI.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//

import Foundation
import ObjectMapper
import Alamofire
import Combine




protocol NetworkAPI {}

extension NetworkAPI {
    func request<T: Mappable>(config: NetworkAPIConfig,
                              isRefresh: Bool,
                              timeoutInterval: TimeInterval) -> AnyPublisher<NetworkRequestStatus<T>, Never>
    {

        
        let request = AF.request(
            config.domain + config.path,
            method: config.method,
            parameters: config.parameters,
            encoding: config.encoder,
            headers: config.header())
        {$0.timeoutInterval = timeoutInterval}
        
        
        let publish = PassthroughSubject<NetworkRequestStatus<T>, Never>()

        request.responseString { response in
            switch response.result {
            case .success(let jsonString):
                if let model = T(JSONString: jsonString) {
                    publish.send(.success(model))
                } else {
                    print("json decode error jsonString", jsonString)
                    publish.send(.error(.jsonSerializationFail))
                }
            case .failure(let error):
                print("request error", error.localizedDescription)
                publish.send(.error(.requestFail(error)))
                break
            }
        }

        return publish.eraseToAnyPublisher()
    }
}


enum NetworkRequestStatus<T> {
    case success(T)
    case error(NETError)
}

enum NETError: Error {
    case jsonSerializationFail
    case requestFail(Error)
}

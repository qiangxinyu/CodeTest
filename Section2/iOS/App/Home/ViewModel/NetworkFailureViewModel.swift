//
//  NetworkFailureViewModel.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/7.
//

import UIKit
import Combine


class NetworkFailureViewModel: Subscriber {
   
    deinit {
        print("deinit", self)
    }
    
    weak var output: PassthroughSubject<ViewModel.Input, Never>?

    
    typealias Input = ViewModel.Output
    typealias Failure = Never
    
    weak var errorView: NetworkFailureView?
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
    }
    
    func receive(_ input: ViewModel.Output) -> Subscribers.Demand {
        switch input {
        case .fetchListError(let errorString):
            errorView?.title = errorString
            errorView?.buttonTitle = "Reload"
        case .displayError(let isShow):
            errorView?.isHidden = !isShow
        case .airplane:
            errorView?.buttonTitle = "Please close it"
            errorView?.title = "now is airplan mode, please close it"
        case .networkNotAuthority:
            errorView?.title = "network is not authority, please to Setting change it"
            errorView?.buttonTitle = "Go Setting"
        case .networkLinked:
            errorView?.title = "network reconnect"
            errorView?.buttonTitle = "Reload"
        default: break
        }
        return .none
    }
    
    @objc func clickRefreshButton() {
        switch NetworkStatus.status {
        case .airplane: break
        case .notAuthority:
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url)
            }
        default: output?.send(.refreshList)
        }
    }
}

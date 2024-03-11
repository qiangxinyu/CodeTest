//
//  LoadingViewModel.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/7.
//

import UIKit
import Combine

class LoadingViewModel: Subscriber {
   
    deinit {
        print("deinit", self)
    }
    
    typealias Input = ViewModel.Output
    typealias Failure = Never
    
    weak var loadingView: LoadingView?
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {}
    
    func receive(_ input: ViewModel.Output) -> Subscribers.Demand {
        switch input {
        case .displayLoading(let isShow):
            loadingView?.isHidden = !isShow
    
        default: break
        }
        return .none
    }
}

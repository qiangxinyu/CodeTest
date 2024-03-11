//
//  HeaderViewModel.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//


import UIKit
import Combine

class HeaderViewModel: NSObject, UISearchBarDelegate {
    deinit {
        print("deinit", self)
    }
    
    weak var output: PassthroughSubject<ViewModel.Input, Never>?
    
    private var cancellables = Set<AnyCancellable>()

    weak var segemntedView: UISegmentedControl? {
        didSet {
            segemntedView?.publisher(for: \.selectedSegmentIndex).sink(receiveValue: {[weak self] index in
                self?.output?.send(.sort(index == 0 ? .artist : .price))
            }).store(in: &cancellables)
        }
    }

    // MARK: Search Bar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output?.send(.keyword(searchText))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
        output?.send(.keyword(nil))
        searchBar.text = ""
    }
}

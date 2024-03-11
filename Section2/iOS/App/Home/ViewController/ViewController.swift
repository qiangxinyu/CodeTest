//
//  ViewController.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//

import UIKit

import Combine

class ViewController: UIViewController {
    
    private let input: PassthroughSubject<ViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    private let vm = ViewModel()
    
    private let tableView = TableView()
    private let tableViewViewModel = TableViewModel()
    
    private let headerView = HeaderView()
    private let headerViewModel = HeaderViewModel()
    
    private let errorView = NetworkFailureView()
    private let errorViewModel = NetworkFailureViewModel()
    
    private let loadingView = LoadingView()
    private let loadingViewModel = LoadingViewModel()
    
    deinit {
        print("deinit", self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange

        layoutViews()

        bind()

        input.send(.refreshList)
    }
    
    
  
    
    private func bind() {
        weak var input = self.input
        
        let output = vm.transform(input: input!.eraseToAnyPublisher())

   
        output.receive(subscriber: tableViewViewModel)
        output.receive(subscriber: errorViewModel)
        output.receive(subscriber: loadingViewModel)

        headerViewModel.output = input
        errorViewModel.output = input
    }

    private func layoutViews() {
        tableView.layoutForSuperView(view, vm: tableViewViewModel)
        headerView.layoutForSuperView(view, vm: headerViewModel)
        errorView.layoutForSuperView(view, vm: errorViewModel)
        loadingView.layoutForSuperView(view, vm: loadingViewModel)
    }
}


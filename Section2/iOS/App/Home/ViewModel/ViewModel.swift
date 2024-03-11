//
//  ViewModel.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//

import Foundation
import Combine

class ViewModel: NetworkAPI_iTunes {
    deinit {
        print("deinit", self)
        output.send(completion: .finished)
    }
    
    enum Input {
        case refreshList
        case keyword(String?)
        case sort(SortType)
    }
    
    enum Output {
        case displayLoading(Bool)
        case displayError(Bool)
        case fetchListError(String)
        case listRefresh([SongModel])
        
        case networkNotAuthority
        case airplane
        case networkLinked
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var originList = [SongModel]()
        
    private(set) var keyword: String? = nil
    private(set) var sortType = SortType.artist
    
    init() {
        NotificationCenter.default.publisher(for: .networkChange).sink {[weak self] notification in

            switch NetworkStatus.status {
            case .airplane:
                self?.networkChangeSendError(.airplane)
            case .notAuthority:
                self?.networkChangeSendError(.networkNotAuthority)
            default:                self?.output.send(.networkLinked)

                if (self?.originList.count ?? 0) == 0 {
                    self?.iTunesList()
                }
            }
        }.store(in: &cancellables)
    }
    
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .refreshList:
                self?.iTunesList()
            case .keyword(let key):
                self?.keyword = key
                self?.handleAndSendRefreshList()
            case .sort(let sortType):
                self?.sortType = sortType
                self?.handleAndSendRefreshList()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func networkChangeSendError(_ out: Output) {
        output.send(out)
        if originList.isEmpty {
            output.send(.displayError(true))
        }
    }
    
    private func iTunesList() {
        if !NetworkStatus.status.hasNetwork { return }
        
        output.send(.displayLoading(true))
        output.send(.displayError(false))
        
        list(term: "歌", limit: 200, country: "HK").sink {[weak self] event in
            
            switch event {
            case .error(let err):
                self?.originList = []
                
                var errorString = ""
                switch err {
                case .requestFail(let err): errorString = "http request failure info: " + err.localizedDescription
                case .jsonSerializationFail: errorString = "json serialization fail"
                }
                
                self?.output.send(.fetchListError(errorString))
                self?.output.send(.displayError(true))
                self?.output.send(.displayLoading(false))
            case .success(let model):
                self?.originList = model.results
                self?.handleAndSendRefreshList()
                self?.output.send(.displayError(false))
                self?.output.send(.displayLoading(false))
            }
        }
        .store(in: &cancellables)

    }
    
    private func handleAndSendRefreshList() {
        let songList = originList.filterBy(keyword).sortBy(sortType)
        output.send(.listRefresh(songList))
    }
    
    enum SortType {
        case artist
        case price
    }
}

extension Array where Element == SongModel {
    func sortBy(_ type: ViewModel.SortType) -> [Element] {
        switch type {
        case .artist:
            return sorted { $0.artistLetter < $1.artistLetter }
        case .price:
            return sorted { $0.trackPrice < $1.trackPrice }
        }
    }
    
    func filterBy(_ keywork: String?) -> [Element] {
        if keywork?.isEmpty == false, let keywork = keywork?.uppercased() {
            return filter {
                $0.trackName.contains(keywork) ||
                $0.artistLetter.contains(keywork) ||
                $0.artistName.contains(keywork)
            }
        }
        
        return self
    }
}

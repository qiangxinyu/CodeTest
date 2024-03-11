//
//  TableViewModel.swift
//  Section2
//
//  Created by 强新宇 on 2024/3/6.
//


import UIKit
import AlamofireImage
import Combine


class TableViewModel: NSObject, Subscriber, UITableViewDelegate, UITableViewDataSource {
    
    deinit {
        print("deinit", self)
    }
    
    typealias Input = ViewModel.Output
    typealias Failure = Never
   
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {}
    
    func receive(_ input: ViewModel.Output) -> Subscribers.Demand {
        switch input {
        case .listRefresh(let list):
            self.list = list
            tableView?.reloadData()
        default: break
        }
        return .none
    }
    
    
   
    //MARK: TableView Data
    weak var tableView: UITableView?
    
    var list = [SongModel]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as! Cell
        if indexPath.row < list.count {
            setModel(list[indexPath.row], cell: cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: cell set model
        
    func setModel(_ model: SongModel, cell: Cell) {
        cell.previewImageView.image = nil

        if let url = URL(string: model.artworkUrl) {
            cell.previewImageView.af.setImage(withURL: url)
        }

        cell.nameLabel.text = model.trackName
        cell.artistLabel.text = model.artistName
        cell.priceLabel.text = String(format: "$%0.2f", model.trackPrice)
    }
}

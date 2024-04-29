//
//  MainTableViewDataSource.swift
//  Balina Test
//
//  Created by Dulin Gleb on 28.4.24..
//

import Foundation
import UIKit

protocol MainTableViewDataSourceDelegate {
    func didSwipeToEndTable()
    func didSelectRow(id: Int)
}

final class MainTableViewDataSource: NSObject {
    var tableView: UITableView?
    var delegate: MainTableViewDataSourceDelegate?
    
    public var photos: [PhotoModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
}

extension MainTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseId, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.configure(photo: photos[indexPath.row])
        return cell
    }
}

extension MainTableViewDataSource: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        print(position)
        if position > ((tableView?.contentSize.height ?? 0) - scrollView.frame.height - 100) {
            delegate?.didSwipeToEndTable()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(id: photos[indexPath.row].id)
    }
}

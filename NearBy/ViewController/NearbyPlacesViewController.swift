//
//  NearbyPlacesViewController.swift
//  NearBy
//
//  Created by Khaled Elshamy on 06/10/2021.
//

import UIKit
import RxSwift
import RxCocoa

class NearByPlacesViewController: UIViewController {
    
    private var currentLocation: (lat:Double, long:Double)?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PlacesTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var emptyStateView : EmptyStatusView = {
       let e = EmptyStatusView()
        return e
    }()
    
    private let viewModel = NearByViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindTableData()
        getCurrentLocation()
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func getCurrentLocation(){
        viewModel.getCurrentLocation { (message) in
            
        }

    }
    
    private func bindTableData(){
        
        // bind items to tableView
        viewModel.placesCells.bind(
            to: tableView.rx.items)
        { [weak self] tableView, index, element in
            let indexPath = IndexPath(item: index, section: 0)
            switch element {
            case .normal(let cellViewModel):
                let cell:PlacesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.viewModel = cellViewModel
                return cell 
            case .error(let message):
                self?.emptyStateView.emptyImage.image = #imageLiteral(resourceName: "error")
                self?.emptyStateView.labelEmpty.text = message
                tableView.backgroundView = self?.emptyStateView
                return PlacesTableViewCell()
            case .empty:
                self?.emptyStateView.emptyImage.image = #imageLiteral(resourceName: "exclamation")
                self?.emptyStateView.labelEmpty.text = "No data found!"
                tableView.backgroundView = self?.emptyStateView
                return PlacesTableViewCell()
            }
        }.disposed(by: disposeBag)
        
        viewModel
            .onShowLoadingHud
            .map { [weak self] in self?.showLoading(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func showLoading(visible: Bool) {
        
    }
}

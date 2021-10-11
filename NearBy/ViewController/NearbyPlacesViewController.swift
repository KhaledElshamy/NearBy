//
//  NearbyPlacesViewController.swift
//  NearBy
//
//  Created by Khaled Elshamy on 06/10/2021.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD

class NearByPlacesViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PlacesTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false 
        return tableView
    }()
    
    var emptyStateView : EmptyStatusView = {
       let e = EmptyStatusView()
        return e
    }()
    
    
    let viewModel = NearByViewModel(apiClient: ApiClient())
    private let disposeBag = DisposeBag()
    private var progress = JGProgressHUD(style: .light)
    private let userDefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
        bindLoading()
        bindTableData()
        
        // fetch current location
        getCurrentLocation()
    }
    
    private func setupNavigation(){
        navigationItem.title = "Near By"
        let isSingleUpdate = userDefault.bool(forKey: "singleUpdate")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: isSingleUpdate ?  "Single Update" : "Realtime", style: .plain, target: self, action: #selector(addTapped))
    }
    
    // MARK: - handle changing in state
    @objc func addTapped(){
        if userDefault.bool(forKey: "singleUpdate") {
            navigationItem.rightBarButtonItem?.title = "Realtime"
            userDefault.setValue(false, forKey: "singleUpdate")
        }else {
            navigationItem.rightBarButtonItem?.title = "Single Update"
            userDefault.setValue(true, forKey: "singleUpdate")
        }
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func getCurrentLocation(){
        viewModel.getCurrentLocation { [weak self] (message) in
            self?.showEmptyState(image: #imageLiteral(resourceName: "error"), message: message)
        }
    }
    
    // MARK: - bind Loading
    private func bindLoading(){
        // bind loading
        viewModel
            .onShowLoadingHud
            .map { [weak self] in self?.handleLoading(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    // MARK: - binding tableview with names and addresses
    let startLoadingOffset: CGFloat = 20.0
    func isNearTheBottomEdge(contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
            return contentOffset.y + tableView.frame.size.height + startLoadingOffset > tableView.contentSize.height
    }

    private func bindTableData(){
        
        // bind items to tableView
        viewModel
            .placesCells
            .bind(to: tableView.rx.items)
        { [weak self] tableView, index, element in
            let indexPath = IndexPath(item: index, section: 0)
            switch element {
            case .normal(let cellViewModel):
                let cell:PlacesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.viewModel = cellViewModel
                return cell 
            case .error(let message):
                self?.showEmptyState(image: #imageLiteral(resourceName: "error"), message: message)
                return PlacesTableViewCell()
            case .empty:
                self?.showEmptyState(image: #imageLiteral(resourceName: "exclamation"), message: "No data found!")
                return PlacesTableViewCell()
            }
        }
            .disposed(by: disposeBag)
        
        // pagination
        tableView.rx
            .willDisplayCell
            .subscribe(onNext: { [unowned self] cell, indexPath in
                if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1) {
                    viewModel.fetchMoreData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    private func handleLoading(visible: Bool) {
        visible ? showLoading() : stopLoading()
    }
    
    private func showLoading(){
        DispatchQueue.main.async { [unowned self] in
            progress.show(in: self.view)
        }
    }
    
    private func stopLoading(){
        DispatchQueue.main.async { [unowned self] in
            progress.dismiss()
        }
    }
    
    private func showEmptyState(image:UIImage, message:String){
        DispatchQueue.main.async { [unowned self] in
            emptyStateView.emptyImage.image = image
            emptyStateView.labelEmpty.text = message
            tableView.backgroundView = emptyStateView
            tableView.separatorStyle = .none
        }
    }
}

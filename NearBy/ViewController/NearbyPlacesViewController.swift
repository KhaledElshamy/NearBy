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
    
    private func bindTableData(){
        
        // bind loading
        viewModel
            .onShowLoadingHud
            .map { [weak self] in self?.handleLoading(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
        
        // bind items to tableView
        viewModel
            .placesCells
            .bind(to: tableView.rx.items)
        { [weak self] tableView, index, element in
            let indexPath = IndexPath(item: index, section: 0)
            switch element {
            case .normal(let cellViewModel):
                self?.bindPhoto(of: tableView, at: indexPath)
                self?.viewModel.getImage(of: cellViewModel.id ?? "", currentDate: "20211007")
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
    }
    
    private func bindPhoto(of tableView:UITableView, at indexPath:IndexPath){
        viewModel
            .photoUrlOfCell
            .subscribe(
                onNext: { [weak self] model in
                    self?.showImage(of: tableView, at: indexPath, with: model.url ?? "")
                }, onError: { [weak self] error in
                    self?.showImage(of: tableView, at: indexPath, with: "")
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func showImage(of tableView:UITableView, at indexPath:IndexPath, with url:String){
        if let cell = tableView.cellForRow(at: indexPath) as? PlacesTableViewCell {
            if url != "" {
                cell.placeImage.loadImage(url: url)
            }else {
                cell.placeImage.image = #imageLiteral(resourceName: "placeholder")
            }
        }
    }
    
    private func handleLoading(visible: Bool) {
        visible ? showLoading() : stopLoading()
    }
    
    private func showLoading(){
        progress.show(in: self.view)
    }
    
    private func stopLoading(){
        progress.dismiss()
    }
    
    private func showEmptyState(image:UIImage, message:String){
        emptyStateView.emptyImage.image = image
        emptyStateView.labelEmpty.text = message
        tableView.backgroundView = emptyStateView
        tableView.separatorStyle = .none
    }
}

//
//  NearbyPlacesViewModel.swift
//  NearBy
//
//  Created by Khaled Elshamy on 05/10/2021.
//

import RxSwift
import RxCocoa

enum PlacesTableViewCellType {
    case normal(cellViewModel: PlacesCellModel)
    case error(message: String)
    case empty
}

enum PhotosTableViewCellType {
    case normal(cellPhotoViewModel: PhotoCellModel)
    case error(url:String)
    case empty
}

class NearByViewModel {
    
    var placesCells: Observable<[PlacesTableViewCellType]> {
        return cells.asObservable()
    }
    
    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    
    var photoUrlOfCell: Observable<PhotoCellModel> {
        return photoCell.asObservable()
    }
 
    private let locationService = LocationService.shared
    
    private let loadInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay<[PlacesTableViewCellType]>(value: [])
    private let photoCell = BehaviorRelay<PhotoCellModel>(value: PhotoCellModel(url: ""))
    private let disposeBag = DisposeBag()
    
    private let appServerClient: ApiClient
    
    init(apiClient: ApiClient = ApiClient()) {
        self.appServerClient = apiClient
    }
    
    // MARK: - get current location
    func getCurrentLocation(failed: @escaping (String)->()) {
        
        locationService
            .currentLocation
            .subscribe(
            onNext: { [weak self] location in
                if let location = location {
                    self?.getNearbyPlaces(location: location)
                }
            },
            onError: { error in
                failed("Failed to get your Location, check network connection!")
            }
        )
        .disposed(by: disposeBag)
    }
    
    
    // MARK: - get nearby places according to current location
    private func getNearbyPlaces(location: (lat:Double, long:Double)?) {
        loadInProgress.accept(true)
        
        appServerClient
            .getNearbyPlaces(lat: location?.lat ?? 0.0,
                             long: location?.long ?? 0.0,
                             radius: 1000,
                             currentDate: "20211006")
            .subscribe (
            onNext: { [weak self] model in
                
                self?.loadInProgress.accept(false)
                guard model.response?.groups?[0].items?.count ?? 0 > 0 else {
                    self?.cells.accept([.empty])
                    return
                }

                self?.cells.accept( model.response?.groups?[0].items?.compactMap {
                    .normal(cellViewModel: PlacesCellModel(name: $0.venue?.name, id: $0.venue?.id, address: $0.venue?.location?.address))
                } ?? [] )
                
                model.response?.groups?[0].items?.forEach { [weak self] in 
                    self?.getImage(of: $0.venue?.id ?? "", currentDate: "20211006")
                }
            },
            onError: { [weak self] error in
                self?.loadInProgress.accept(false)
                self?.cells.accept([.error(message: "Loading failed, check network connection")])
            }
        )
        .disposed(by: disposeBag)
    }
    
    // MARK: - get image of each place
    func getImage(of id:String, currentDate:String){
        
        appServerClient
            .getPlaceImage(placeId: id, currentDate: currentDate)
            .subscribe(
                onNext: { [weak self] model in
                    guard model.response?.photos?.items?.count ?? 0 > 0 else {
                        self?.cells.accept([.empty])
                        return
                    }
                    
                    let item = model.response?.photos?.items?[0]
                    self?.photoCell.accept(PhotoCellModel(url: item?.itemPrefix ?? "" + "\(String(describing: item?.width))*\(String(describing: item?.height))" + (item?.suffix ?? "")))
                }, onError: { [weak self] error in 
                    self?.photoCell.accept(PhotoCellModel(url: ""))
                }
            )
            .disposed(by: disposeBag)
    }
}

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

class NearByViewModel {
    
    var placesCells: Observable<[PlacesTableViewCellType]> {
        return cells.asObservable()
    }
    
    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
 
    private let locationService = LocationService.shared
    
    private let loadInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay<[PlacesTableViewCellType]>(value: [])
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
                self?.getNearbyPlaces(location: (lat:40.7,long:-74))
            },
            onError: { error in
                failed("Failed to get your Location, check network connection")
            }
        )
        .disposed(by: disposeBag)
    }
    
    
    // MARK: - get nearby places according to current location
    
    private func getNearbyPlaces(location: (lat:Double, long:Double)?) {
        loadInProgress.accept(true)
        
        appServerClient
            .getNearbyPlaces(lat: location?.lat ?? 0.0, long: location?.long ?? 0.0, radius: 1000, currentDate: "20211005")
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
            },
            onError: { [weak self] error in
                self?.loadInProgress.accept(false)
                self?.cells.accept([.error(message: "Loading failed, check network connection")])
            }
        )
        .disposed(by: disposeBag)
    }
}

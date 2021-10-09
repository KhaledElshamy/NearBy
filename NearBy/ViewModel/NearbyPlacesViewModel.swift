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
    
    var photoUrlOfCell: Observable<PhotoCellModel> {
        return photoCell.asObservable()
    }
    
    
    private let loadInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay<[PlacesTableViewCellType]>(value: [])
    private let photoCell = BehaviorRelay<PhotoCellModel>(value: PhotoCellModel(url: ""))
    
    private let locationService = LocationService.shared
    private let disposeBag = DisposeBag()
    private let appServerClient: ApiClient
    
    private var offset:Int = 0
    private var limit:Int = 10
    private var maxPageValue: Int = 50
    private var lastImageCellIndex: Int = 0
    
    init(apiClient: ApiClient) {
        self.appServerClient = apiClient
    }
    
    // MARK: - get current location
    func getCurrentLocation(failed: @escaping (String)->() = { _ in}) {
        
        locationService
            .currentLocation
            .subscribe(
            onNext: { [unowned self] location in
                
                if let location = location {
                    offset = 0
                    lastImageCellIndex = 0
                    getNearbyPlaces(offset: offset, limit: limit, location: location)
                }
            },
            onError: { error in
                failed("Failed to get your Location, check network connection!")
            }
        )
        .disposed(by: disposeBag)
    }
    
    
    // MARK: - get nearby places according to current location
    func getNearbyPlaces(offset:Int,limit:Int,location: (lat:Double, long:Double)?) {
        
        if (offset > maxPageValue) {
            loadInProgress.accept(false)
            return
        }
        
        loadInProgress.accept(true)
        
        appServerClient
            .getNearbyPlaces(lat: location?.lat ?? 0.0,
                             long: location?.long ?? 0.0,
                             radius: 1000,
                             currentDate: DateManager.getCurrentDate(),
                             offset: offset,
                             limit: limit
            )
            .subscribe (
                
            onNext: { [weak self] model in
                
                self?.loadInProgress.accept(false)
                guard model.response?.groups?[0].items?.count ?? 0 > 0 else {
                    self?.cells.accept([.empty])
                    return
                }
                
                if (offset == 0){
                    self?.cells.accept( model.response?.groups?[0].items?.compactMap {
                        .normal(cellViewModel: PlacesCellModel(name: $0.venue?.name, id: $0.venue?.id, address: $0.venue?.location?.address))
                    } ?? [] )
                }else {
                    let oldData = self?.cells.value ?? []
                    self?.cells.accept(oldData + (model.response?.groups?[0].items?.compactMap {
                        .normal(cellViewModel: PlacesCellModel(name: $0.venue?.name, id: $0.venue?.id, address: $0.venue?.location?.address))
                    } ?? [] ))
                }
                
                self?.offset +=  (self?.cells.value.count ?? 0)
                
                let items = model.response?.groups?[0].items ?? []
                for item in items {
                    self?.getImage(of: item.venue?.id ?? "", currentDate: DateManager.getCurrentDate(), index: self?.lastImageCellIndex ?? 0)
                    self?.lastImageCellIndex += 1
                }
            },
            onError: { [weak self] error in
                self?.loadInProgress.accept(false)
                self?.cells.accept([.error(message: "Loading failed, check network connection")])
            }
        )
        .disposed(by: disposeBag)
    }
    
    
    // MARK: - get more places
    func fetchMoreData(){
        getNearbyPlaces(offset: offset,
                        limit: limit,
                        location: (locationService.lastLocation.coordinate.latitude,
                                   locationService.lastLocation.coordinate.longitude))
    }
    
    // MARK: - get image of each place
    func getImage(of id:String, currentDate:String, index:Int){
        
        appServerClient
            .getPlaceImage(placeId: id, currentDate: currentDate)
            .subscribe(
                onNext: { [weak self] model in
                    guard model.response?.photos?.items?.count ?? 0 > 0 else {
                        self?.photoCell.accept(PhotoCellModel(url: ""))
                        return
                    }
                    
                    let item = model.response?.photos?.items?[0]
                    let prefix = item?.itemPrefix ?? ""
                    let size = "\(item?.width ?? 0)x\(item?.height ?? 0)"
                    let suffix = item?.suffix ?? ""
                    let imageUrl = prefix + size + suffix
                    
                    self?.photoCell.accept(PhotoCellModel(url:  imageUrl,index: index))
                }, onError: { [weak self] error in
                    self?.photoCell.accept(PhotoCellModel(url: "",index: index))
                }
            )
            .disposed(by: disposeBag)
    }
}


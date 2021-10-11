//
//  NearbyPlacesViewModel.swift
//  NearBy
//
//  Created by Khaled Elshamy on 05/10/2021.
//
import RxSwift
import RxCocoa

enum PlacesTableViewCellType: Equatable {
    
    case normal(cellViewModel: PlacesCellModel)
    case error(message: String)
    case empty
    
    static func == (lhs: PlacesTableViewCellType, rhs: PlacesTableViewCellType) -> Bool {
        switch (lhs,rhs){
        case (.normal(let firstModel),.normal(let secondModel)):
            return firstModel == secondModel
        default: return false
        }
    }
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
    
        
    private let loadInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay<[PlacesTableViewCellType]>(value: [])
    private let locationService = LocationService.shared
    private let disposeBag = DisposeBag()
    private let appServerClient: ApiClient
    
    private var offset:Int = 0
    private var limit:Int = 10
    private var maxPageValue: Int = 50
    private var lastImageCellIndex: Int = 0
    private var isFirstLoading:Bool = true
    private var places: [PlacesTableViewCellType] = []
    
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
        
        loadInProgress.accept(isFirstLoading ? true : false)
        
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
                    self?.places = model.compactMap()
                    self?.cells.accept(self?.places ?? [])
                }else {
                    self?.places += model.compactMap()
                    self?.cells.accept(self?.places ?? [])
                }
                
                self?.offset +=  (self?.cells.value.count ?? 0)
                
                let items = model.response?.groups?[0].items ?? []
                items.forEach { [weak self] in
                    self?.getImage(venue: $0.venue, currentDate: DateManager.getCurrentDate())
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
        isFirstLoading = false
        getNearbyPlaces(offset: offset,
                        limit: limit,
                        location: (locationService.lastLocation.coordinate.latitude,
                                   locationService.lastLocation.coordinate.longitude))
    }
    
    // MARK: - get image of each place
    func getImage(venue:Venue?, currentDate:String){
       
        appServerClient
            .getPlaceImage(placeId: venue?.id ?? "",
                           currentDate: currentDate)
            .subscribe(
                onNext: { [weak self] model in
                    guard model.response?.photos?.items?.count ?? 0 > 0 else {
                        return
                    }
                    
                    let item = model.response?.photos?.items?[0]
                    let prefix = item?.itemPrefix ?? ""
                    let size = "\(item?.width ?? 0)x\(item?.height ?? 0)"
                    let suffix = item?.suffix ?? ""
                    let imageUrl = prefix + size + suffix
                    
                    var placeModel =  PlacesCellModel(name: venue?.name,
                                                      id: venue?.id,
                                                      address: venue?.location?.address,
                                                      imageUrl: nil)
                    let cellType:PlacesTableViewCellType = .normal(cellViewModel: placeModel)
                    
                    let placeIndex = self?.places.enumerated().filter { $0.element == cellType}.map({ $0.offset }).first ?? 0
                    placeModel.imageUrl = imageUrl
                    self?.places[placeIndex] = .normal(cellViewModel: placeModel)
                    self?.cells.accept(self?.places ?? [])
                }
            )
            .disposed(by: disposeBag)
    }
}


//
//  NearByViewModelTest.swift
//  NearByTests
//
//  Created by Khaled Elshamy on 07/10/2021.
//

import XCTest
import RxSwift
import RxCocoa
import Alamofire
@testable import NearBy

class NearByViewModelTest: XCTestCase {
   
    func test_EmptyPlacesCell() {

        apiClientService.getPlacesResult = .success(payload: VenuesModel(meta: nil, response: nil))
        
        let sut = makeSut(apiClient: apiClientService)
        sut.getNearbyPlaces(offset: 0, limit: 10, location: (lat:40.7,long:-74))
        
        sut.placesCells
            .subscribe(
                onNext: {
                    
                    var firstCellIsEmpty = false
                    if case.some(.empty) = $0.first {
                        firstCellIsEmpty = true
                    }
                    
                    XCTAssertTrue(firstCellIsEmpty)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func test_normalPlacesCell() {
        
        let model = VenuesModel(meta: nil, response: Response(suggestedFilters: nil, headerLocation: nil, headerFullLocation: nil, headerLocationGranularity: nil, totalResults: nil, suggestedBounds: nil, groups: [Group(type: nil, name: nil, items: [GroupItem(reasons: nil, venue: Venue.with(), referralID: nil)])]))
        apiClientService.getPlacesResult = .success(payload: model)
        
        let sut = makeSut(apiClient: apiClientService)
        sut.getNearbyPlaces(offset: 0, limit: 10, location: (lat:40.7,long:-74))
        
        sut.placesCells
            .subscribe(
                onNext: {
                    
                    var firstCellIsNormal = false
                    if case.some(.normal(_)) = $0.first {
                        firstCellIsNormal = true
                    }
                    
                    XCTAssertTrue(firstCellIsNormal)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func test_errorPlacesCell() {
        
        apiClientService.getPlacesResult = .failure(GetFailureReason.notFound)
        
        let sut = makeSut(apiClient: apiClientService)
        sut.getNearbyPlaces(offset: 0, limit: 10, location: (lat:40.7,long:-74))
        
        sut.placesCells
            .subscribe(
                onNext: {
                    
                    var firstCellIsError = false
                    if case.some(.error(_)) = $0.first {
                        firstCellIsError = true
                    }
                    
                    XCTAssertTrue(firstCellIsError)
                }
            )
            .disposed(by: disposeBag)
    }
    
    
    // MARK:- helpers
    private let disposeBag = DisposeBag()
    private let apiClientService = MockAppServerClient()
    private func makeSut(apiClient: MockAppServerClient = MockAppServerClient()) -> NearByViewModel {
        let sut = NearByViewModel(apiClient: apiClient)
        return sut
    }
}


// MARK: - Mock App Service

private final class MockAppServerClient: ApiClient {
    
    var getPlacesResult: Result<VenuesModel,GetFailureReason>?
    var getPhotoResult: Result<PhotoServiceModel,GetFailureReason>?
    
    override func getNearbyPlaces(lat: Double,
                                  long: Double,
                                  radius: Double,
                                  currentDate: String,
                                  offset:Int,
                                  limit:Int) -> Observable<VenuesModel> {
        return Observable.create { [weak self] observer in
            switch self?.getPlacesResult {
            case .success(let data):
                observer.onNext(data)
            case .failure(let error):
                observer.onError(error!)
            case .none:
                observer.onError(GetFailureReason.notFound)
            }
            return Disposables.create()
        }
    }
    
    override func getPlaceImage(placeId: String, currentDate: String) -> Observable<PhotoServiceModel> {
        return Observable.create { [weak self] observer in
            switch self?.getPhotoResult {
            case .success(let data):
                observer.onNext(data)
            case .failure(let error):
                observer.onError(error!)
            case .none:
                observer.onError(GetFailureReason.notFound)
            }
            return Disposables.create()
        }
    }
}

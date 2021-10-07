//
//  NearByPlacesViewControllerTest.swift
//  NearByTests
//
//  Created by Khaled Elshamy on 07/10/2021.
//

import XCTest
import RxSwift
import RxCocoa
@testable import NearBy

class NearByPlacesViewControllerTest: XCTestCase {
    
    func test_navigationBar_title(){
        XCTAssertEqual(makeSut(rendersViewDidLoad:true).navigationItem.title,"Near By")
    }
    
    func test_rendersTableView_withEmptyData(){
        XCTAssertEqual(makeSut(rendersViewDidLoad: false).tableView.numberOfRows(inSection:0),0)
    }
    
    func test_state_of_navigationItemButton() {
        makeSut(rendersViewDidLoad: true).addTapped()
        XCTAssertEqual(makeSut(rendersViewDidLoad:true).navigationItem.rightBarButtonItem?.title, userDefault.bool(forKey: "singleUpdate") ? "Single Update" : "Realtime")
    }
    
    // MARK: - Helpers
    private let userDefault = UserDefaults()
    private let disposeBag = DisposeBag()
    
    private func makeSut(rendersViewDidLoad: Bool) -> NearByPlacesViewController {
        let sut = NearByPlacesViewController()
        if(rendersViewDidLoad){sut.loadViewIfNeeded()}
        return sut
    }
}

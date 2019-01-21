//
//  HomeViewControllerTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 1/20/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class HomeViewControllerTests: XCTestCase {

    var sut: HomeViewController!

    override func setUp() {
        guard let homeVC = UIStoryboard(name: "Home", bundle: nil)
            .instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
                XCTFail()
                return
        }
        
        sut = homeVC
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
    }

    func test_HomeVC_HandlesTableView() {

        guard let safeSut = sut, let tableView = sut?.resultsTableView else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(safeSut, tableView.dataSource as? HomeViewController)
        XCTAssertEqual(safeSut, tableView.prefetchDataSource as? HomeViewController)
        XCTAssertEqual(safeSut, tableView.delegate as? HomeViewController)
    }

    func test_HomeVC_IsDataSourceDelegate() {
        
        XCTAssertEqual(sut, sut.dataController.delegate as? HomeViewController)
    }

    func test_SearchField_IsNotNil() {

        XCTAssertNotNil(sut.searchTextField)
    }

    func test_TableView_IsNotNil() {

        XCTAssertNotNil(sut.resultsTableView)
    }
    
    func test_TableView_NumberOfRows_Case1() {
    
        let mockDataController = MockSearchController(with: MockSearchRouter())
        mockDataController.test_TotalItems = 9
        mockDataController.test_PageSize = 3
        
        sut.dataController = mockDataController
        
        XCTAssertEqual(sut.resultsTableView?.numberOfSections, 3)
    }
    
    func test_TableView_NumberOfRows_Case2() {
        
        let mockDataController = MockSearchController(with: MockSearchRouter())
        mockDataController.test_TotalItems = 10
        mockDataController.test_PageSize = 3
        
        sut.dataController = mockDataController
        
        XCTAssertEqual(sut.resultsTableView?.numberOfSections, 4)
    }
    
    func test_TableView_NumberOfSectionsInRow() {
        let mockDataController = MockSearchController(with: MockSearchRouter())
        mockDataController.test_TotalItems = 10
        mockDataController.test_PageSize = 3
        
        sut.dataController = mockDataController
        
        XCTAssertEqual(sut.resultsTableView?.numberOfRows(inSection: 0), 3)
    }
}

class MockSearchController: SearchController {
    var test_TotalItems = 0
    override var totalItems: Int {
        get {
            return test_TotalItems
        }
    }
    
    var test_PageSize = 0
    override var pageSize: Int {
        get {
            return test_PageSize
        }
    }
}

fileprivate class MockSearchRouter: Router {
    let successResponse = HTTPURLResponse(url: URL(fileURLWithPath: ""), statusCode: 200, httpVersion: nil, headerFields: nil)
    
    var requestedPage = 1
    
    func request(_ route: EndPoint, completion: @escaping RouterCompletion) {
        
        let data = SearchOverflowTests.loadJSON(named: "SearchResponse p\(requestedPage)")
        completion(data, successResponse, nil)
    }
    
    func cancel() { }
}

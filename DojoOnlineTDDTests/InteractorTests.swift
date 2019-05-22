//
//  InteractorTests.swift
//  InteractorTests
//
//  Created by Henrique Morbin on 22/05/19.
//  Copyright © 2019 iFood. All rights reserved.
//

import XCTest
@testable import DojoOnlineTDD

final class InteractorTests: XCTestCase {

    func testPresentTitle() {
        let presenter: PresenterSpy = PresenterSpy()
        let interactor: Interactor = Interactor()
        interactor.presenter = presenter
        interactor.fetchTitle()
        XCTAssertEqual(presenter.presentTitleCalled, true)
        XCTAssertEqual(presenter.titlePassed, "Buscando")
    }

    func testFetchRestaurants() {
        let worker = WorkerSpy()
        worker.completionToBeReturned = []
        let interactor: Interactor = Interactor()
        interactor.worker = worker
        interactor.fetchRestaurants()
        XCTAssertEqual(worker.fetchRestaurantsCalled, true)
    }

    func testPresentRestaurant() {
        let presenter: PresenterSpy = PresenterSpy()
        let worker = WorkerSpy()
        worker.completionToBeReturned = ["Restaurante A"]
        let interactor: Interactor = Interactor()
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.fetchRestaurants()

        XCTAssertEqual(presenter.presentRestaurantsCalled, true)
        XCTAssertEqual(presenter.restaurantsPassed?.first, "Restaurante A")
        XCTAssertEqual(presenter.presentTitleCalled, true)
        XCTAssertEqual(presenter.titlePassed, "1 Restaurante")
    }
    
    func testPresentRestaurants() {
        let presenter: PresenterSpy = PresenterSpy()
        let worker = WorkerSpy()
        worker.completionToBeReturned = ["Restaurante A", "Restaurante B"]
        let interactor: Interactor = Interactor()
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.fetchRestaurants()

        XCTAssertEqual(presenter.presentRestaurantsCalled, true)
        XCTAssertEqual(presenter.restaurantsPassed?.count, 2)
        XCTAssertEqual(presenter.presentTitleCalled, true)
        XCTAssertEqual(presenter.titlePassed, "2 Restaurantes")
    }
}

// MARK: - WorkerProtocol

private class WorkerSpy: WorkerProtocol {
    var fetchRestaurantsCalled: Bool?
    var completionToBeReturned: [String]?

    func fetchRestaurants(completion: @escaping ([String]) -> Void) {
        fetchRestaurantsCalled = true
        completion(completionToBeReturned!)
    }
}

// MARK: - PresenterProtocol

private class PresenterSpy: PresenterProtocol {
    var presentTitleCalled: Bool?
    var titlePassed: String?
    var presentRestaurantsCalled: Bool?
    var restaurantsPassed: [String]?
    func presentTitle(title: String) {
        presentTitleCalled = true
        titlePassed = title
    }

    func presentRestaurants(restaurants: [String]) {
        presentRestaurantsCalled = true
        restaurantsPassed = restaurants
    }

}

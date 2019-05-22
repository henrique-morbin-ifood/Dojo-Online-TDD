//
//  DojoOnlineTDDTests.swift
//  DojoOnlineTDDTests
//
//  Created by Henrique Morbin on 22/05/19.
//  Copyright © 2019 iFood. All rights reserved.
//

import XCTest
@testable import DojoOnlineTDD

class DojoOnlineTDDTests: XCTestCase {



    func testExample() {
        let presenter = PresenterSpy()
        let worker = WorkerSpy()
        let sut = Interactor(presenter: presenter, worker: worker)
        sut.fetchTitle()
        XCTAssertEqual(presenter.presentTitleCalled, true)
        XCTAssertEqual(presenter.titlePassed, "Buscando")
    }

    func testFetchRestaurants() {
        let presenter = PresenterSpy()
        let worker = WorkerSpy()
        let sut = Interactor(presenter: presenter, worker: worker)
        sut.fetchRestaurants()
        XCTAssertEqual(worker.fetchRestaurantsCalled, true)
    }

    func testPresentRestaurant() {
        let presenter = PresenterSpy()
        let worker = WorkerSpy()
        worker.completionToBeReturned = ["Restaurante A"]
        let sut = Interactor(presenter: presenter, worker: worker)
        sut.fetchRestaurants()
        XCTAssertEqual(presenter.presentRestaurantsCalled, true)
        XCTAssertEqual(presenter.restaurantsPassed?.first, "Restaurante A")
        XCTAssertEqual(presenter.presentTitleCalled, true)
        XCTAssertEqual(presenter.titlePassed, "1 Restaurante")
    }

    func testPresentRestaurants() {
        let presenter = PresenterSpy()
        let worker = WorkerSpy()
        worker.completionToBeReturned = ["Restaurante A", "Restaurante B"]
        let sut = Interactor(presenter: presenter, worker: worker)
        sut.fetchRestaurants()
        XCTAssertEqual(presenter.presentRestaurantsCalled, true)
        XCTAssertEqual(presenter.restaurantsPassed?.count, 2)
        XCTAssertEqual(presenter.presentTitleCalled, true)
        XCTAssertEqual(presenter.titlePassed, "2 Restaurantes")
    }


}

final class Interactor {
    let presenter: PresenterProtocol
    let worker: WorkerProtocol

    init(presenter: PresenterProtocol, worker: WorkerProtocol) {
        self.presenter = presenter
        self.worker = worker
    }
    func fetchTitle() {
        presenter.presentTitle("Buscando")
    }

    func fetchRestaurants() {
        worker.fetchRestaurants { (restaurants) in
            self.presenter.presentRestaurants(restaurants)
            if restaurants.count > 1 {
                self.presenter.presentTitle("\(restaurants.count) Restaurantes")
            } else {
                self.presenter.presentTitle("1 Restaurante")
            }
        }
    }
}

protocol WorkerProtocol {
    func fetchRestaurants(completion: @escaping  ([String]) -> Void)
}

final class WorkerSpy: WorkerProtocol {
    var fetchRestaurantsCalled: Bool?
    var completionToBeReturned: [String]?

    func fetchRestaurants(completion: @escaping ([String]) -> Void) {
        fetchRestaurantsCalled = true

        if let completionToBeReturned = completionToBeReturned {
            completion(completionToBeReturned)
        }
    }
}

protocol PresenterProtocol {
    func presentTitle(_ title: String)
    func presentRestaurants(_ restaurants:  [String])
}

final class PresenterSpy: PresenterProtocol {
    var presentTitleCalled: Bool?
    var titlePassed: String = ""
    var presentRestaurantsCalled: Bool?
    var restaurantsPassed: [String]?

    func presentTitle(_ title: String) {
        titlePassed = title
        presentTitleCalled = true
    }

    func presentRestaurants(_ restaurants:  [String]) {
        presentRestaurantsCalled = true
        restaurantsPassed = restaurants
    }
}

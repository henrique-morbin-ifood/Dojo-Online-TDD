//
//  DojoOnlineTDDTests.swift
//  DojoOnlineTDDTests
//
//  Created by Henrique Morbin on 22/05/19.
//  Copyright © 2019 iFood. All rights reserved.
//

import XCTest
@testable import DojoOnlineTDD

final class InteractorTests: XCTestCase {

    func testPresentTitle() {
        let presenter = PresenterSpy()
        let worker = WorkerSpy()
        let interactor = Interactor(presenter: presenter, worker: worker)
        interactor.fetchTitle()
        XCTAssertEqual(presenter.presentTitleCalled, true)

        XCTAssertEqual(presenter.titlePassed, "Buscando")
    }

    func testFetchRestaurant() {
        let presenter = PresenterSpy()
        let worker = WorkerSpy()
        let interactor = Interactor(presenter: presenter, worker: worker)
        interactor.fetchRestaurant()
        XCTAssertEqual(worker.fetchRestaurantCalled, true)
    }

    func testPresenterRestaurant() {
        let presenter = PresenterSpy()
        let worker = WorkerSpy()
        worker.completionToBeReturned = ["restaurantA"]
        let interactor = Interactor(presenter: presenter, worker: worker)
        interactor.fetchRestaurant()

        XCTAssertEqual(presenter.presentRestaurantsCalled, true)
        XCTAssertEqual(presenter.restaurantsPassed?.first, "restaurantA")

        XCTAssertEqual(presenter.presentTitleCalled, true)
        XCTAssertEqual(presenter.titlePassed, "1 Restaurant")
    }

    func testPresenterRestaurants() {
        let presenter = PresenterSpy()
        let worker = WorkerSpy()
        worker.completionToBeReturned = ["restaurantA", "restaurantB"]
        let interactor = Interactor(presenter: presenter, worker: worker)
        interactor.fetchRestaurant()

        XCTAssertEqual(presenter.presentRestaurantsCalled, true)
        XCTAssertEqual(presenter.restaurantsPassed?.count, 2)

        XCTAssertEqual(presenter.presentTitleCalled, true)
        XCTAssertEqual(presenter.titlePassed, "2 Restaurants")
    }



}

private class Interactor {

    let presenter: PresenterProtocol
    let worker: WorkerProtocol

    init (presenter: PresenterProtocol, worker: WorkerProtocol) {
        self.presenter = presenter
        self.worker = worker
    }

    func fetchTitle() {
        presenter.presentTitle(title: "Buscando")
    }

    func fetchRestaurant() {
        worker.fetchRestaurant { (restaurantes) in
            self.presenter.presentRestaurants(restaurants: restaurantes)
            var restaurantString = "Restaurant"
            if restaurantes.count > 1 {
                restaurantString = restaurantString + "s"
            }
            self.presenter.presentTitle(title: "\(restaurantes.count) \(restaurantString)")
        }
    }

}
protocol WorkerProtocol: class {
    func fetchRestaurant(completion: @escaping ([String]) -> Void)
}

protocol PresenterProtocol: class {
    func presentRestaurants(restaurants: [String])
    func presentTitle(title: String)
}

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

private class WorkerSpy: WorkerProtocol {
    func fetchRestaurant(completion: @escaping ([String]) -> Void) {
        fetchRestaurantCalled = true
        if let completionToBeReturned = completionToBeReturned {
            completion(completionToBeReturned)
        }
    }

    var fetchRestaurantCalled: Bool?
    var completionToBeReturned: [String]?
}

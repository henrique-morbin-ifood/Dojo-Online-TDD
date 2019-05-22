//
//  Interactor.swift
//  DojoOnlineTDD
//
//  Created by Henrique Morbin on 22/05/19.
//  Copyright © 2019 iFood. All rights reserved.
//

import Foundation

protocol InteractorProtocol {
    func fetchTitle()
}

final class Interactor: InteractorProtocol {
    var presenter: PresenterProtocol?
    var worker: WorkerProtocol?

    func fetchTitle() {
        presenter?.presentTitle(title: "Buscando")
    }

    func fetchRestaurants() {
        worker?.fetchRestaurants(completion: { [weak self](restaurants) in
            self?.presenter?.presentRestaurants(restaurants: restaurants)
            self?.presenter?.presentTitle(title: "\(restaurants.count) Restaurante\(restaurants.count > 1 ? "s" : "")")
        })
    }
}

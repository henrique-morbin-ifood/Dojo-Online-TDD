//
//  Presenter.swift
//  DojoOnlineTDD
//
//  Created by Henrique Morbin on 22/05/19.
//  Copyright © 2019 iFood. All rights reserved.
//

import Foundation

protocol PresenterProtocol {
    func presentTitle(title: String)
    func presentRestaurants(restaurants: [String])
}

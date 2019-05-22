//
//  Worker.swift
//  DojoOnlineTDD
//
//  Created by Henrique Morbin on 22/05/19.
//  Copyright © 2019 iFood. All rights reserved.
//

import Foundation

protocol WorkerProtocol {
    func fetchRestaurants(completion: @escaping ([String]) -> Void)
}


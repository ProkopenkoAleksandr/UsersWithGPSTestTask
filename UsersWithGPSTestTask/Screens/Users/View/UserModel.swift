//
//  UserModel.swift
//  e-legionTestTask
//
//  Created by Aleksandr Prokopenko on 10.03.2023.
//

import Foundation

struct UserModel: Codable {
    let id: Int
    let image: String
    let username: String
    var coordinates: Coordinates
}

struct Coordinates: Codable {
    var latitude: Double
    var longitude: Double
}

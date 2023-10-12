//
//  UserDataService.swift
//  e-legionTestTask
//
//  Created by Aleksandr Prokopenko on 10.03.2023.
//

import Foundation

class UserDataService {
    
    func requestUsers(completion: @escaping (([UserModel]) -> Void )) {
        var users = [UserModel]()
        
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        let workItem = DispatchWorkItem {
            // Real request to API
            users = [UserModel(id: 0, image: "0", username: "Anna", coordinates: Coordinates(latitude: 45.06490314562291, longitude: 38.91903713742359)),
                    UserModel(id: 1, image: "1", username: "Nikolay", coordinates: Coordinates(latitude: 55.678591153743895, longitude: 37.494960748579075)),
                    UserModel(id: 2, image: "2", username: "Elizabeth", coordinates: Coordinates(latitude: 59.89028601071954, longitude: 30.362317017508065)),
                    UserModel(id: 3, image: "3", username: "Anton", coordinates: Coordinates(latitude: 51.69372656861108, longitude: 39.214463849554754)),
                    UserModel(id: 4, image: "4", username: "Maria", coordinates: Coordinates(latitude: 47.2703336815528, longitude: 39.681818558585)),
                    UserModel(id: 5, image: "5", username: "Sergey", coordinates: Coordinates(latitude: 43.61579817296331, longitude: 39.740624800675995)),
                    UserModel(id: 6, image: "6", username: "Irina", coordinates: Coordinates(latitude: 54.72997893148067, longitude: 20.458044144525303)),
                    UserModel(id: 7, image: "7", username: "Oleg", coordinates: Coordinates(latitude: 57.153271288025316, longitude: 65.5271712132343)),
                    UserModel(id: 8, image: "8", username: "Daria", coordinates: Coordinates(latitude: 56.32671107990673, longitude: 43.87961804646366)),
                    UserModel(id: 9, image: "9", username: "Valerii", coordinates: Coordinates(latitude: 56.85314368135821, longitude: 60.59886340714936))]
        }
        
        utilityQueue.async(execute: workItem)
        
        workItem.notify(queue: DispatchQueue.main) {
            completion(users)
        }
    }
    
    func requestUsersLocations(users: [UserModel], completion: @escaping (([UserModel]) -> Void )) {
        var usersModels = users
        
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        let workItemm = DispatchWorkItem {
            // Real request to API
            for i in 0..<usersModels.count {
                usersModels[i].coordinates = self.randomUpdateLocation(userModel: usersModels[i], index: i)
            }
        }
        
        utilityQueue.async(execute: workItemm)

        workItemm.notify(queue: DispatchQueue.main) {
            completion(usersModels)
        }
        
    }
    
    func randomUpdateLocation(userModel: UserModel,
                              firstPlus: Bool = Bool.random(),
                              secondPlus: Bool = Bool.random(),
                              firstRandomValue: Double = Double.random(in: -0.01...0.01),
                              secondRandomValue: Double = Double.random(in: -0.01...0.01),
                              index: Int) -> Coordinates {
        var user = userModel
        let latitude = user.coordinates.latitude
        let longitude = user.coordinates.longitude
        
        if firstPlus {
            if (latitude + firstRandomValue) <= 90 && (latitude + firstRandomValue) <= -90 {
                user.coordinates.latitude += firstRandomValue
            } else if (latitude + firstRandomValue) >= 90 || (latitude + firstRandomValue) >= -90 {
                user.coordinates.latitude -= firstRandomValue
            }
        } else {
            if (latitude - firstRandomValue) <= 90 && (latitude - firstRandomValue) <= -90 {
                user.coordinates.latitude -= firstRandomValue
            } else if (latitude + firstRandomValue) >= 90 || (latitude + firstRandomValue) >= -90 {
                user.coordinates.latitude += firstRandomValue
            }
        }
        
        if secondPlus {
            if (longitude + secondRandomValue) <= 180 && (longitude + secondRandomValue) <= -180 {
                user.coordinates.longitude += secondRandomValue
            } else if (longitude + secondRandomValue) >= 180 || (longitude + secondRandomValue) >= -180 {
                user.coordinates.longitude -= secondRandomValue
            }
        } else {
            if (longitude - secondRandomValue) <= 180 && (longitude - secondRandomValue) <= -180 {
                user.coordinates.longitude -= secondRandomValue
            } else if (longitude + secondRandomValue) >= 180 || (longitude + secondRandomValue) >= -180 {
                user.coordinates.longitude += secondRandomValue
            }
        }
        return user.coordinates
        
    }
    
}

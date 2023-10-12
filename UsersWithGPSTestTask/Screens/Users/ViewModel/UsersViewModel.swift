//
//  UsersViewModel.swift
//  e-legionTestTask
//
//  Created by Aleksandr Prokopenko on 10.03.2023.
//

import Foundation
import CoreLocation

protocol UserViewModelDelegate: AnyObject {
    func example()
}

class UsersViewModel: NSObject {
    
    private var delegate: UserViewModelDelegate!
    
    private var locationService = CLLocationManager()
    private var userCoordinates = CLLocation()
    private var userDataService = UserDataService()
    private var timer: Timer?
    
    private var usersViewViewModels = [UserViewViewModel]()
    private var usersModels = [UserModel]()
    
    private var userIsPinned: Bool = false
    private var pinnedUserViewViewModel: UserViewViewModel?
    private var pinnedUserModel: UserModel?
    
    private var helperUsersViewViewModels = [UserViewViewModel]()
    private var helperUsersModels = [UserModel]()
        
    var updatePinnedUser: ((UserViewViewModel?) -> Void)?
    
    var updatingViewIsHidden: ((Bool) -> Void)?
    
    var errorIsHidden: ((Bool) -> Void)?
    
    var applySnapshot: (([UserViewViewModel]) -> Void)?
    
    init(delegate: UserViewModelDelegate) {
        self.delegate = delegate
    }
    
    func example() {
        delegate?.example()
    }
    
    func getCurrentLocation() {
        locationService.delegate = self
        if (locationService.authorizationStatus == .authorizedWhenInUse || locationService.authorizationStatus == .authorizedAlways) {
            errorIsHidden?(true)
            updatingViewIsHidden?(false)
            locationService.requestLocation()
        } else {
            if UserDefaults.standard.bool(forKey: "firstOpenUsersVC") == false {
                UserDefaults.standard.set(true, forKey: "firstOpenUsersVC")
                locationService.requestAlwaysAuthorization()
            } else {
                errorIsHidden?(false)
            }
        }
    }
    
    private func requestUsers() {
        usersViewViewModels = []
        userDataService.requestUsers { [weak self] usersModels in
            self?.updatingViewIsHidden?(true)
            self?.usersModels = usersModels
            self?.createUserViewViewModels(users: usersModels)
            self?.updateSnapshot()
        }
    }
    
    private func requestUsersLocations() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            self.usersViewViewModels = []
            self.userDataService.requestUsersLocations(users: self.usersModels) { [weak self] usersModels in
                self?.usersModels = usersModels
                self?.createUserViewViewModels(users: usersModels)
                if self?.userIsPinned == true {
                    self?.updateUsersVVMRelativeToPinned(users: usersModels)
                    self?.updatePinnedUser?(self?.pinnedUserViewViewModel)
                }
                self?.updateSnapshot()
                
                self?.requestUsersLocations()
            }
        }
    }
    
    func stoprequestUsersLocations() {
        timer?.invalidate()
    }
        
    func getUserAndPin(index: Int) -> UserViewViewModel? {
        if userIsPinned == true {
            pinnedUserViewViewModel = helperUsersViewViewModels[index]
            pinnedUserModel = helperUsersModels[index]
        } else {
            pinnedUserViewViewModel = usersViewViewModels[index]
            pinnedUserModel = usersModels[index]
        }
        userIsPinned = true
        
        updateUsersVVMRelativeToPinned(users: usersModels)
        
        return pinnedUserViewViewModel
    }
    
    func updateSnapshot() {
        if userIsPinned == true {
            applySnapshot?(helperUsersViewViewModels)
        } else {
            applySnapshot?(usersViewViewModels)
        }
    }
    
    private func updateUsersVVMRelativeToPinned(users: [UserModel]) {
        helperUsersViewViewModels = []
        helperUsersModels = users.filter {$0.id != pinnedUserModel?.id}
        guard let pinnedUser = (users.first { $0.id == pinnedUserModel?.id }) else { return }
        pinnedUserModel = pinnedUser
        
        let pinnedUserLocation = CLLocation(latitude: pinnedUser.coordinates.latitude, longitude: pinnedUser.coordinates.longitude)
        let distance = calculateDistance(from: userCoordinates, to: pinnedUserLocation)
        pinnedUserViewViewModel?.distance = distance
        
        for user in helperUsersModels {
            let location = CLLocation(latitude: user.coordinates.latitude, longitude: user.coordinates.longitude)
            let distance = calculateDistance(from: pinnedUserLocation, to: location)
            let userViewViewModel = UserViewViewModel(image: user.image, name: user.username, distance: distance)
            helperUsersViewViewModels.append(userViewViewModel)
        }
    }
    
    func deletePinnedUser() {
        userIsPinned = false
        pinnedUserModel = nil
        pinnedUserViewViewModel = nil
    }
    
    func numberOfRows() -> Int {
        if userIsPinned {
            return helperUsersViewViewModels.count
        } else {
            return usersViewViewModels.count
        }
    }
    
    func createUserViewViewModels(users: [UserModel]) {
        usersViewViewModels = []
        for user in users {
            let location = CLLocation(latitude: user.coordinates.latitude, longitude: user.coordinates.longitude)
            let distance = calculateDistance(from: userCoordinates, to: location)
            let userViewViewModel = UserViewViewModel(image: user.image, name: user.username, distance: "\(distance)")
            usersViewViewModels.append(userViewViewModel)
        }
    }
    
    func getUserViewViewModel(index: Int) -> UserViewViewModel {
        if userIsPinned {
            return helperUsersViewViewModels[index]
        } else {
            return usersViewViewModels[index]
        }
    }
    
    private func calculateDistance(from: CLLocation, to: CLLocation) -> String {
        let distanceMetres = from.distance(from: to)
        let distanceKm = distanceMetres / 1000
        let roundedDistanceKm = (distanceKm * 100).rounded() / 100
        return "\(roundedDistanceKm) kilometres"
    }
    
}

extension UsersViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        userCoordinates = location
        requestUsers()
        requestUsersLocations()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Location manager authorization status change")
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("User allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            print("User allow app to get location data only when app is active")
        case .denied:
            errorIsHidden?(false)
            print("User tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            errorIsHidden?(false)
            print("Parental control setting disallow location data")
        case .notDetermined:
            errorIsHidden?(false)
            print("The location permission dialog haven't shown before, user haven't tap allow/disallow")
        @unknown default:
            fatalError("Unknow error")
        }
        getCurrentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error request location: \(error.localizedDescription)")
    }
}

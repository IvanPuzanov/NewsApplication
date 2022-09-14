//
//  ProfileViewModel.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 06.09.2022.
//

import UIKit
import RxSwift

class ProfileViewModel {
    
    var profileImage    = UIImage(named: "myMemoji")
    var profileName     = "Ivan Puzanov"
    var profileJob      = "iOS Developer"
    var profileLocation = "Saint-Petersburg, Russia"
    
    var profileInfo: BehaviorSubject<[ProfileInfoModel]> = .init(value: [ProfileInfoModel(title: "About me", message: "I love bringing apps from concept to completion. I believe a natural, intuitive interface supporting the right idea can improve the way people interact with the world."), ProfileInfoModel(title: "Stack", message: "Swift\r\nUIKit\r\nAutolayout\r\nJSON\r\nNetworking\r\nMVC, MVVM–C\r\nRxSwift/RxCocoa")])
    
}

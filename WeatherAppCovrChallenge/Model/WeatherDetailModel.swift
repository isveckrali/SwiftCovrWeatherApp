//
//  WeatherDetailModel.swift
//  WeatherAppCovrChallenge
//
//  Created by Mehmet Can Seyhan on 2019-07-09.
//  Copyright © 2019 Mehmet Can Seyhan. All rights reserved.
//

import Foundation
import UIKit

struct WeatherDetailModel: Codable {
    var coord:Coord?
    var weather:[Weather]?
    var base:String?
    var main:Main?
    var visibility:Int?
    var wind:Wind?
    var clouds:Clouds?
    var dt:Int?
    var sys:Sys?
    var id:Int?
    var name:String?
    var cod:Int?
}

struct Weather:Codable {
    var id:Int?
    var main:String?
    var description:String?
    var icon:String?
    
   
}

struct Main:Codable {
    var temp:Double?
    var pressure:Int?
    var humidity:Int?
    var temp_min:Double?
    var temp_max:Double
}

struct Wind:Codable {
    var speed:Double?
    var deg:Int?
}

struct Clouds:Codable {
    var all:Int?
    
}

struct Sys:Codable {
    var type:Int?
    var id:Int?
    var message:Double?
    var country:String?
    var sunrise:Int
    var sunset:Int?
}

extension Weather {
    var iconImage: UIImage? {
        switch icon {
        case "01n":
            return UIImage(named: "clear-day")!
        case "01d":
            return UIImage(named: "clear-night")!
        case "09d":
            return UIImage(named: "rain")!
        case "13n":
            return UIImage(named: "snow")!
        case "10d":
            return UIImage(named: "sleet")!
        case "50d":
            return UIImage(named: "wind")!
        case "10n":
            return UIImage(named: "fog")!
        case "04d":
            return UIImage(named: "cloudy")!
        case "03n":
            return UIImage(named: "partly-cloudy")!
        case "04n":
            return UIImage(named: "cloudy-night")!
        default:
            return UIImage(named: "default")!
        }
    }
}

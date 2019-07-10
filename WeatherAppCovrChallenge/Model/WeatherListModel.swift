//
//  WeatherListModel.swift
//  WeatherAppCovrChallenge
//
//  Created by Mehmet Can Seyhan on 2019-07-09.
//  Copyright © 2019 Mehmet Can Seyhan. All rights reserved.
//

import Foundation
struct WeatherListModel: Codable {
    var id:Int?
    var name:String?
    var country:String?
    var coord:Coord?
}

struct Coord:Codable {
    var lon: Double?
    var lat:Double?
}

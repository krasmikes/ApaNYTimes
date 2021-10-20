//
//  Constans.swift
//  ApaNYTimes
//
//  Created by Apanasenko Mikhail on 18.10.2021.
//

import Foundation

struct Constans {
    static private let apiBasicUrl: String = "https://api.nytimes.com/svc/topstories/v2/"
    static private let apiKeyPrefix: String = "?api-key="
    static private let apiKey: String = "H88p8Qh3WaR6fOqLewSZAyNkuQMD5ANB"
    static var artsUrl: String {
        apiBasicUrl + "arts.json" + apiKeyPrefix + apiKey
    }
    static var automobilesUrl: String {
        apiBasicUrl + "automobiles.json" + apiKeyPrefix + apiKey
    }
    static var businessUrl: String {
        apiBasicUrl + "business.json" + apiKeyPrefix + apiKey
    }
    static var homeUrl: String {
        apiBasicUrl + "home.json" + apiKeyPrefix + apiKey
    }
    static var politicsUrl: String {
        apiBasicUrl + "politics.json" + apiKeyPrefix + apiKey
    }
    static var scienceUrl: String {
        apiBasicUrl + "science.json" + apiKeyPrefix + apiKey
    }
    static var sportsUrl: String {
        apiBasicUrl + "sports.json" + apiKeyPrefix + apiKey
    }
    static var technologyUrl: String {
        apiBasicUrl + "technology.json" + apiKeyPrefix + apiKey
    }
    static var travelUrl: String {
        apiBasicUrl + "travel.json" + apiKeyPrefix + apiKey
    }
    static var worldUrl: String {
        apiBasicUrl + "world.json" + apiKeyPrefix + apiKey
    }
    
    static let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ApaNYTimesData.bin")
    
    
}

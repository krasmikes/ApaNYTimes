//
//  Constans.swift
//  ApaNYTimes
//
//  Created by Apanasenko Mikhail on 18.10.2021.
//

import Foundation

struct Urls {
    static private let apiBasicUrl: String = "https://api.nytimes.com/svc/topstories/v2/"
    static private let apiSection: String = "automobiles.json"
    static private let apiKeyPrefix: String = "?api-key="
    static private let apiKey: String = "H88p8Qh3WaR6fOqLewSZAyNkuQMD5ANB"
    static var arts: String {
        apiBasicUrl + "arts.json" + apiKeyPrefix + apiKey
    }
    static var automobiles: String {
        apiBasicUrl + "automobiles.json" + apiKeyPrefix + apiKey
    }
    static var business: String {
        apiBasicUrl + "business.json" + apiKeyPrefix + apiKey
    }
    static var home: String {
        apiBasicUrl + "home.json" + apiKeyPrefix + apiKey
    }
    static var politics: String {
        apiBasicUrl + "politics.json" + apiKeyPrefix + apiKey
    }
    static var science: String {
        apiBasicUrl + "science.json" + apiKeyPrefix + apiKey
    }
    static var sports: String {
        apiBasicUrl + "sports.json" + apiKeyPrefix + apiKey
    }
    static var technology: String {
        apiBasicUrl + "technology.json" + apiKeyPrefix + apiKey
    }
    static var travel: String {
        apiBasicUrl + "travel.json" + apiKeyPrefix + apiKey
    }
    static var world: String {
        apiBasicUrl + "world.json" + apiKeyPrefix + apiKey
    }
    
    
    static let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ApaNYTimesData.bin")
}

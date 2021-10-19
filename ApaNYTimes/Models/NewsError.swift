//
//  NewsError.swift
//  ApaNYTimes
//
//  Created by Apanasenko Mikhail on 19.10.2021.
//

import Foundation

enum NewsError: LocalizedError {
    case notValidURL(description: String)
    case notValidJSONRecieved(description: String)
    case notReadableFile(description: String)
    case notAbleToSave(description: String)
    
    var errorDescription: String? {
        switch self {
        case .notValidURL(let description), .notValidJSONRecieved(let description), .notReadableFile(let description), .notAbleToSave(let description):
            return description
        }
    }
}
 

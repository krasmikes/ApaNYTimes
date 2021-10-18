//
//  NewsData.swift
//  ApaNYTimes
//
//  Created by Apanasenko Mikhail on 11.10.2021.
//

import UIKit

struct NewsData: Codable {
    let status: String
    let copyright: String
    let section: String
    let last_updated: String
    let num_results: Int
    var results: [Article?]
}

struct Article: Codable {
    let section: String
    let title: String
    let abstract: String
    let url: String
    let byline: String
    let published_date: String
    var multimedia: [Multimedia?]
    var smallPicture: Data?
    var bigPicture: Data?
}

struct Multimedia: Codable {
    let url: String
    let format: String
    let height: Int
    let width: Int
    let caption: String?
    let copyright: String?
}

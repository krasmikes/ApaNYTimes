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
    let subsection: String?
    let title: String
    let abstract: String
    let url: String
    let uri: String
    let byline: String
    let item_type: String
    let updated_date: String
    let created_date: String
    let published_date: String
    let material_type_facet: String?
    let kicker: String?
    let des_facet: [String?]
    let org_facet: [String?]
    let per_facet: [String?]
    let geo_facet: [String?]
    var multimedia: [Multimedia?]
    let short_url: String
    var smallPicture: Data?
    var bigPicture: Data?
}

struct Multimedia: Codable {
    let url: String
    let format: String
    let height: Int
    let width: Int
    let type: String
    let subtype: String
    let caption: String?
    let copyright: String?
}

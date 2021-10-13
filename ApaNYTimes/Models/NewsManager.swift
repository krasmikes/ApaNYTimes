//
//  NewsManager.swift
//  ApaNYTimes
//
//  Created by Apanasenko Mikhail on 11.10.2021.
//

import Foundation
import UIKit

protocol NewsManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdateData(model: NewsModel)
}

struct NewsManager {
//    let sections = (
//        arts: (name: "Arts", json:  "arts.json"),
//        automobiles: (name: "Automobiles", json:  "automobiles.json"),
//        business: (name: "Business", json:  "business.json"),
//        home: (name: "Home Page", json:  "home.json"),
//        politics: (name: "Politics", json:  "politics.json"),
//        science: (name: "Science", json:  "science.json"),
//        sports: (name: "Sports", json:  "sports.json"),
//        technology: (name: "Technology", json:  "technology.json"),
//        travel: (name: "Travel", json:  "travel.json"),
//        world: (name: "World News", json:  "world.json")
//    )
    
    private let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ApaNYTimesData.bin")
  
    private let apiBasicUrl: String = "https://api.nytimes.com/svc/topstories/v2/"
    private let apiSection: String = "automobiles.json"
    private let apiKeyPrefix: String = "?api-key="
    private let apiKey: String = "H88p8Qh3WaR6fOqLewSZAyNkuQMD5ANB"
    private var apiUrl: String {
        apiBasicUrl + apiSection + apiKeyPrefix + apiKey
    }
    var delegate: NewsManagerDelegate?
    
    func fetchData () {
        if FileManager().fileExists(atPath: fileURL.path) {
            readData()
        } else {
            updateData()
        }
    }
    
    func updateData () {
        if let url = URL(string: apiUrl) {
            request(for: url) { data, _, error in
                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                if let safeData = data {
                    if let model = self.parseJSON(safeData) {
                        saveData(for: model)
                        delegate?.didUpdateData(model: model)
                    }
                }
            }
        }
    }
    
    private func readData () {
        do {
            let readData = try Data(contentsOf: fileURL)
            if let model = parseJSON(readData) {
                delegate?.didUpdateData(model: model)
            }
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    func saveData (for model: NewsModel) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(model.data)
            try data.write(to: fileURL, options: [.completeFileProtection])
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    func request (for url: URL, complitionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url, completionHandler: complitionHandler)
        task.resume()
    }
    
    private func parseJSON(_ data: Data) -> NewsModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NewsData.self, from: data)
            let model = NewsModel(data: decodedData)
            return model
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    func loadPicture (for article: Article, format: String, complitionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        for media in article.multimedia {
            if let media = media {
                if media.format == format {
                    if let url = URL(string: media.url) {
                        request(for: url, complitionHandler: complitionHandler)
                    }
                }
            }
        }
    }
    
    func savePicture (data: Data, format: String, article: Article, model: NewsModel, index: Int) {
        model.data.results[index] = article
    }
}

//
//  NewsManager.swift
//  ApaNYTimes
//
//  Created by Apanasenko Mikhail on 11.10.2021.
//

import Foundation
import UIKit

typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

protocol NewsManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdateData(model: NewsModel)
}

struct NewsManager {
  
    var delegate: NewsManagerDelegate?
    
    func updateData (_ url: String = Urls.automobiles, _ session: URLSession = URLSession(configuration: .default)) {
        if let url = URL(string: url) {
            request(for: url, session: session) { data, _, error in
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
    
    func readData (_ url: URL = Urls.file) {
        if FileManager().fileExists(atPath: url.path) {
            do {
                let readData = try Data(contentsOf: url)
                if let model = parseJSON(readData) {
                    delegate?.didUpdateData(model: model)
                }
            } catch {
                delegate?.didFailWithError(error: error)
            }
        } else {
            updateData()
        }
    }
    
    func saveData (for model: NewsModel, _ url: URL = Urls.file) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(model.data)
            try data.write(to: url, options: [.completeFileProtection])
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    private func request (for url: URL, session: URLSession,  complitionHandler: @escaping CompletionHandler) {
        let session = session
        let task = session.dataTask(with: url, completionHandler: complitionHandler)
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> NewsModel? {
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
    
    func loadPicture (for article: Article, format: String, _ session: URLSession = URLSession(configuration: .default), complitionHandler: @escaping CompletionHandler) {
        for media in article.multimedia {
            if let media = media {
                if media.format == format {
                    if let url = URL(string: media.url) {
                        request(for: url, session: session, complitionHandler: complitionHandler)
                    }
                }
            }
        }
    }
}

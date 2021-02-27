//
//  NetworkManager.swift
//  News
//
//  Created by Anton Levin on 26.02.2021.
//

import Foundation

class NetworkManager {
  
  static let shared = NetworkManager()
  private let baseURL = "https://newsapi.org/v2/everything"
  static var requestWord = "intel"
  //All articles mentioning Apple from yesterday, sorted by popular publishers first
  func getAppleArticles(completion: @escaping (Result<[Article], NError>) -> Void) {
    
    //Date today
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let today = dateFormatter.string(from: date)
    
    let parameters = [
      "q" : NetworkManager.requestWord,
      "from" : today,
      "to" : today,
      "language" : "ru",
      "sortBy" : "popularity",
      "pageSize" : "20",
      "apiKey" : "f4e57466866e4a5f84376e1194d8ab89"
    ]
    
    RESTful.request(path: baseURL, method: "GET", parameters: parameters, headers: nil) { result in
      
      switch result {
      case .success(let data):
        
        do{
          let decoder = JSONDecoder()
          
          //START - add date formatting to the decoder
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          dateFormatter.locale = Locale(identifier: "en_AU")
          decoder.dateDecodingStrategy = .formatted(dateFormatter)
          //END
          
          let news: NewsRoot = try decoder.decode(NewsRoot.self, from: data)
          completion(.success(news.articles))
          
        } catch let error {
          print(error)
          completion(.failure(.invalidJson))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

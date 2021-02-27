//
//  RESTful.swift
//  News
//
//  Created by Anton Levin on 26.02.2021.
//

import Foundation

// MARK: Error
enum NError: String, Error {
  case invalidUrl = "API URL is malformated"
  case unableToComplete = "Unable to complete your request. Please check your internet connection."
  case invalidData = "The data received from the server was invalid. Please try again."
  case invalidJson
}

// MARK: Networking
let RESTful = _RESTful()
final class _RESTful {
  func request(path: String, method: String, parameters: [String:String]?, headers: [String:String]?, completion: @escaping (Result<Data, NError>) -> Void) {
    
    guard var components = URLComponents(string: path) else {
      completion(.failure(.invalidUrl))
      return
    }
    
    // GET: Query string parameters
    if method == "GET", let parameters = parameters {
      components.queryItems = parameters.map({ (key, value) in
        URLQueryItem(name: key, value: value)
      })
    }
    
    var request = URLRequest(url: components.url!)
    
    // POST/PUT: Request body parameters
    if method == "POST" || method == "PUT" {
      if let parameters = parameters {
        do {
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
          completion(.failure(.invalidJson))
        }
      }
    }
    
    request.httpMethod = method
    
    //HEADERS
    if let headers = headers {
      for (key, value) in headers {
        request.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    //TASK
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print(error)
        completion(.failure(.unableToComplete))
      }
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(.failure(.invalidData))
        return
      }
      guard let data = data else {
        completion(.failure(.invalidData))
        return
      }
      completion(.success(data))
    }
    task.resume()
  }
}

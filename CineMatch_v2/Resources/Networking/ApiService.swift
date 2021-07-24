//
//  ApiService.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 22/7/21.
//

import Foundation

class ApiService {
    
    static let shared = ApiService()
    
    private var dataTask: URLSessionDataTask?
        
    func getMovieCards(page: Int, completion: @escaping (Result<MovieCards, Error>) -> Void) {
        
        let popularMoviesURL =
            "https://api.themoviedb.org/3/trending/movie/week?api_key=e520334db48c767166d997b28b432c50&page=\(page)"
        
        guard let url = URL(string: popularMoviesURL) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MovieCards.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
    
    func getMovieDetails(id: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        
        let popularMoviesURL = "https://api.themoviedb.org/3/movie/\(id)?api_key=4e0be2c22f7268edffde97481d49064a&language=en-US&append_to_response=credits,videos,watch/providers"
        
        guard let url = URL(string: popularMoviesURL) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MovieDetails.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
    
    
    
}

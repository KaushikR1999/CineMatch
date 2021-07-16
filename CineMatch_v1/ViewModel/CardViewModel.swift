//
//  CardViewModel.swift
//  CineMatch_v1
//
//  Created by Kaushik Kumar on 16/7/21.
//

import Foundation

class CardViewModel {
    
    static let shared = CardViewModel()
    
    private var apiService = ApiService()
    private var movieCardDetails = [MovieCard]()
    
    private var movieDetails: MovieDetails?
    
    func fetchMovieCards(page: Int, completion: @escaping([MovieCard]) -> ()) {
        
        // weak self - prevent retain cycles
        apiService.getMovieCards(page: page) { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.movieCardDetails = listOf.cards
                completion(self!.movieCardDetails)
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
        
    }
    
    func fetchMovieDetails(id: Int, completion: @escaping((MovieDetails) -> ())) {
        
        // weak self - prevent retain cycles
        apiService.getMovieDetails(id: id) { [weak self] (result) in
            
            switch result {
            case .success(let result):
                self?.movieDetails = result
                completion((self?.movieDetails)!)
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
        
    }


}

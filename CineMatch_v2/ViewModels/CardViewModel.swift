//
//  CardViewModel.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 23/7/21.
//

import Foundation

class CardViewModel {
    
    static let shared = CardViewModel()
    
    private var movieCardDetails = [MovieCard]()
    
    private var movieDetails: MovieDetails?
    
    func fetchMovieCards(page: Int, completion: @escaping([MovieCard]) -> ()) {
        
        // weak self - prevent retain cycles
        ApiService.shared.getMovieCards(page: page) { [weak self] (result) in
            
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
        ApiService.shared.getMovieDetails(id: id) { [weak self] (result) in
            
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

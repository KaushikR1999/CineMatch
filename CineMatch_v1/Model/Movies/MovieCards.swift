//
//  MovieCards.swift
//  CineMatch_v1
//
//  Created by Kaushik Kumar on 16/7/21.
//

import Foundation

struct MovieCards: Decodable {
    
    let cards: [MovieCard]
    
    private enum CodingKeys: String, CodingKey {
        case cards = "results"
    }
}

struct MovieCard: Decodable {
    
    let id: Int?
    
    let poster_path: String?
    
}

struct MovieDetails: Decodable {
    
    let id: Int?
    
    let poster_path: String?
    let backdrop_path: String?
    
    let title: String?
    let release_date: String?
    
    let genres: [Genre]
    
    let tagline: String?
    let overview: String?
    
    let budget: Int?
    let revenue: Int?
    let runtime: Int?
        
    let vote_average: Double?
    
    let videos: [String: [Video]]
    
    let credits: [String: [Credit]]
    
    

}

struct Credit: Decodable {
    let name: String?
    
    let known_for_department: String?
    
    let order: Int?
    
    let job: String?
}

struct Video: Decodable {
    
    let id: String?

    let key: String?
    
    let type: String?
   
}


struct Genre: Decodable {
    
    let id: Int?
    let name: String?
}

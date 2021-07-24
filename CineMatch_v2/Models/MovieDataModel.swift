//
//  MovieDataModel.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 23/7/21.
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
    
    let watch_providers: [String: [String: Country]]
    
    private enum CodingKeys: String, CodingKey {
        case id,
             poster_path,
             backdrop_path,
             title,
             release_date,
             genres,
             tagline,
             overview,
             budget,
             revenue,
             runtime,
             vote_average,
             videos,
             credits,
             watch_providers = "watch/providers"
    }
    
    
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


//struct WatchProviders: Decodable {
//    
//    let AR, AT, AU, BE, BR, CA, CH, CL, CO, CZ, DE, DK, EC, EE, ES,
//        FI, FR, GB, GR, HU, ID, IE, IN, IT, JP, KR, LT, LV, MX, MY,
//        NL, NO, NZ, PE, PH, PL, PT, RO, RU, SE, SG, TH, TR, US, VE,
//        ZA: Country?
//    
//}

struct Country: Decodable {
    
    let buy: [Provider]?
    let flatrate: [Provider]?
    let rent: [Provider]?
}

struct Provider: Decodable {
    let logo_path: String?
    let provider_name: String?
}


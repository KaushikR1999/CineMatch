//
//  MovieDetailsViewController.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 16/7/21.
//

import UIKit
import Kingfisher
import youtube_ios_player_helper

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var moviePicture: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieScore: UILabel!
    @IBOutlet weak var movieYearGenres: UILabel!
    @IBOutlet weak var movieTagline: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    
    @IBOutlet weak var movieCast: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    @IBOutlet weak var movieBudget: UILabel!
    @IBOutlet weak var movieRuntime: UILabel!
    @IBOutlet weak var movieRevenue: UILabel!
    
    @IBOutlet weak var movieTrailer: YTPlayerView!
    
    @IBOutlet weak var movieWhereToBuy: UILabel!
    
    @IBOutlet weak var movieWhereToRent: UILabel!
    
    @IBOutlet weak var movieWhereToStream: UILabel!
    @IBOutlet weak var movieWhereToWatchLabel: UILabel!
    var movieDetails: MovieDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        populateMovieCard(movieDetails)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func populateMovieCard(_ movieDetails: MovieDetails) {
        // populate your details on to UI here
        
        //MARK: - Picture
        
        if let backdropPath = movieDetails.backdrop_path {
            let urlString = URL(string: "https://image.tmdb.org/t/p/w1280" + backdropPath)
            moviePicture.kf.setImage(with: urlString)
        } else if let posterPath = movieDetails.poster_path {
            let urlString = URL(string: "https://image.tmdb.org/t/p/w780" + posterPath)
            moviePicture.kf.setImage(with: urlString)
        } else {
            moviePicture.image = UIImage(named: "noImageAvailable")
        }
        
        //MARK: - Title, Year, Genres, Score
        movieTitle.text = movieDetails.title ?? "No title available"
        
        if let voteAverage = movieDetails.vote_average {
            movieScore.text = formatRatings(voteAverage)
        } else {
            movieScore.text = "n.a"
        }
        
        
        var year = "n.a."
        if let releaseDate = movieDetails.release_date {
             year = String(releaseDate.prefix(4))
        }
        
        var genres = "| "
        for genre in movieDetails.genres {
            if let name = genre.name {
                genres += (name + ", ")
            }
        }
        genres = String(genres.dropLast(2))
        movieYearGenres.text = "\(year) \(genres)"
    
        
        movieTagline.text = movieDetails.tagline ?? ""
        movieOverview.text = movieDetails.overview ?? "No synopsis available"
        movieOverview.sizeToFit()
        
        //MARK: - Box Office
        if let budget = movieDetails.budget {
            movieBudget.text = "Budget: \(formatMoney(budget))"
        } else {
            movieBudget.text = "Budget: n.a."
        }
        
        if let revenue = movieDetails.revenue {
            movieRevenue.text = "Revenue: \(formatMoney(revenue))"
        } else {
            movieRevenue.text = "Revenue: n.a."
        }
        
        if let runtime = movieDetails.runtime {
            if runtime != 0 {
                movieRuntime.text = "Runtime: \(runtime) mins"
            } else {
                movieRevenue.text = "Runtime: n.a."
            }
        } else {
            movieRevenue.text = "Runtime: n.a."
        }
        
        //MARK: - Cast and Crew
        var castMembers = ""
        if let cast = movieDetails.credits["cast"] {
            let topCast = Array(cast.prefix(4))
            for castMember in topCast {
                if let name = castMember.name {
                    castMembers += (name + ", ")
                }
            }
        }
        castMembers = String(castMembers.dropLast(2))
        if castMembers.isEmpty {
            castMembers = "n.a"
        }
        movieCast.text = castMembers
        
        var directors = ""
        if let crew =  movieDetails.credits["crew"] {
            for crewMember in crew {
                if let name = crewMember.name, let job = crewMember.job {
                    if job == "Director" {
                        directors += (name + ", ")
                    }
                }
            }
        }
        directors = String(directors.dropLast(2))
        if directors.isEmpty {
            directors = "n.a"
        }
        movieDirector.text = directors
        

        //MARK: - Video
        var videoKey = "Invalid"
        
        
        if let videos = movieDetails.videos["results"] {
            if !videos.isEmpty {
                
                let video = videos[0]
                if let key = video.key{
                    videoKey = key
                }
                
                for video in videos {
                    if video.type!.contains("Trailer") {
                        if let key = video.key {
                            videoKey = key
                            break
                        }
                    }
                }
 
            }
        }
        
    
        movieTrailer.load(withVideoId: videoKey,
                          playerVars: ["playsinline" : 1])
        
        //MARK: - Watch Providers
        
        DatabaseManager.shared.getCurrentUserDetails { (data) in
            let region = data["region"] as! String
            let dictionary = Locale.countryCodeDictionary()
            
            var whereToBuy = ""
            var whereToStream = ""
            var whereToRent = ""
            
            if let watchProviders = movieDetails.watch_providers["results"] {
                if let countryCode = dictionary[region] {
                    if let countryInfo = watchProviders[countryCode] {
                        
                        if let buy = countryInfo.buy {
                            whereToBuy = "Buy: "
                            
                            if buy.count == 0 {
                                whereToBuy = ""
                            }
                            for provider in buy {
                                whereToBuy += "\(provider.provider_name! ), "
                            }
                        
                            whereToBuy = String(whereToBuy.dropLast(2))
                            self.movieWhereToBuy.text = whereToBuy
                        }
                        
                        if let stream = countryInfo.flatrate {
                            whereToStream = "Stream: "
                            print(stream.count)
                            if stream.count == 0 {
                                whereToStream = ""
                            }
                            for provider in stream {
                                whereToStream += "\(provider.provider_name!), "
                            }
                        
                            whereToStream = String(whereToStream.dropLast(2))
                            self.movieWhereToStream.text = whereToStream
                        }
                        
                        if let rent = countryInfo.rent {
                            whereToRent = "Rent: "
                            if rent.count == 0 {
                                whereToRent = ""
                            }
                            for provider in rent {
                                whereToRent += "\(provider.provider_name!), "
                            }
                        
                            whereToRent = String(whereToRent.dropLast(2))
                            self.movieWhereToRent.text = whereToRent
                            
                        }
                        
                        if whereToBuy.isEmpty && whereToRent.isEmpty && whereToStream.isEmpty {
                            self.movieWhereToBuy.text = "No information available"
                        }
                        
                    } else {
                        self.movieWhereToBuy.text = "No information available"
                    }
                } else {
                    self.movieWhereToBuy.text = "No information available"
                }
            } else {
                self.movieWhereToBuy.text = "No information available"
            }
        }
        
        

    }
    
    func formatRatings(_ voteAverage: Double) -> String {
        let percent = Int(voteAverage * 10)
        if percent == 0 {
            return "n.a"
        }
        return "\(percent)%"
    }
    
    func formatMoney(_ money: Int) -> String {
        if money == 0 {
            return "n.a"
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:money))
        
        if let result = formattedNumber {
            return "$\(result)"
        }
        return "n.a."
    }
    
}


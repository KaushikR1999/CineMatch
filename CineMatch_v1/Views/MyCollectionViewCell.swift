//
//  MyCollectionViewCell.swift
//  CineMatch_v1
//
//  Created by Kaushik Kumar on 16/7/21.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    let apiService = ApiService()
    let cardViewModel = CardViewModel()


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with id: Int) {
        
        CardViewModel.shared.fetchMovieDetails(id: id) { movieDetails in
            guard let posterString = movieDetails.poster_path else {
                self.imageView.image = UIImage()
                return
            }
            
            let urlString = "https://image.tmdb.org/t/p/w780" + posterString
            
            guard let posterImageURL = URL(string: urlString) else {
                self.imageView.image = UIImage()
                return
            }
            

            self.imageView.kf.setImage(with: posterImageURL)
        }
            

    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }

}

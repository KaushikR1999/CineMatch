//
//  MovieCollectionViewController.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 23/7/21.
//

import UIKit

class MovieCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewBackgroundLabel: UILabel!
    public var sharedMovieIDs: [Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        
        collectionView.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        
    }
    




}

extension MovieCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let id = sharedMovieIDs[indexPath.row]
        CardViewModel.shared.fetchMovieDetails(id: id) { movieDetails in
            let rootVC = self.storyboard?.instantiateViewController(identifier: "MovieDetailsViewController") as! MovieDetailsViewController
            
            rootVC.movieDetails = movieDetails
            self.navigationController?.pushViewController(rootVC, animated: true)
        }
    }
    
    
}

extension MovieCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sharedMovieIDs.count == 0 {
            collectionViewBackgroundLabel.isHidden = false
            collectionViewBackgroundLabel.text = "You have no movies in common, keep swiping to increase your chances!"
            collectionView.backgroundView = collectionViewBackgroundLabel
        } else {
            collectionViewBackgroundLabel.isHidden = true
        }
        
        return sharedMovieIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as!
            MovieCollectionViewCell
        
        cell.configure(with: sharedMovieIDs[indexPath.row])
        
        return cell
    }
}

extension MovieCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (view.frame.size.width/3) - 3
        let yourHeight = (view.frame.size.width/3) - 3
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

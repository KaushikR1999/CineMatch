//
//  GroupCollectionViewController.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 26/7/21.
//

import UIKit

class GroupCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewBackgroundLabel: UILabel!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    
    public var sharedMovieIDs = [Int]()
    public var members = [String]()
    
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
    

    @IBAction func infoButtonPressed(_ sender: UIBarButtonItem) {
        
        DatabaseManager.shared.getGroupMembers(with: members) { (usernames) in
            var message = ""
            for username in usernames {
                message += "\(username), "
            }
            message = String(message.dropLast(2))
            
            let alert = UIAlertController(
                title: "Group Members",
                message: message,
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(
                                title: "Ok",
                                style: .cancel,
                                handler: nil))
            
            self.present(alert, animated: true)
        }
        
      
        
    }
    


}

extension GroupCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let id = sharedMovieIDs[indexPath.row]
        CardViewModel.shared.getMovieDetails(id: id) { movieDetails in
            let rootVC = self.storyboard?.instantiateViewController(identifier: "MovieDetailsViewController") as! MovieDetailsViewController
            
            rootVC.movieDetails = movieDetails
            self.navigationController?.pushViewController(rootVC, animated: true)
        }
    }
    
    
}

extension GroupCollectionViewController: UICollectionViewDataSource {
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

extension GroupCollectionViewController: UICollectionViewDelegateFlowLayout {
    
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

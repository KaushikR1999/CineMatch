//
//  StorageManager.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 16/7/21.
//

import Foundation
import Firebase
import FirebaseStorage


public class StorageManager {
    
    static let shared = StorageManager()
    private let metadata = StorageMetadata()

    
    private let bucket = Storage.storage().reference(forURL: "gs://cinematchv2.appspot.com")
    
  
//    public func downloadImage(with reference: String, completion: @escaping (Bool) -> Void) {
//        bucket.child(reference).child("profilePic").downloadURL { (url, error) in
//            guard let url = url, error == nil else {
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//    }
    
//    public func getStorageReference() -> StorageReference {
//        return bucket.child("profilePic")
//    }
//    
    public func uploadProfilePicture(with imageData: Data) {
        
        let profileRef = bucket.child("profilePic").child(Auth.auth().currentUser!.uid)
        print(Auth.auth().currentUser!.uid)
        metadata.contentType = "image/jpg"
        profileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
            if error != nil {
                //completion(false)
                return
            } else {
                profileRef.downloadURL { (url, error) in
                    if let metaImageURL = url?.absoluteString {
                        DatabaseManager.shared.updateProfilePictureURL(with: metaImageURL) { (success) in
                            //completion(success)
                            return
                        }
                    }
                }
            }
        }
    }
    

                
}

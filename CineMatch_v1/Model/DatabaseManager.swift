import Foundation
import Firebase
import FirebaseStorage

struct DatabaseManager {
    
    let storageRef = Storage.storage().reference(forURL: "gs://cinematch-3cb3b.appspot.com")
    let metadata = StorageMetadata()
    
    let currentUserDetails = Firestore.firestore()
        .collection("User Details").document(Auth.auth().currentUser!.uid)
    let usernames = Firestore.firestore()
        .collection("Usernames")
    
    let currentUser = Auth.auth().currentUser
    
    func updateRegion(_ selectedCountry: String) {
        if currentUser != nil {
            currentUserDetails.updateData(
                ["Region": selectedCountry])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    // print("Document successfully updated")
                }
            }
        }
    }
    
    func updateProfileImageURL(_ imageURL: String) {
        if currentUser != nil {
            currentUserDetails.updateData(
                ["profileImageURL": imageURL])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    // print("Document successfully updated")
                }
            }
        }
    }
    
    func storeProfilePic(_ imageData: Data) {
        
        let storageProfileRef = storageRef.child("profile").child(Auth.auth().currentUser!.uid)
        metadata.contentType = "image/jpg"
        
        storageProfileRef.putData(imageData, metadata: metadata, completion:
                                    { (storageMetaData, error) in
                                        if error != nil {
                                            print(error?.localizedDescription ?? "Error!")
                                            return
                                        }
                                        
                                        // if no error, save url under profileImageURL in User Details collection
                                        storageProfileRef.downloadURL(completion: { (url, error) in
                                            if let metaImageURL = url?.absoluteString {
                                                updateProfileImageURL(metaImageURL)
                                            }
                                        })
                                        
                                    })
    }
    
    func setProfilePic(profilePicture: UIImageView!, profileURLString: String?){
        if let profileURL = URL(string: profileURLString!) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: profileURL) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            profilePicture.image = image
                        }
                    }
                }
            }
        }
    }
    
    
    func retrieveProfilePic(_ profileURLString: String) -> UIImage {
        
        if let profileURL = URL(string: profileURLString) {
            if let data = try? Data(contentsOf: profileURL) {
                if let image = UIImage(data: data) {
                    return image
                }
            }
        }
        
        return #imageLiteral(resourceName: "default pic")
    }
    
}



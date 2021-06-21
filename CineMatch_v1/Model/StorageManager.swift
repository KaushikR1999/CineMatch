
import Foundation
import Firebase
import FirebaseStorage

struct StorageManager {
    
    let storageRef = Storage.storage().reference(forURL: "gs://cinematch-3cb3b.appspot.com")
    let db = Firestore.firestore()
    
    
    
    let metadata = StorageMetadata()
    
    func storeProfilePic(imageData: Data) {
        
        let storageProfileRef = storageRef.child("profile").child(Auth.auth().currentUser!.uid)
        metadata.contentType = "image/jpg"
        
        storageProfileRef.putData(imageData, metadata: metadata, completion:
                                    { (storageMetaData, error) in
                                        if error != nil {
                                            print(error?.localizedDescription)
                                            return
                                        }
                                        
                                        // if no error, save url under profileImageURL in User Details collection
                                        storageProfileRef.downloadURL(completion: { (url, error) in
                                            if let metaImageURL = url?.absoluteString {
                                                
                                                if Auth.auth().currentUser != nil {
                                                    self.db.collection("User Details").document(Auth.auth().currentUser!.uid).updateData([
                                                        "profileImageURL": metaImageURL
                                                    ]) { err in
                                                        if let err = err {
                                                            print("Error updating document: \(err)")
                                                        } else {
                                                            // print("Document successfully updated")
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        })
                                        
                                    })
    }
    
    func retrieveProfilePic(profilePicture: UIImageView!, profileURLString: String?){
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
        
}
    


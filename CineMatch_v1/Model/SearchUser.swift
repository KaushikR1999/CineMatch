import UIKit
import Firebase

struct SearchUser {
    
    let searchUserName: String
    let searchUserImage: UIImage
    let searchUserUID: String
    
    let currentUserDetails = Firestore.firestore()
        .collection("User Details").document(Auth.auth().currentUser?.uid ?? "")
    
}

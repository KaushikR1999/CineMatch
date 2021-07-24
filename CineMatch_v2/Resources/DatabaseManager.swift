//
//  DatabaseManager.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 16/7/21.
//

import Foundation
import Firebase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    private let userDetails = Firestore.firestore().collection("User Details")
    
    public func canCreateUser(with email: String, username: String, completion: @ escaping (Bool) -> Void) {
        
        checkIfUsernameAvailable(with: username) { (available) in
            completion(available)
        }
        
    }
    
    public func insertNewUser(with email: String, username: String,  uid: String, completion: @escaping (Bool) -> Void) {
        
        database.collection("User Details").document(uid)
            .setData(["username": username,
                      "email": email,
                      "region": "Singapore",
                      "profilePictureURL": "",
                      "friends": [String](),
                      "friendRequestsSent": [String](),
                      "friendRequestsReceived": [String](),
                      "likedMovieIds": [Int](),
                      "totalCardIndex": 0])
            { (error)  in
                if error == nil {
                    completion(true)
                    return
                } else {
                    completion(false)
                    return
                }
            }
        
    }
    
    public func getCurrentUsername(completion: @escaping (String) -> Void) {
        if Auth.auth().currentUser != nil {
            userDetails.document(Auth.auth().currentUser!.uid).addSnapshotListener { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    return
                }
                
                guard let data = document.data() else {
                    return
                }
                
                return completion(data["username"] as! String)
            }
        }

        
    }
    
    public func getCurrentUserDetails(completion: @escaping ([String: Any]) -> Void) {
        if Auth.auth().currentUser != nil {
            userDetails.document(Auth.auth().currentUser!.uid).getDocument { (documentSnapshot, error) in
                
                guard let document = documentSnapshot else {
                    return
                }
                
                guard let data = document.data() else {
                    return
                }
                
                return completion(data)
            }
        }
    }
    

 
            
    
    public func checkIfUsernameAvailable(with newUsername: String, completion: @escaping (Bool) -> Void) {
                
        database.collection("User Details")
            .whereField("username", isEqualTo: newUsername)
            .getDocuments { (querySnapshot, error) in
                if error != nil {
                    completion(false)
                    return
                } else {
                    
                    completion(querySnapshot?.count == 0)
                    return
                }
            }
    }
    
    public func updateUsername(with newUsername: String, completion: @escaping (Bool) -> Void) {
        if Auth.auth().currentUser != nil {
            userDetails.document(Auth.auth().currentUser!.uid).updateData(["username": newUsername]) { (error) in
                if error == nil {
                    completion(true)
                    return
                } else {
                    completion(false)
                    return
                }
            }
        }
    }
    
    public func updateUserRegion(with region: String, completion: @escaping (Bool) -> Void) {
        
        if Auth.auth().currentUser != nil {
            userDetails.document(Auth.auth().currentUser!.uid).updateData(["region": region]) { (error) in
                if error == nil {
                    completion(true)
                    return
                } else {
                    completion(false)
                    return
                }
            }
            
        }
        
    }
    
    public func updateTotalCardIndex(with index: Int, completion: @escaping () -> Void) {
        if Auth.auth().currentUser != nil {
            userDetails.document(Auth.auth().currentUser!.uid).updateData(["totalCardIndex": index]) { (error) in
                completion()
            }
            
        }
    }
    
    public func updatelikedMovieIDs(with id: Int, completion: @escaping ()-> Void) {
        if Auth.auth().currentUser != nil {
            
            userDetails.document(Auth.auth().currentUser!.uid).getDocument { (documentSnapshot, error) in
                
                guard let document = documentSnapshot else {
                    return
                }
                
                guard let data = document.data() else {
                    return
                }
                
                if let likedMovieIDs = data["likedMovieIDs"] as? [Int] {
                    if !likedMovieIDs.contains(id) {
                        
                        self.userDetails.document(Auth.auth().currentUser!.uid).updateData(["likedMovieIDs": FieldValue.arrayUnion([id])]) { (error) in
                            completion()
                        }
                    }
                }
                
            }
            
            
        }
    }
    
    public func updateProfilePictureURL(with urlString: String, completion: @escaping (Bool) -> Void) {
        
        if Auth.auth().currentUser != nil {
            userDetails.document(Auth.auth().currentUser!.uid).updateData(["profilePictureURL": urlString]) { (error) in
                if error == nil {
                    completion(true)
                    return
                } else {
                    completion(false)
                    return
                }
            }
        }
    }
    
    public func loadSearchUserCellDetails(with uid: String, completion: @escaping ([String: Any]) -> Void) {
        userDetails.document(uid).addSnapshotListener(includeMetadataChanges: true) { (documentSnapshot, error) in
            
            guard let document = documentSnapshot else {
                return
            }
            
            guard var data = document.data() else {
                return
            }
            

            
            if Auth.auth().currentUser != nil {
                
                self.checkIfFriends(with: uid) { (friend) in
                    if friend {
                        data["friendStatus"] = 0
                        completion(data)
                    }
                }
                
                let friendRequestsReceived = data["friendRequestsReceived"] as! [String]
                let friendRequestsSent = data["friendRequestsSent"] as! [String]
                if friendRequestsReceived.contains(Auth.auth().currentUser!.uid) || friendRequestsSent.contains(Auth.auth().currentUser!.uid) {
                    data["friendStatus"] = 1
                    completion(data)
                } else {
                    data["friendStatus"] = 2
            
                
                completion(data)
                }
            }

        }
    }
    
 
    public func loadProfilePage(with uid: String, completion: @escaping ([String: Any]) -> Void) {
        
        userDetails.document(uid).addSnapshotListener(includeMetadataChanges: true) { (documentSnapshot, error) in
            
            guard let document = documentSnapshot else {
                return
            }
            
            guard let data = document.data() else {
                return
            }
            
        
            
            completion(data)
        }
    }
    
    public func getSearchResults(with searchText: String, completion: @escaping ([String]) -> Void) {
        
        var userUIDs = [String]()
        var usernames = [String]()
        

        getCurrentUsername { (currentUsername) in
            self.userDetails.whereField("username", isNotEqualTo: currentUsername).addSnapshotListener(includeMetadataChanges: true) {
                (querySnapshot, error) in
                
                usernames.removeAll()
                userUIDs.removeAll()
                
                guard let query = querySnapshot else {
                    return
                }
                
                for doc in query.documents {
                    usernames.append(doc["username"] as! String)
                }
                
                //print("usernames: \(usernames)")
                
                let filteredUsernames = usernames.filter({$0.hasPrefix(searchText)})
                
                //print("filteredUsernames: \(filteredUsernames)")
                
                for doc in query.documents {
                    let username = doc["username"] as! String
                    if filteredUsernames.contains(username) {
                        userUIDs.append(doc.documentID)
                    }
                }
                
                completion(userUIDs)
                
            }
        }
        
    }
    
    public func canSendFriendRequest(with uid: String, completion: @escaping (Bool) -> Void) {
        
        userDetails.document(uid).getDocument { (documentSnapshot, error) in
            
            guard let document = documentSnapshot else {
                completion(false)
                return
            }
            
            guard let data = document.data() else {
                completion(false)
                return
            }
            
            let friendRequestsReceived = data["friendRequestsReceived"] as! [String]
            let friendRequestsSent = data["friendRequestsSent"] as! [String]
            
            if friendRequestsReceived.contains(uid) || friendRequestsSent.contains(uid) {
                completion(false)
                return
            }
            
            completion(true)
            
        }
        
    }
    
    public func sendFriendRequest(with uid: String, completion: @escaping (Bool) -> Void) {
        
        canSendFriendRequest(with: uid, completion: { (success) in
            if success {
                
                if Auth.auth().currentUser != nil {
                    
                    let currentUser = Auth.auth().currentUser
                    
                    self.userDetails.document(currentUser!.uid).updateData(["friendRequestsSent": FieldValue.arrayUnion([uid])]) { (error) in
                        completion(false)
                        return
                    }
                    
                    self.userDetails.document(uid).updateData(["friendRequestsReceived": FieldValue.arrayUnion([currentUser!.uid])]) { (error) in
                        completion(false)
                        return
                    }
                    
                    
                    completion(true)
                    
                }
            }
            
        })
        
    }
    
    public func getFriendRequestsReceived(completion: @escaping ([String]) -> Void) {
        
        if Auth.auth().currentUser != nil {
            
            userDetails.document(Auth.auth().currentUser!.uid).addSnapshotListener { (documentSnapshot, error) in
                
                guard let document = documentSnapshot else {
                    return
                }
                
                guard let data = document.data() else {
                    return
                }
                
                let friendRequestsReceived = data["friendRequestsReceived"] as! [String]
                completion(friendRequestsReceived)
                
            }
                        
        }
        
    }
    
    public func declineFriendRequest(with uid: String, completion: @escaping () -> Void) {
        
        if Auth.auth().currentUser != nil {
            
            userDetails.document(Auth.auth().currentUser!.uid).updateData(
                ["friendRequestsReceived": FieldValue.arrayRemove([uid])])
                 
            
            userDetails.document(uid).updateData(
                ["friendRequestsSent": FieldValue.arrayRemove([Auth.auth().currentUser!.uid])])
            
            completion()
        }
    }
    
    public func acceptFriendRequest(with uid: String, completion: @escaping () -> Void) {
        
        if Auth.auth().currentUser != nil {
            
            userDetails.document(Auth.auth().currentUser!.uid).updateData(
                ["friendRequestsReceived": FieldValue.arrayRemove([uid]),
                 "friends": FieldValue.arrayUnion([uid])
                ])
            
            userDetails.document(uid).updateData(
                ["friendRequestsSent": FieldValue.arrayRemove([Auth.auth().currentUser!.uid]),
                 "friends": FieldValue.arrayUnion([Auth.auth().currentUser!.uid])
                ])
            
            completion()
        }
    }
    
    public func checkIfFriends(with uid: String, completion: @escaping(Bool) -> Void) {
        
        if Auth.auth().currentUser != nil {
            
            userDetails.document(Auth.auth().currentUser!.uid).addSnapshotListener { (documentSnapshot, error) in
                
                guard let document = documentSnapshot else {
                    completion(false)
                    return
                }
                
                guard let data = document.data() else {
                    completion(false)
                    return
                }
                
                let friends = data["friends"] as! [String]
                completion(friends.contains(uid))
            }
        }
    }
    
    public func getFriends(completion: @escaping ([String]) -> Void) {
        
        if Auth.auth().currentUser != nil {
            
            userDetails.document(Auth.auth().currentUser!.uid).addSnapshotListener { (documentSnapshot, error) in
                
                guard let document = documentSnapshot else {
                    return
                }
                
                guard let data = document.data() else {
                    return
                }
                
                let friends = data["friends"] as! [String]
                completion(friends)
                
            }
                        
        }
        
    }
    
    public func loadUserDetails(with uid: String, completion: @escaping ([String: Any]) -> Void) {
        
        userDetails.document(uid).getDocument { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                return
            }
            
            guard let data = document.data() else {
                return
            }
            
            completion(data)
        }
    }
    
    public func getFriendRequestsReceivedAndFriends(completion: @escaping ([[[String: Any]]]) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        
        
        if Auth.auth().currentUser != nil {
            
            userDetails.document(Auth.auth().currentUser!.uid).addSnapshotListener {
                
                (documentSnapshot, error) in
                var friendRequestsData = [[String: Any]]()
                var friendsData = [[String: Any]]()
               
                
                guard let document = documentSnapshot else {
                    return
                }
                
                guard let data = document.data() else {
                    return
                }
                
                let friendRequestsReceived = data["friendRequestsReceived"] as! [String]

                
                let friends = data["friends"] as! [String]
                
                
                
                for friendRequest in friendRequestsReceived {
                    dispatchGroup.enter()
                    self.loadUserDetails(with: friendRequest) { (data) in
                        var friendRequestData = data
                        friendRequestData["uid"] = friendRequest
                        friendRequestsData.append(friendRequestData)
                        dispatchGroup.leave()
                    }

                }
                
                for friend in friends {
                    dispatchGroup.enter()
                    self.loadUserDetails(with: friend) { (data) in
                        var friendData = data
                        friendData["uid"] = friend
                        friendsData.append(friendData)
                        dispatchGroup.leave()
                    }

                }
            
                dispatchGroup.notify(queue: .main) {
                    
                    friendRequestsData = friendRequestsData.sorted {
                        $0["username"] as? String ?? ""
                            <
                        $1["username"] as? String ?? "" }
                    
                    friendsData = friendsData.sorted {
                        $0["username"] as? String ?? ""
                            <
                        $1["username"] as? String ?? "" }
                    
                    completion([friendRequestsData, friendsData])
                }

            }
        }
    }
    
    public func deleteFriend(with uid: String, completion: @escaping () -> Void) {
        
        if Auth.auth().currentUser != nil {
            userDetails.document(Auth.auth().currentUser!.uid)
                .updateData(["friends": FieldValue.arrayRemove([uid])])
            userDetails.document(uid)
                .updateData(["friends": FieldValue.arrayRemove([Auth.auth().currentUser!.uid])])
        }
        
    }
    
    public func getSharedMovieIDs(with uid: String, completion: @escaping ([Int]) -> Void) {
        
        if Auth.auth().currentUser != nil {
            userDetails.document(Auth.auth().currentUser!.uid).getDocument { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    return
                }
                
                guard let data = document.data() else {
                    return
                }
                
                if let movieIDs = data["likedMovieIDs"] as? [Int] {
                    self.userDetails.document(uid).getDocument { (documentSnapshot, error) in
                        guard let document = documentSnapshot else {
                            return
                        }
                        
                        guard let friendData = document.data() else {
                            return
                        }
                        
                    
                        
                        if let friendMovieIDs = friendData["likedMovieIDs"] as? [Int] {
                            let sharedMovieIDs: [Int] = Set(movieIDs).filter(Set(friendMovieIDs).contains)
                            completion(sharedMovieIDs)
                        } else {
                            completion([])
                        }
                        
                    }
                }
                
            }
        }
    }
    

    
}


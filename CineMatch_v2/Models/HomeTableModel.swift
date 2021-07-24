//
//  HomeTableModel.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 20/7/21.
//

import Foundation

class HomeTableModel {
    
    var title: String?
    var usersToDisplay: [[String: Any]]
    init(title: String, usersToDisplay: [[String: Any]]) {
        self.title = title
        self.usersToDisplay = usersToDisplay
    }
}

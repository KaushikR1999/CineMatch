//
//  Extensions.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 16/7/21.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Locale {
    
    static func getCountries() -> [String] {
        
        var countries = [String]()
        
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        
        return countries
        
    }
    
    static func countryCodeDictionary() -> [String: String] {
        var dictionary = [String : String]()
        let arrayWithCodes = Locale.isoRegionCodes
        for code in arrayWithCodes {
            let description = Locale.current.localizedString(forRegionCode: code)
            if description != nil {
                dictionary[description!] = code
            }
        }
        return dictionary

    }
    
    
}

extension UITableView {
    func deselectAllRows(animated: Bool) {
        guard let selectedRows = indexPathsForSelectedRows else { return }
        for indexPath in selectedRows { deselectRow(at: indexPath, animated: animated) }
    }
}

    
  
     




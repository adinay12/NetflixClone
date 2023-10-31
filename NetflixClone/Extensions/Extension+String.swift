//
//  Extension+String.swift
//  NetflixClone
//
//  Created by Adinay on 31/10/23.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

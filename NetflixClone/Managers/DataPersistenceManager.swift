//
//  DataPersistenceManager.swift
//  NetflixClone
//
//  Created by Adinay on 4/11/23.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DataBaseError: Error {
    case failedToSaveData
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping(Result<Void, Error>) -> Void ) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let contex = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: contex)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.orginal_name = model.orginal_name
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(Double(model.vote_count))
        item.vote_average = model.vote_average
        
        
        do {
            try contex.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
        
    }
}

//
//  RealmService.swift
//  Plando
//
//  Created by Nomadic on 1/24/21.
//

import Foundation
import RealmSwift

class RealmService {
    
    static let shared = RealmService()
    let realm = try! Realm()
    
    func createNewTask(task: Tasks, completion: @escaping(Result<Tasks, Error>) -> Void) {
        do {
            try realm.write {
                realm.add(task)
            }
        }
        catch {
            print("Error with saving task: \(error)")
            return
        }
        completion(.success(task))
    }
    
    
    func filterTask(category: String, completion: @escaping(Result<[Tasks], Error>) -> Void) {
        let filteredTasks = realm.objects(Tasks.self).filter("categories == %@",  category)
        var filteredTasksArray = [Tasks]()
        filteredTasksArray.append(contentsOf: filteredTasks)
        completion(.success(filteredTasksArray))
    }
}

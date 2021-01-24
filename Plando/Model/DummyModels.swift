//
//  DummyModels.swift
//  Plando
//
//  Created by Nomadic on 1/23/21.
//

import UIKit
import Foundation
import RealmSwift

struct Categories: Hashable, Decodable {
    let title: String
    let count: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: Categories, rhs: Categories) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var identifier = UUID()
    
    static func dummyCategories() -> [Categories] {
        return [
            Categories(title: "Business", count: "22"),
            Categories(title: "Personal", count: "36"),
            Categories(title: "Family", count: "8")
        ]
    }
}


class Tasks: Object, Decodable {
    
    @objc dynamic var name: String = ""
    @objc dynamic var categories: String = ""
    @objc dynamic var isDone: Bool = false
    
    static func == (lhs: Tasks, rhs: Tasks) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var identifier = UUID()
}

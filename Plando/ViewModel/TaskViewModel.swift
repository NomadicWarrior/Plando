//
//  TaskViewModel.swift
//  Plando
//
//  Created by Nomadic on 1/24/21.
//

import Foundation
import RxSwift
import RxRelay

class TaskViewModel {
    
    var taskText = BehaviorRelay<String>(value: "")
    var taskCategory = BehaviorRelay<String>(value: "")
    var isValid = BehaviorRelay<Bool>(value: false)
}

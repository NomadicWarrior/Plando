//
//  TasksCell.swift
//  Plando
//
//  Created by Nomadic on 1/23/21.
//

import UIKit

class TasksCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseId: String = "tasks"
    
    let taskIdentifier: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
        return view
    }()
    
    let taskTitle = UILabel(text: "Launch with Asel", font: .avenir20(), textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.01765209809, green: 0.09789755195, blue: 0.3310435712, alpha: 1)
        layer.cornerRadius = 15
        clipsToBounds = true
        taskTitle.translatesAutoresizingMaskIntoConstraints = false
        taskTitle.adjustsFontSizeToFitWidth = true
        
        addSubview(taskIdentifier)
        addSubview(taskTitle)
        
        NSLayoutConstraint.activate([
            taskIdentifier.heightAnchor.constraint(equalToConstant: 20),
            taskIdentifier.widthAnchor.constraint(equalToConstant: 20),
            taskIdentifier.centerYAnchor.constraint(equalTo: centerYAnchor),
            taskIdentifier.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            taskTitle.leadingAnchor.constraint(equalTo: taskIdentifier.trailingAnchor, constant: 15),
            taskTitle.centerYAnchor.constraint(equalTo: taskIdentifier.centerYAnchor),
            taskTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let tasks: Tasks = value as? Tasks else { return }
        taskTitle.text = tasks.name
        if tasks.categories == "Business" {
            taskIdentifier.layer.borderColor = #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
        }
        else if tasks.categories == "Personal" {
            taskIdentifier.layer.borderColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
        else if tasks.categories == "Family" {
            taskIdentifier.layer.borderColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        }
    }
    
    
}

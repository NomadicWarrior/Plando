//
//  CategoryCell.swift
//  Plando
//
//  Created by Nomadic on 1/23/21.
//

import UIKit

class CategoryCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "categories"
    
    let categoryTitleLabel = UILabel(text: "Category", font: .avenir22(), textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    let taskCountLabel = UILabel(text: "23 Tasks", font: .avenir16(), textColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    
    let lineView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lineView2: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.01765209809, green: 0.09789755195, blue: 0.3310435712, alpha: 1)
        layer.cornerRadius = 15
        clipsToBounds = true
        
        categoryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(categoryTitleLabel)
        addSubview(taskCountLabel)
        addSubview(lineView)
        lineView.addSubview(lineView2)
        
        NSLayoutConstraint.activate([
            categoryTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            taskCountLabel.bottomAnchor.constraint(equalTo: categoryTitleLabel.topAnchor, constant: 0),
            taskCountLabel.leadingAnchor.constraint(equalTo: categoryTitleLabel.leadingAnchor),
            
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            lineView.heightAnchor.constraint(equalToConstant: 2),
            lineView.leadingAnchor.constraint(equalTo: categoryTitleLabel.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            lineView2.heightAnchor.constraint(equalToConstant: 2),
            lineView2.leadingAnchor.constraint(equalTo: lineView.leadingAnchor),
            lineView2.widthAnchor.constraint(equalTo: lineView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let categories: Categories = value as? Categories else { return }
        categoryTitleLabel.text = categories.title
        taskCountLabel.text = "\(categories.count) Tasks"
        if categories.title == "Business" {
            lineView2.backgroundColor = #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
        }
        else if categories.title == "Personal" {
            lineView2.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
        else if categories.title == "Family" {
            lineView2.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        }
    }
}

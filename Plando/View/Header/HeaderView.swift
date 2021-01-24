//
//  HeaderView.swift
//  Plando
//
//  Created by Nomadic on 1/23/21.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let reuseIdentifier = "headerView"
    
    let title: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.4932157993, green: 0.6106783748, blue: 0.9087840915, alpha: 1)
        label.font = UIFont(name: "Avenir-Book", size: 17)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configure(text: String) {
        title.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

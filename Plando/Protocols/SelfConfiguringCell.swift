//
//  SelfConfiguringCell.swift
//  Plando
//
//  Created by Nomadic on 1/23/21.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}

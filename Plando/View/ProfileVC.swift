//
//  ProfileVC.swift
//  Plando
//
//  Created by Nomadic on 1/23/21.
//

import UIKit

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.01790219918, green: 0.09771444649, blue: 0.3351454437, alpha: 1)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.01790219918, green: 0.09771444649, blue: 0.3351454437, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}

// MARK: - Setup constraints
extension ProfileVC {
    private func setupConstraints() {
        view.backgroundColor = #colorLiteral(red: 0.01790219918, green: 0.09771444649, blue: 0.3351454437, alpha: 1)
        
    }
}


// MARK: - Content View
import SwiftUI

struct ProfileProvider: PreviewProvider {
    static var previews: some View {
        ContentView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContentView: UIViewControllerRepresentable {
        let vc = ProfileVC()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileProvider.ContentView>) -> ProfileVC {
            return vc
        }
        
        func updateUIViewController(_ uiViewController: ProfileProvider.ContentView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProfileProvider.ContentView>) {
            
        }
    }
}

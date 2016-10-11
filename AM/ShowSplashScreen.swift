//
//  ShowSplashScreen.swift
//  AM
//
//  Created by Sefa Sevtekin on 4/29/16.
//  Copyright © 2016 Sefa Sevtekin. All rights reserved.
//

import UIKit
import Foundation


class ShowSplashScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(ShowSplashScreen.showApp), with: nil, afterDelay: 0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func showApp() {
        performSegue(withIdentifier: "GoToApp", sender: self)
    }
}

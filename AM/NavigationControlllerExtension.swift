//
//  NavigationControlllerExtension.swift
//  AM
//
//  Created by Sefa Sevtekin on 3/30/16.
//  Copyright © 2016 Sefa Sevtekin. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var shouldAutorotate : Bool {
            print("++++++++++++++++++++++++++++ should do this")
            return true
    }
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        //if visibleViewController is AnnualTrendsChart {
        //print("++++++++++++++++++++++++++++ should really do this")
        //    return [.landscape]
        //}
        return [.portrait]
    }
}

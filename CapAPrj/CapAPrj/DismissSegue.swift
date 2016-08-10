//
//  DismissSegue.swift
//  AAAAA
//
//  Created by Ting on 16/7/1.
//  Copyright © 2016年 Ting. All rights reserved.
//

import UIKit

@objc(DismissSegue) class DismissSegue: UIStoryboardSegue  {
    
    override func perform() {
        if let controller = sourceViewController.presentingViewController {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}

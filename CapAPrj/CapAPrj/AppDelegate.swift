//
//  AppDelegate.swift
//  CapAPrj
//
//  Created by Ting on 16/7/13.
//  Copyright © 2016年 Ting. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var loggedIn = false
    // 03.08.16
    var objects = [String:String]()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        setupRootViewController(false)
        
        return true
    }
    
    
    func setupRootViewController(animated: Bool) {
        //print(loggedIn)
        if let window = self.window {
            var newRootViewController: UIViewController? = nil
            var transition: UIViewAnimationOptions
            
            // create and setup appropriate rootViewController
            if !loggedIn {
                /*
                 let loginViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
                 newRootViewController = loginViewController
                 transition = .TransitionFlipFromLeft
                 */
                let navigationController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("LoginNV") as! UINavigationController
            
                newRootViewController = navigationController
                transition = .TransitionFlipFromLeft
                
            } else {
                let splitViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("SplitVC") as! UISplitViewController
                let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
                navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
                splitViewController.delegate = self
                
                let tabBarController = splitViewController.viewControllers[0] as! UITabBarController
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("NavController") as! UINavigationController
                vc.tabBarItem.title = "vin"
                vc.tabBarItem.tag = 1
                vc.tabBarItem.image = UIImage(named: "vin.png")
                
                let vc1 = storyboard.instantiateViewControllerWithIdentifier("NavController") as! UINavigationController
                
                vc1.tabBarItem.title = "time"
                vc1.tabBarItem.tag = 2
                vc1.tabBarItem.image = UIImage(named: "time.png")
                
                tabBarController.viewControllers?.append(vc)
                tabBarController.viewControllers?.append(vc1)
                
                newRootViewController = splitViewController
                transition = .TransitionFlipFromRight
            }
            
            // update app's rootViewController
            if let rootVC = newRootViewController {
                if animated {
                    UIView.transitionWithView(window, duration: 0.5, options: transition, animations: { () -> Void in
                        window.rootViewController = rootVC
                        //print("hello")
                        }, completion: nil)
                } else {
                    window.rootViewController = rootVC
                }
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}


//  Sabah Naveed
//  AppDelegate.swift
//  Todoey
//
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
        } catch {
            print("error initializing realm \(error)")
        }
        
        return true
    }



}


//
//  AppDelegate.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 7/17/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    override func buildMenu(with builder: UIMenuBuilder)
       {
           #if targetEnvironment(macCatalyst)
           print("UIKit running on macOS")
           super.buildMenu(with: builder)
           builder.remove(menu: .help)
           
           #else
           print("Your regular code")
           #endif
           
       }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { authorized, error in
            if authorized {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        })

        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  
        let subscription = CKQuerySubscription(recordType: "Notification", predicate: NSPredicate(format: "TRUEPREDICATE"), options: .firesOnRecordCreation)

        let info = CKSubscription.NotificationInfo()
        // this will use the 'title' field in the Record type 'notifications' as the title of the push notification
        //  info.titleLocalizationKey = "%1$@"
        //  info.titleLocalizationArgs = ["title"]
        //this will use the 'content' field in the Record type 'notifications' as the content of the push notification
            info.alertLocalizationKey = "%1$@"
            info.alertLocalizationArgs = ["content"]
        //info.alertBody = "Hello A new message has been posted"
        info.shouldBadge = true
        info.soundName = "default"

        subscription.notificationInfo = info
        
        CKContainer.default().publicCloudDatabase.save(subscription, completionHandler: { sunscription, error in
            if error == nil {
                
            } else {
                
            }
        })
        
    }
    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Remote notification is unavailable: \(error.localizedDescription)")
//    }
//



     
     // This function will be called right after user tap on the notification
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        //UIApplication.shared.applicationIconBadgeNumber = 0
        
        resetBedgeCounter()
       // tell the app that we have finished processing the user’s action (eg: tap on notification banner) / response
       completionHandler()
     }
    
    func resetBedgeCounter() {
        let badgeResetOperation = CKModifyBadgeOperation(badgeValue: 0)
        badgeResetOperation.modifyBadgeCompletionBlock = { (error) -> Void in
            
            if error != nil {
                print("Error resetting badge: \(String(describing: error))")
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        }
        CKContainer.default().add(badgeResetOperation)
    }
    


    
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


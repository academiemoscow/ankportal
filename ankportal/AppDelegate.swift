//
//  AppDelegate.swift
//  ankportal
//
//  Created by Admin on 17/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import ESTabBarController_swift
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var orientaionLock = UIInterfaceOrientationMask.all
    var window: UIWindow?
    let tabBarController = LightESTabBarController()
    let gcmMessageIDKey = "gcm.message_id"
    let chatLogController = LightNavigarionController(rootViewController: ChatLogController(collectionViewLayout: UICollectionViewFlowLayout()))
    
    let chatLogTabBarContentView = StoredBadgeValueItemContentView(key: "chatLogItemBadgeValue")
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        })
        return container
    }()
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let vc = (viewController as? UINavigationController)?.viewControllers.first,
            tabBarController.selectedViewController == viewController else {
                return true
        }
        if let view = vc.view as? UIScrollView {
            view.setContentOffset(CGPoint(x: 0, y: -view.adjustedContentInset.top), animated: true)
        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        UIApplication.shared.applicationIconBadgeNumber = 0
        
//        UserDefaults.standard.set(true, forKey: ""LightDefault)
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        Messaging.messaging().delegate = self
        
        tabBarController.delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        tabBarController.tabBar.isTranslucent = false
        
        
        let productListController = LightNavigarionController(rootViewController: ProductsTableViewController())
        let mainPageController = LightNavigarionController(rootViewController: MainPageViewController())
        let educationPageController = LightNavigarionController(rootViewController: EducationsTableViewController())
        let elseController = LightNavigarionController(rootViewController: InformationTableViewController())
        
        mainPageController.tabBarItem = ESTabBarItem(ItemContentView(), title: nil, image: UIImage(named: "mainpage"), selectedImage: UIImage(named: "mainpage_on"), tag: 1)
        productListController.tabBarItem = ESTabBarItem(ItemContentView(), title: nil, image: UIImage(named: "catalog"), selectedImage: UIImage(named: "catalog_on"), tag: 2)
        educationPageController.tabBarItem = ESTabBarItem(ItemContentView(), title: nil, image: UIImage(named: "education"), selectedImage: UIImage(named: "education_on"), tag: 3)
        chatLogController.tabBarItem = ESTabBarItem(chatLogTabBarContentView, title: nil, image: UIImage(named: "chat"), selectedImage: UIImage(named: "chat_on"), tag: 4)
        elseController.tabBarItem = ESTabBarItem(ItemContentView(), title: nil, image: UIImage(named: "else"), selectedImage: UIImage(named: "else_on"), tag: 5)
        
//        mainPageController.tabBarItem = ESTabBarItem(ItemContentView(), title: "Главная", image: UIImage(named: "mainpage"), selectedImage: UIImage(named: "mainpage_on"), tag: 1)
//        productListController.tabBarItem = ESTabBarItem(ItemContentView(), title: "Каталог", image: UIImage(named: "catalog"), selectedImage: UIImage(named: "catalog_on"), tag: 2)
//        educationPageController.tabBarItem = ESTabBarItem(ItemContentView(), title: "Семинары", image: UIImage(named: "education"), selectedImage: UIImage(named: "education_on"), tag: 3)
//        chatLogController.tabBarItem = ESTabBarItem(chatLogTabBarContentView, title: "Диалоги", image: UIImage(named: "chat"), selectedImage: UIImage(named: "chat_on"), tag: 4)
//        elseController.tabBarItem = ESTabBarItem(ItemContentView(), title: "Информация", image: UIImage(named: "else"), selectedImage: UIImage(named: "else_on"), tag: 5)
        
        tabBarController.viewControllers = [mainPageController, productListController, educationPageController, chatLogController, elseController]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            chatLogTabBarContentView.setBadge("")
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientaionLock
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if tabBarController.selectedViewController != chatLogController {
            chatLogTabBarContentView.setBadge("")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            chatLogTabBarContentView.setBadge("")
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        if let _ = userInfo["aps"] as? [String: AnyObject] {
            if tabBarController.selectedViewController != chatLogController {
                chatLogTabBarContentView.setBadge("")
            }
        }
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        if let _ = userInfo["aps"] as? [String: AnyObject] {
            tabBarController.openChat()
        }
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

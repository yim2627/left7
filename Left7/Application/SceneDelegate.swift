//
//  SceneDelegate.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import UIKit

private extension SceneDelegate {
    enum Design {
        static let homeTabBarSelectedImageSystemName = "house.fill"
        static let homeTabBarImageSystemName = "house"
        static let homeTabBarTitle = "홈"
        
        static let favoriteTabBarSelecetedImageSystemName = "suit.heart.fill"
        static let favoriteTabBarImageSystemName = "suit.heart"
        static let favoriteTabBarTitle = "좋아요"
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // HomeViewController
        let homeViewController = YogiHomeViewController()
        homeViewController.reactor = YogiHomeViewReactor()
        
        let homeTabBarSelectedImage = UIImage(systemName: Design.homeTabBarSelectedImageSystemName)
        homeViewController.tabBarItem = UITabBarItem(
            title: Design.homeTabBarTitle,
            image: UIImage(systemName: Design.homeTabBarImageSystemName),
            selectedImage: homeTabBarSelectedImage
        )
        
        // FavoriteViewController
        let favoriteViewController = YogiFavoriteViewController()
        favoriteViewController.reactor = YogiFavoriteViewReactor()
        
        let favoriteTabBarSelecetedImage = UIImage(systemName: Design.favoriteTabBarSelecetedImageSystemName)
        favoriteViewController.tabBarItem = UITabBarItem(
            title: Design.favoriteTabBarTitle,
            image: UIImage(systemName: Design.favoriteTabBarImageSystemName),
            selectedImage: favoriteTabBarSelecetedImage
        )
        
        let homeNavigationViewController = UINavigationController(rootViewController: homeViewController)
        let favoriteNavigationViewController = UINavigationController(rootViewController: favoriteViewController)
        
        // TabBarController
        let tabBarViewController = UITabBarController()
        
        tabBarViewController.viewControllers = [homeNavigationViewController, favoriteNavigationViewController]
        tabBarViewController.tabBar.tintColor = UIColor(red: 236/255, green: 94/255, blue: 101/255, alpha: 1)
        tabBarViewController.tabBar.unselectedItemTintColor = .systemGray2
        
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


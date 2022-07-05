import UIKit
import FirebaseCore
//import FirebaseFirestore


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        window = UIWindow()
        let tabBarController = UITabBarController()

        let factory = MyLoginFactory()
        let logInVC = LogInViewController(delegate: factory.createInspector())
        
        
        logInVC.tabBarItem = UITabBarItem(title: "Profile", image: .init(systemName: "person.fill"), tag: 0)
        let feedVC = FeedViewController()
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: .init(systemName: "house.fill"), tag: 1)
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = .systemGray6
        
        let profileNavigationController = UINavigationController(rootViewController: logInVC)
        profileNavigationController.navigationBar.scrollEdgeAppearance = navigationAppearance
        
        
        let feedNavigationController =
            UINavigationController(rootViewController: feedVC)
        feedNavigationController.navigationBar.scrollEdgeAppearance = navigationAppearance
    
        tabBarController.tabBar.backgroundColor = .systemGray6
        tabBarController.tabBar.unselectedItemTintColor = .systemGray
        tabBarController.tabBar.tintColor = .systemBlue
        
        tabBarController.setViewControllers([feedNavigationController, profileNavigationController ], animated: true)
        tabBarController.selectedIndex = 0
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }

}


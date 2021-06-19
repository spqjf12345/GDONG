//
//  SceneDelegate.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/04/07.
//

import UIKit
import KakaoSDKAuth
import GoogleSignIn
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let _ = (scene as? UIWindowScene) else { return }
        if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
            
                if (UserDefaults.standard.string(forKey: UserDefaultKey.accessToken) != nil) {
                    print("access token yes")
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabbarVC = storyboard.instantiateViewController(withIdentifier: "tabbar")
                    window.rootViewController = tabbarVC
                    self.window = window
                    window.makeKeyAndVisible()
                }else{
                    print("access token nil")
                    let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(withIdentifier: "login")
                    window.rootViewController = loginVC
                    self.window = window
                    window.makeKeyAndVisible()
                }
            }
    
    }

    //scene의 연결이 해제될 때 호출
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)){
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
        
        guard let scheme = URLContexts.first?.url.scheme else { return }
        if scheme.contains("com.googleusercontent.apps") {
            GIDSignIn.sharedInstance().handle(URLContexts.first?.url)
        }
        
    
    }


}


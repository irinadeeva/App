//
//  SceneDelegate.swift
//  ToDoApp
//
//  Created by Irina Deeva on 28/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(windowScene: windowScene)
    let tabBarController = UITabBarController()
    let navigationController = UINavigationController(rootViewController: TaskListModuleBuilder.build())

    let editButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(editButtonTapped)
        )
    tabBarController.navigationItem.rightBarButtonItem = editButton
        navigationController.topViewController?.navigationItem.rightBarButtonItem = editButton

    tabBarController.viewControllers = [navigationController]

    window.rootViewController = tabBarController
    self.window = window
    window.makeKeyAndVisible()
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }

  @objc func editButtonTapped() {
      // Ваш код для обработки нажатия кнопки
      print("Edit button tapped")
  }
}


//
//  SplashView.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import UIKit
import ReachabilityPackage
import LoadingManager

class SplashViewController: UIViewController, ReachabilityProtocol {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        LoadingManager.shared.startLoading()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            LoadingManager.shared.stopLoading()

            if self?.isConnectedToNetwork() == true {
                let tabBarController = TabBarController()
                self?.view.window?.rootViewController = tabBarController
            } else {
                let alertController = UIAlertController(title: "İnternet Bağlantısı Yok", message: "Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func isConnectedToNetwork() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
}

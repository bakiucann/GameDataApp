//
//  SplashView.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import UIKit

class SplashViewController: UIViewController {

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        activityIndicator.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.activityIndicator.stopAnimating()

            if Reachability.isConnectedToNetwork() {
                let tabBarController = TabBarController()
                self?.view.window?.rootViewController = tabBarController
            } else {
                let alertController = UIAlertController(title: "İnternet Bağlantısı Yok", message: "Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

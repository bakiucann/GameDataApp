//
//  SplashView.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import UIKit
import ReachabilityPackage
import LoadingManager

// `SplashViewController`, UIViewController sınıfını miras alır ve ReachabilityProtocol'ü uygular.
class SplashViewController: UIViewController, ReachabilityProtocol {

    // Yükleme ekranı açıldığında çağrılan işlev.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Yükleme ekranını başlatır.
        LoadingManager.shared.startLoading()

        // 1 saniye sonra bir işlem gerçekleştirir.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            // Yükleme ekranını durdurur.
            LoadingManager.shared.stopLoading()

            // İnternet bağlantısı kontrolü yapar.
            if self?.isConnectedToNetwork() == true {
                // Eğer internet bağlantısı varsa, uygulamanın ana ekranı olan TabBarController'ı oluşturur ve görüntülemeye ayarlar.
                let tabBarController = TabBarController()
                self?.view.window?.rootViewController = tabBarController
            } else {
                // Eğer internet bağlantısı yoksa, kullanıcıya bir uyarı gösterir.
                let alertController = UIAlertController(title: "İnternet Bağlantısı Yok", message: "Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }

    // İnternet bağlantısını kontrol etmek için kullanılan işlev.
    func isConnectedToNetwork() -> Bool {
        // Reachability sınıfını kullanarak, cihazın internete bağlı olup olmadığını kontrol ederiz.
        let reachability = Reachability()
        return reachability.isConnectedToNetwork()
    }
}

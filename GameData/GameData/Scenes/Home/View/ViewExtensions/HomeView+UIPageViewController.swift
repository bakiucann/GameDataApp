//
//  UIPageViewController.swift
//  GameData
//
//  Created by Baki Uçan on 14.07.2023.
//

import UIKit

// HomeViewController sınıfını UIPageViewControllerDataSource protokolü ile genişletir.
extension HomeViewController: UIPageViewControllerDataSource {
    // UIPageViewControllerDataSource protokolünden türetilen, önceki sayfayı döndüren işlev.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Mevcut görüntülenen view controller'ın altında bulunan GamePageView'ı alırız.
        guard let gamePageView = viewController.view.subviews.first as? GamePageView,
              let gameIndex = viewModel.filteredGames.firstIndex(where: { $0.id == gamePageView.game.id }),
              gameIndex > 0 else {
            return nil
        }

        // Daha önceki bir oyun sayfası oluşturur ve döndürürüz.
        let previousGame = viewModel.filteredGames[gameIndex - 1]
        return createGamePageView(for: previousGame)
    }

    // UIPageViewControllerDataSource protokolünden türetilen, sonraki sayfayı döndüren işlev.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Mevcut görüntülenen view controller'ın altında bulunan GamePageView'ı alırız.
        guard let gamePageView = viewController.view.subviews.first as? GamePageView,
              let gameIndex = viewModel.filteredGames.firstIndex(where: { $0.id == gamePageView.game.id }),
              gameIndex < min(viewModel.filteredGames.count, 3) - 1 else {
            return nil
        }

        // Sonraki bir oyun sayfası oluşturur ve döndürürüz.
        let nextGame = viewModel.filteredGames[gameIndex + 1]
        return createGamePageView(for: nextGame)
    }
}

// HomeViewController sınıfını UIPageViewControllerDelegate protokolü ile genişletir.
extension HomeViewController: UIPageViewControllerDelegate {
    // UIPageViewControllerDelegate protokolünden türetilen, sayfa geçişi başladığında çağrılan işlev.
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        // Geçiş yapılacak olan view controller'ın altında bulunan GamePageView'ı alırız.
        guard let gamePageView = pendingViewControllers.first?.view.subviews.first as? GamePageView,
              let gameIndex = viewModel.filteredGames.firstIndex(where: { $0.id == gamePageView.game.id }) else {
            return
        }
        // PageControl'ın anlık sayfayı güncellemesi için geçiş yapılacak olan oyunun indeksi kullanılır.
        pageControl.currentPage = gameIndex
    }
}

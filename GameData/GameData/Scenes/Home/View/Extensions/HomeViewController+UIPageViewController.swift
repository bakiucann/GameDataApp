//
//  UIPageViewController.swift
//  GameData
//
//  Created by Baki Uçan on 14.07.2023.
//

import UIKit

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let gamePageView = viewController.view.subviews.first as? GamePageView,
              let gameIndex = viewModel.filteredGames.firstIndex(where: { $0.id == gamePageView.game.id }),
              gameIndex > 0 else {
            return nil
        }

        let previousGame = viewModel.filteredGames[gameIndex - 1]
        return createGamePageView(for: previousGame)
      
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let gamePageView = viewController.view.subviews.first as? GamePageView,
              let gameIndex = viewModel.filteredGames.firstIndex(where: { $0.id == gamePageView.game.id }),
              gameIndex < min(viewModel.filteredGames.count, 3) - 1 else {
            return nil
        }

        let nextGame = viewModel.filteredGames[gameIndex + 1]
        return createGamePageView(for: nextGame)
    }
}


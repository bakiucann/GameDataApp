//
//  HomeViewController.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties

    let viewModel = HomeViewModel()
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    let pageControl = UIPageControl()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var collectionViewTopConstraint: NSLayoutConstraint?
    var isSearching: Bool = false

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupViewModel()
    }

    // MARK: - Setup Methods

    private func setupNavigationBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Games"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    private func setupViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.updatePageViewController()
                self?.collectionView.reloadData()
                self?.handleEmptyState()
            }
        }

        viewModel.fetchGames()
        pageViewController.dataSource = self
    }

    // MARK: - Helper Methods

    private func updatePageViewController() {
        guard let firstGame = viewModel.filteredGames.first else { return }

        let firstGamePageView = createGamePageView(for: firstGame)
        pageViewController.setViewControllers([firstGamePageView], direction: .forward, animated: true, completion: nil)

        pageControl.numberOfPages = min(viewModel.filteredGames.count, 3)
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.black
    }

    public func createGamePageView(for game: Game) -> UIViewController {
        let gamePageView = GamePageView()
        gamePageView.configure(with: game)

        let viewController = UIViewController()
        viewController.view.addSubview(gamePageView)

        gamePageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gamePageView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            gamePageView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            gamePageView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            gamePageView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openGameDetail(_:)))
        gamePageView.addGestureRecognizer(tapGesture)
        gamePageView.isUserInteractionEnabled = true
        gamePageView.tag = game.id

        return viewController
    }

    @objc private func openGameDetail(_ gesture: UITapGestureRecognizer) {
        guard let gameId = gesture.view?.tag,
            let selectedGame = viewModel.filteredGames.first(where: { $0.id == gameId }) else {
                return
        }

        let gameDetailViewController = GameDetailViewController(game:selectedGame)
        navigationController?.pushViewController(gameDetailViewController, animated:true)
    }

    public func handleEmptyState() {
        if viewModel.filteredGames.isEmpty {
            collectionView.isHidden = true
            view.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }

            let messageLabel = UILabel()
            messageLabel.text = "Üzgünüz, aradığınız oyun bulunamadı!"
            messageLabel.textAlignment = .center
            messageLabel.textColor = .black
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(messageLabel)

            NSLayoutConstraint.activate([
                messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        } else {
            collectionView.isHidden = false
            view.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        }

        if searchBarIsEmpty() {
            pageViewController.view.isHidden = false
            pageControl.isHidden = false
        } else {
            pageViewController.view.isHidden = true
            pageControl.isHidden = true
        }
    }


    private func searchBarIsEmpty() -> Bool {
        if let searchBar = navigationItem.titleView as? UISearchBar, let searchText = searchBar.text {
            return searchText.isEmpty
        }
        return true
    }
 }

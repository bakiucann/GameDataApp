//
//  HomeViewController.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties

    public let viewModel = HomeViewModel()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private let pageControl = UIPageControl()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

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

    private func setupViews() {
        view.backgroundColor = .systemBackground

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        view.addSubview(pageControl)

        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.reuseIdentifier)

        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            pageViewController.view.bottomAnchor.constraint(equalTo: pageControl.topAnchor),

            pageControl.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            collectionView.topAnchor.constraint(equalTo: pageControl.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupViewModel() {
        viewModel.reloadTableView = { [weak self] in
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
        pageViewController.setViewControllers([firstGamePageView], direction: .forward, animated: false, completion: nil)

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

        let gameDetailViewController = GameDetailViewController(game: selectedGame)
        navigationController?.pushViewController(gameDetailViewController, animated: true)
    }

    private func handleEmptyState() {
        if viewModel.filteredGames.isEmpty {
            pageViewController.view.isHidden = true
            collectionView.isHidden = true
            pageControl.isHidden = true

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
            pageViewController.view.isHidden = false
            collectionView.isHidden = false
            pageControl.isHidden = false
            view.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        }
    }
}

// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.filterGames(with: "")
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            viewModel.filterGames(with: searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

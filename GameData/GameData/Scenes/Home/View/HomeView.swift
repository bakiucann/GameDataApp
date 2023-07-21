//
//  HomeViewController.swift
//  GameData
//
//  Created by Baki Uçan on 11.07.2023.
//

import UIKit

// HomeViewController sınıfını oluşturuyoruz.
class HomeViewController: UIViewController {

    // MARK: - Properties

    // HomeViewModel nesnesini oluşturuyoruz.
    let viewModel = HomeViewModel()

    // UIPageViewController nesnesini oluşturuyoruz.
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    // UIPageControl nesnesini oluşturuyoruz.
    let pageControl = UIPageControl()

    // UICollectionView nesnesini oluşturuyoruz.
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // UICollectionView üst kenar bağlayıcısını tutan değişkeni tanımlıyoruz.
    var collectionViewTopConstraint: NSLayoutConstraint?

    // Arama çubuğunda arama yapılıp yapılmadığını tutan değişkeni tanımlıyoruz.
    var isSearching: Bool = false

    // MARK: - Lifecycle Methods

    // Ana sayfa görünümü yüklendiğinde çağrılan yöntem.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation bar'ı yapılandıran yöntemi çağırıyoruz.
        setupNavigationBar()

        // Görünümleri oluşturacak yöntemi çağırıyoruz.
        setupViews()

        // Constraint'leri oluşturacak yöntemi çağırıyoruz.
        setupConstraints()

        // View model'ı yapılandıran yöntemi çağırıyoruz.
        setupViewModel()
    }

    // MARK: - Setup Methods

    // Navigation bar'ı yapılandıran yöntem.
    private func setupNavigationBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Games"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    // View model'ı yapılandıran yöntem.
    private func setupViewModel() {
        // View model'den gelen koleksiyon görünümünü ve sayfaları güncelleyen bir kapatma bloğu tanımlıyoruz.
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.updatePageViewController()
                self?.collectionView.reloadData()
                self?.handleEmptyState()
            }
        }

        // View model'ın oyunları yükleme işlemini başlatıyoruz.
        viewModel.fetchGames()
        pageViewController.dataSource = self
    }

    // MARK: - Helper Methods

    // Sayfaları güncelleyen yöntem.
    private func updatePageViewController() {
        // Eğer filtrelenmiş oyunlar boşsa, işlemi sonlandırırız.
        guard let firstGame = viewModel.filteredGames.first else { return }

        // İlk oyun için bir oyun sayfası oluştururuz.
        let firstGamePageView = createGamePageView(for: firstGame)

        // PageViewController'in görünümünü güncellemek için kullanılır.
        // Animasyonlu bir şekilde ilk oyun sayfasını gösteririz.
        pageViewController.setViewControllers([firstGamePageView], direction: .forward, animated: true, completion: nil)

        // PageControl'un sayfa sayısını güncelleriz.
        // En fazla 3 sayfa gösterileceğini belirleriz.
        pageControl.numberOfPages = min(viewModel.filteredGames.count, 3)
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.black
    }

    // Bir oyun sayfası oluşturan yöntem.
    public func createGamePageView(for game: Game) -> UIViewController {
        // GamePageView nesnesini oluştururuz ve oyun verileriyle yapılandırırız.
        let gamePageView = GamePageView()
        gamePageView.configure(with: game)

        // Oyun sayfası için bir UIViewController nesnesi oluştururuz ve GamePageView'i ekleriz.
        let viewController = UIViewController()
        viewController.view.addSubview(gamePageView)

        // Oyun sayfasının düzenlemesini yapılandırırız.
        gamePageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gamePageView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            gamePageView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            gamePageView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            gamePageView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])

        // Oyun sayfasına dokunma jesti ekleyerek oyun detay sayfasını açarız.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openGameDetail(_:)))
        gamePageView.addGestureRecognizer(tapGesture)
        gamePageView.isUserInteractionEnabled = true
        gamePageView.tag = game.id

        // Oluşturulan UIViewController nesnesini döndürürüz.
        return viewController
    }

    // Oyun detay sayfasını açan yöntem.
    @objc private func openGameDetail(_ gesture: UITapGestureRecognizer) {
        guard let gameId = gesture.view?.tag,
            let selectedGame = viewModel.filteredGames.first(where: { $0.id == gameId }) else {
                return
        }

        let gameDetailViewController = GameDetailViewController(game: selectedGame)
        navigationController?.pushViewController(gameDetailViewController, animated: true)
    }

    // Boş durum ekranını yöneten yöntem.
    public func handleEmptyState() {
        // Filtrelenmiş oyunlar boşsa, boş durum ekranını gösteririz.
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
            // Filtrelenmiş oyunlar varsa, boş durum ekranını gizleriz.
            collectionView.isHidden = false
            view.subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
        }

        // Eğer arama çubuğu boşsa, PageViewController ve PageControl'u gösteririz.
        // Arama yapıldığında, PageViewController ve PageControl gizlenir.
        if searchBarIsEmpty() {
            pageViewController.view.isHidden = false
            pageControl.isHidden = false
        } else {
            pageViewController.view.isHidden = true
            pageControl.isHidden = true
        }
    }

    // Arama çubuğunun boş olup olmadığını kontrol eden yöntem.
    private func searchBarIsEmpty() -> Bool {
        if let searchBar = navigationItem.titleView as? UISearchBar, let searchText = searchBar.text {
            return searchText.isEmpty
        }
        return true
    }
 }

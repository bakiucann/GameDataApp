//
//  HomeViewController+SetupViews.swift
//  GameData
//
//  Created by Baki Uçan on 18.07.2023.
//

import UIKit

extension HomeViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        view.addSubview(pageControl)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.reuseIdentifier)
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: pageControl.bottomAnchor)
        collectionView.isHidden = true
        view.addSubview(collectionView)
        pageViewController.delegate = self
    }

    func setupConstraints() {
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
            collectionViewTopConstraint!,

            collectionView.topAnchor.constraint(equalTo: pageControl.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        ])
    }
}

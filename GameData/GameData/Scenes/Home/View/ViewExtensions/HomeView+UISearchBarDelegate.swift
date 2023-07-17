//
//  HomeView+UISearchBarDelegate.swift
//  GameData
//
//  Created by Baki Uçan on 17.07.2023.
//

import UIKit

extension HomeViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            viewModel.filterGames(with: "")
        } else if searchText.count >= 3 {
            isSearching = true
            viewModel.filterGames(with: searchText)
        }
        handleEmptyState()
        collectionView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        collectionViewTopConstraint?.isActive = false
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        collectionViewTopConstraint?.isActive = true
        searchBar.showsCancelButton = true

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            viewModel.filterGames(with: searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()

        collectionViewTopConstraint?.isActive = false
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: pageControl.bottomAnchor)
        collectionViewTopConstraint?.isActive = true

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }

        viewModel.filterGames(with: "")
        collectionView.reloadData()
        isSearching = false
        handleEmptyState()
    }

}


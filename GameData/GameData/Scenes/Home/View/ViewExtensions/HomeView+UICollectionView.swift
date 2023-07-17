//
//  HomeView+UICollectionView.swift
//  GameData
//
//  Created by Baki Uçan on 14.07.2023.
//

import UIKit

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(0, viewModel.filteredGames.count)
    }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseIdentifier, for: indexPath) as! GameCell

      if isSearching {
          let adjustedIndex = indexPath.item
          if adjustedIndex >= 0 && adjustedIndex < viewModel.filteredGames.count {
              cell.configure(with: viewModel.filteredGames[adjustedIndex])
          }
      } else {
          let adjustedIndex = indexPath.item + 3
          if adjustedIndex >= 0 && adjustedIndex < viewModel.filteredGames.count {
              cell.configure(with: viewModel.filteredGames[adjustedIndex])
          }
      }

      return cell
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let itemWidth: CGFloat = (collectionView.bounds.width - padding * 3) / 2
      let itemHeight: CGFloat = itemWidth * 0.9
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

//
//  ViewController.swift
//  FavAlbumsLastFM
//
//  Created by Yasir Perwez on 21/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Moya
import UIKit

// To display album in collection view
final class MainViewController: UIViewController {
  let kCellIdentifier = "MainViewControllerCell"
  let kPadding: CGFloat = 10.0

  @IBOutlet var collectionView: UICollectionView!

  var viewModel: MainViewModelProtocol!
  var transition: ViewControllTransitionAnimationProtocol!

  lazy var searchButtonItem: UIBarButtonItem = {
    UIBarButtonItem(
      barButtonSystemItem: .search,
      target: self,
      action: #selector(searchButtonAction)
    )
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Main"

    viewModel.delegate = self
    viewModel.setUp()

    navigationItem.rightBarButtonItem = searchButtonItem
    navigationController?.delegate = self
  }

//  override func viewDidAppear(_ animated: Bool) {
//    navigationController?.delegate = self
//  }
}

// MARK: - ViewModel delegation

extension MainViewController: MainViewModelDelegate {
  func updateAlbums() {
    if viewModel.savedAlbums?.count ?? 0 == 0 {
      collectionView.reloadData()
      collectionView.setEmptyMessage(Constants.ErrorMessages.noAlbumSaved)

    } else {
      collectionView.clearMessage()
      collectionView.reloadData()
    }
  }
}

// MARK: - CollectionView

extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.savedAlbums?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as! MainCollectionViewCell
    if let savedAlbum = viewModel.savedAlbums?[indexPath.row] as? SavedAlbum {
      cell.setUp(album: savedAlbum)
    } else {
      fatalError("Cell should have been loaded")
    }

    return cell
  }
}

extension MainViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let savedAlbum = viewModel.savedAlbums?[indexPath.row] as? SavedAlbum {
      let vm = AlbumDetailsViewModel(savedAlbum: savedAlbum)
      let vc = AlbumDetailsViewController.makeFromStoryboard(viewModel: vm)

      navigationController?.pushViewController(vc, animated: true)
    }
  }
}

// MARK: - flow layout delegation

extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemSize = collectionView.frame.width - kPadding
    return CGSize(width: itemSize / 2, height: itemSize / 2)
  }
}

// Add button action and its handling
extension MainViewController {
  @objc func searchButtonAction() {
    let vm = SearchArtistViewModel()
    let vc = SearchArtistViewController.makeFromStoryboard(viewModel: vm) 

    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - Creation of MainCollectionViewController with dependency injection

extension MainViewController: StoryboardInitializable {
  static func instantiateFromStoryboard() -> MainViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
  }
}

extension MainViewController {
  static func makeFromStoryboard(
    viewModel: MainViewModelProtocol,
    transition: ViewControllTransitionAnimationProtocol
  ) -> MainViewController {
    let vc = MainViewController.instantiateFromStoryboard()
    vc.setDependencies(viewModel: viewModel, transition: transition)
    return vc
  }

  func setDependencies(
    viewModel: MainViewModelProtocol,
    transition: ViewControllTransitionAnimationProtocol
  ) {
    self.viewModel = viewModel
    self.transition = transition
  }
}

// For displaying detailed view controller with custom animation
extension MainViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    guard
      let selectedCellIndexPath = collectionView.indexPathsForSelectedItems?.first,
      let selectedCell = collectionView.cellForItem(at: selectedCellIndexPath) as? MainCollectionViewCell,
      let selectedCellSuperview = selectedCell.superview
    else {
      return nil
    }

    transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
    transition.originFrame = CGRect(
      x: transition.originFrame.origin.x + 20,
      y: transition.originFrame.origin.y + 20,
      width: transition.originFrame.size.width - 40,
      height: transition.originFrame.size.height - 40
    )

    transition.presenting = true

    return transition
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.presenting = false
    return transition
  }
}

// Enabling custom animation through UINavigationController
extension MainViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) ->
    UIViewControllerAnimatedTransitioning? {
    if operation == .pop && fromVC is AlbumDetailsViewController && toVC is MainViewController {
      return animationController(forDismissed: fromVC)
    } else if toVC is AlbumDetailsViewController && fromVC is MainViewController {
      return animationController(forPresented: toVC, presenting: fromVC, source: fromVC)
    }
    return nil
  }
}

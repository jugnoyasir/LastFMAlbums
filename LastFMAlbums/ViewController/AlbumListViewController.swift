//
//  AlbumListViewController.swift
//  FavAlbumsLastFM
//
//  Created by Yasir Perwez on 21/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import SVProgressHUD
import UIKit

//to display albums for and artist
final class AlbumListViewController: UIViewController {
  var viewModel: AlbumsListViewModelProtocol!
  
  @IBOutlet var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = viewModel.getArtistName()
    navigationItem.largeTitleDisplayMode = .always
    
    viewModel.delegate = self
    viewModel.getTopAlbum()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .none)
  }
}

// MARK: - TableView

extension AlbumListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.albums.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumListTableViewCell", for: indexPath) as! AlbumListTableViewCell
    
    var isSaved = false
    if let url = viewModel.albums[indexPath.row].url {
      isSaved = viewModel.isSaved(url: url)
    }
    cell.setUp(album: viewModel.albums[indexPath.row], isSaved: isSaved)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if (viewModel.albums.count - 1) <= indexPath.row {
      viewModel.getTopAlbum()
    }
  }
}

extension AlbumListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    viewModel.getAlbumInfo(index: indexPath.row)
  }
}

// MARK: - AlbumsListViewModelDelegate

extension AlbumListViewController: AlbumsListViewModelDelegate {
  func startProgress() {
    SVProgressHUD.show(withStatus: "Fetching Album")
  }
  
  func stopProgress() {
    SVProgressHUD.dismiss()
  }
  
  func startLoading() {
    tableView.startLoading()
  }
  
  func stopLoading() {
    tableView.stopLoading()
  }
  
  func albumReceived(savedAlbum: SavedAlbum) {
    let vm = AlbumDetailsViewModel(savedAlbum: savedAlbum)
    let vc = AlbumDetailsViewController.makeFromStoryboard(viewModel: vm)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func updateAlbum() {
    tableView.clearMessage()
    tableView.separatorStyle = .singleLine
    tableView.reloadData()
  }
  
  func receivedError(error: LastFMAlbumsError) {
    switch error {
    case .noNetwork:
      if viewModel.albums.count == 0 {
      tableView.separatorStyle = .none
      tableView.reloadData()
      tableView.setEmptyMessage(Constants.ErrorMessages.noNetwork)
      }else{
        let alert = Utility.createAlert(title: Constants.ErrorMessages.warning, message: Constants.ErrorMessages.noNetwork)
        present(alert, animated: true, completion: nil)
      }
    default:
      let alert = Utility.createAlert(title: Constants.ErrorMessages.warning, message: Constants.ErrorMessages.tryAfterSometime)
      present(alert, animated: true, completion: nil)
    }
  }
}

// MARK: - Creation of AlbumListViewController with dependency injection

extension AlbumListViewController: StoryboardInitializable {
  static func instantiateFromStoryboard() -> AlbumListViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "AlbumListViewController") as! AlbumListViewController
  }
}

extension AlbumListViewController {
  static func makeFromStoryboard(
    viewModel: AlbumsListViewModelProtocol
  ) -> AlbumListViewController {
    let vc = AlbumListViewController.instantiateFromStoryboard()
    vc.setDependencies(viewModel: viewModel)
    return vc
  }
  
  func setDependencies(
    viewModel: AlbumsListViewModelProtocol
  ) {
    self.viewModel = viewModel
  }
}

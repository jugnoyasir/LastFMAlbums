//
//  AlbumDetailsViewController.swift
//  FavAlbumsLastFM
//
//  Created by Yasir Perwez on 21/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import UIKit

// To display details of an album
final class AlbumDetailsViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  var viewModel: AlbumDetailsViewModelProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = viewModel.savedAlbum.name
    navigationItem.largeTitleDisplayMode = .always
    
    if viewModel.isSaved() {
      showRemovedAlbumButton()
    } else {
      showSavedAlbumButton()
    }
  }
  
  func showSavedAlbumButton() {
    let item = UIBarButtonItem(barButtonSystemItem: .add,
                               target: self,
                               action: #selector(saveAlbum))
    navigationItem.rightBarButtonItem = item
  }
  
  func showRemovedAlbumButton() {
    let item = UIBarButtonItem(barButtonSystemItem: .trash,
                               target: self,
                               action: #selector(deleteAlbum))
    navigationItem.rightBarButtonItem = item
  }
  
  @objc func saveAlbum() {
    viewModel.saveAlbum()
    showRemovedAlbumButton()
  }
  
  @objc func deleteAlbum() {
    viewModel.deleteAlbum()
    showSavedAlbumButton()
  }
}

// MARK: - UITableView

extension AlbumDetailsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.savedAlbum.tracks.count + 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 300
    } else {
      return 60
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumDetailsHearderTableViewCell", for: indexPath) as! AlbumDetailsHearderTableViewCell
      cell.setup(savedAlbum: viewModel.savedAlbum)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumDetailsTrackTableViewCell", for: indexPath) as! AlbumDetailsTrackTableViewCell
      cell.setUp(track: viewModel.savedAlbum.tracks[indexPath.row - 1])
      return cell
    }
  }
}

extension AlbumDetailsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
}

// MARK: -  Creation of AlbumListViewController with dependency injection

extension AlbumDetailsViewController: StoryboardInitializable {
  static func instantiateFromStoryboard() -> AlbumDetailsViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "AlbumDetailsViewController") as! AlbumDetailsViewController
  }
}

extension AlbumDetailsViewController {
  static func makeFromStoryboard(viewModel: AlbumDetailsViewModelProtocol) -> AlbumDetailsViewController {
    let vc = AlbumDetailsViewController.instantiateFromStoryboard()
    vc.setDependencies(viewModel: viewModel)
    return vc
  }
  
  func setDependencies(viewModel: AlbumDetailsViewModelProtocol) {
    self.viewModel = viewModel
  }
}

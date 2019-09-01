//
//  SearchArtistViewController.swift
//  FavAlbumsLastFM
//
//  Created by Yasir Perwez on 21/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import UIKit
// View controller for searching artist

final class SearchArtistViewController: UIViewController {
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var tableView: UITableView!
  
  var viewModel: SearchArtistViewModelProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Artist"
    navigationItem.largeTitleDisplayMode = .never
    
    viewModel = SearchArtistViewModel()
    viewModel.delegate = self
  }
}

// MARK: - Table View

extension SearchArtistViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.artists.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchArtistsTableViewCell", for: indexPath) as! SearchArtistsTableViewCell
    
    cell.setUp(artist: viewModel.artists[indexPath.row])
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if (viewModel.artists.count - 1) <= indexPath.row {
      viewModel.fetchNextPage()
    }
  }
}

extension SearchArtistViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let vm = AlbumsListViewModel(artist: viewModel.artists[indexPath.row])
    let vc = AlbumListViewController.makeFromStoryboard(viewModel: vm)
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - SearchArtistViewModelDelegate

extension SearchArtistViewController: SearchArtistViewModelDelegate {
  func scrollToTop() {
    if tableView.numberOfRows(inSection: 0) > 0 {
      tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
  }
  
  func startLoading() {
    tableView.startLoading()
  }
  
  func stopLoading() {
    tableView.stopLoading()
  }
  
  func updateArtist() {
    tableView.clearMessage()
    tableView.separatorStyle = .singleLine
    tableView.reloadData()
  }
  
  func receivedError(error: LastFMAlbumsError) {
    tableView.stopLoading()
    switch error {
    case .noNetwork:
      if viewModel.artists.count == 0 {
        tableView.separatorStyle = .none
        tableView.reloadData()
        tableView.setEmptyMessage(Constants.ErrorMessages.noNetwork)
      } else {
        let alert = Utility.createAlert(title: Constants.ErrorMessages.warning, message: Constants.ErrorMessages.noNetwork)
        present(alert, animated: true, completion: nil)
      }
      
    default:
      let alert = Utility.createAlert(title: Constants.ErrorMessages.warning, message: Constants.ErrorMessages.tryAfterSometime)
      present(alert, animated: true, completion: nil)
    }
  }
}

// MARK: - UISearchBarDelegate

extension SearchArtistViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel?.query = searchText
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    viewModel.fetchArtist()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    searchBar.text = ""
    searchBar.resignFirstResponder()
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.searchBar.showsCancelButton = true
  }
}

// MARK: - Creation with dependency injenction

// Creation of MainCollectionViewController with dependency injection
extension SearchArtistViewController: StoryboardInitializable {
  static func instantiateFromStoryboard() -> SearchArtistViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "SearchArtistViewController") as! SearchArtistViewController
  }
}

extension SearchArtistViewController {
  static func makeFromStoryboard(
    viewModel: SearchArtistViewModelProtocol
  ) -> SearchArtistViewController {
    let vc = SearchArtistViewController.instantiateFromStoryboard()
    vc.setDependencies(viewModel: viewModel)
    return vc
  }
  
  func setDependencies(
    viewModel: SearchArtistViewModelProtocol
  ) {
    self.viewModel = viewModel

  }
}

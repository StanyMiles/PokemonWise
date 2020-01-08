//
//  PokemonListViewController.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class PokemonListViewController: UITableViewController {
  
  // MARK: - Properties
  
  private var dataManager: DataManagerFacade {
    guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("It must be AppDelegate")
    }
    return delegate.dataManager
  }
  
  private var pokemonListItems: [PokemonListItem] = []
  private var selectedIndexPath: IndexPath?
  
  private var currentPage = 1
  private var isLoading = false
  private var hasMoreData = true
  
  // MARK: - UIViewController Lifecycle Funcs
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    setupRefreshControl()
    requestData(forPage: currentPage)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let vc = segue.destination as? PokemonViewController else { return }
    guard let index = selectedIndexPath?.row else { return }
    
    let pokemonListItem = pokemonListItems[index]
    vc.pokemonListItem = pokemonListItem
    vc.dataManager = dataManager
    vc.navigationItem.title = pokemonListItem.name.capitalizingFirstLetter()
    
    selectedIndexPath = nil
  }
  
  // MARK: - Funcs
  
  private func requestData(forPage page: Int) {
    
    if !hasMoreData || isLoading { return }
    isLoading = true
    
    #warning("handle that")
    do {
      _ = try dataManager.requestPokemons(
        forPage: page
      ) { [weak self] result in
        guard let self = self else { return }
        
        self.tableView.refreshControl?.endRefreshing()
        
        switch result {
          
        case .success(let pokemonListItems):
          self.addNew(pokemonListItems)
          
        case .failure(let error):
          #if DEBUG
          print("Failed to load PokemonListItems: ", error)
          #endif
          
          self.hasMoreData = false
          self.isLoading = false
          
          self.tableView.reloadData()
        }
      }
    } catch {
      #if DEBUG
      print("Failed to load PokemonListItems: ", error)
      #endif
      
      self.hasMoreData = false
      self.isLoading = false
      
      self.tableView.reloadData()
    }
  }
  
  private func addNew(_ pokemonListItems: [PokemonListItem]) {
    self.currentPage += 1
    self.isLoading = false
    
    if pokemonListItems.count < 20 {
      self.hasMoreData = false
    }
    
    self.pokemonListItems.append(contentsOf: pokemonListItems)
    
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  private func setupRefreshControl() {
    refreshControl = UIRefreshControl()
    refreshControl?.tintColor = .label
    refreshControl?.addTarget(
      self,
      action: #selector(handleRefresh),
      for: .valueChanged)
  }
  
  @objc private func handleRefresh() {
    pokemonListItems.removeAll()
    hasMoreData = true
    currentPage = 1
    
    tableView.reloadData()
    tableView.refreshControl?.beginRefreshing()
    requestData(forPage: currentPage)
  }
  
}

// MARK: - UITableViewDataSource

extension PokemonListViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return !hasMoreData && pokemonListItems.isEmpty ? 3 : 2
  }
  
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    
    if section == 1 {
      return 1
    } else if section == 2 {
      return !hasMoreData && pokemonListItems.isEmpty ? 1 : 0
    }
    
    return pokemonListItems.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    
    if indexPath.section == 1 {
      // LoaderTableViewCell
      
      let cell = tableView.dequeueReusableCell(
        withIdentifier: CellIdentifier.loaderTableViewCellId,
        for: indexPath) as! LoaderTableViewCell
      
      if isLoading {
        cell.activityIndicatorView.startAnimating()
      } else {
        cell.activityIndicatorView.stopAnimating()
      }
      
      return cell
      
    } else if indexPath.section == 2 {
      // NoDataCell
      
      let cell = tableView.dequeueReusableCell(
        withIdentifier: CellIdentifier.noDataTableViewCellId,
        for: indexPath)
      
      return cell
    }
    
    // PokemonTableViewCell
    let pokemonListItem = pokemonListItems[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: CellIdentifier.pokemonListCellId,
      for: indexPath) as! PokemonTableViewCell
    
    cell.nameLabel.text = pokemonListItem.name.capitalizingFirstLetter()
    
    return cell
  }
}

// MARK: - UITableViewDelegate

extension PokemonListViewController {
  
  override func tableView(
    _ tableView: UITableView,
    willSelectRowAt indexPath: IndexPath
  ) -> IndexPath? {
    selectedIndexPath = indexPath
    return indexPath
  }
  
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    
    if indexPath.section == 1 {
      // LoaderTableViewCell
      let isRefreshing = refreshControl?.isRefreshing ?? false
      return !isRefreshing && self.isLoading ? 100 : 0
      
    } else if indexPath.section == 2 {
      // NoDataCell
      return 500
    }
    
    // PokemonCells
    return 60
  }
}

// MARK: - UITableViewDataSourcePrefetching

extension PokemonListViewController: UITableViewDataSourcePrefetching {
  
  func tableView(
    _ tableView: UITableView,
    prefetchRowsAt indexPaths: [IndexPath]
  ) {
    guard indexPaths.contains(where: { $0.section == 1 }) else { return }
    requestData(forPage: currentPage)
  }
}

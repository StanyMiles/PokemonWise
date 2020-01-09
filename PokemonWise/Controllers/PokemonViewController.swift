//
//  PokemonViewController.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 23.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
  
  // MARK: - Views
  
  public var pokemonView: PokemonView! {
    guard isViewLoaded else { return nil }
    return (view as! PokemonView)
  }
  
  private lazy var activityIndicatorView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView()
    view.tintColor = .label
    view.hidesWhenStopped = true
    navigationItem.titleView = view
    return view
  }()
  
  // MARK: - Parameters
  
  var pokemonListItem: PokemonListItem!
  var dataManager: DataManagerFacade!
  
  private var pokemonViewModel: PokemonViewModel? {
    didSet {
      pokemonViewModel?.setupViews()
    }
  }
  
  private var dataTask: URLSessionDataTask?
  
  // MARK: - UIViewController Lifecycle Funcs
  
  override func viewDidLoad() {
    super.viewDidLoad()
    assert(pokemonListItem != nil, "pokemonUrlString must be set before initialization")
    assert(dataManager != nil, "dataManager must be set before initialization")
    
    navigationController?.navigationBar.prefersLargeTitles = true
    
    prepareViews()
    requestPokemon(forURLString: pokemonListItem.urlString)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    dataTask?.cancel()
    dataTask = nil
  }
  
  // MARK: - Funcs
  
  private func requestPokemon(forURLString urlString: String) {
    guard let url = URL(string: urlString) else { return }
    
    activityIndicatorView.startAnimating()
    
    dataTask = dataManager.requestPokemon(
      withURL: url
    ) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .success(let pokemon):

        DispatchQueue.main.async {

          let viewModel = PokemonViewModel(
            pokemon: pokemon,
            pokemonView: self.pokemonView,
            dataManagerFacade: self.dataManager)

          self.pokemonViewModel = viewModel
          self.activityIndicatorView.stopAnimating()
        }

      case .failure(let error):
        #if DEBUG
        print("Failed to load Pokemon:", error)
        #endif

        DispatchQueue.main.async {
          self.presentNoDataView()
          self.activityIndicatorView.stopAnimating()
        }
      }
    }
  }
  
  private func prepareViews() {
    pokemonView.subviews.forEach { $0.alpha = 0 }
  }
  
  private func presentNoDataView() {
    let noDataLabel = UILabel()
    noDataLabel.text = """
    Failed to load Pokemon.
    Please check your internet connection.
    """
    noDataLabel.font = .italicSystemFont(ofSize: 17)
    noDataLabel.textColor = .systemGray
    noDataLabel.numberOfLines = 2
    noDataLabel.textAlignment = .center
    noDataLabel.alpha = 0
    
    pokemonView.addSubview(noDataLabel)
    noDataLabel.centerIn(pokemonView, yConstant: -200)
    
    UIView.animate(withDuration: 0.3) {
      noDataLabel.alpha = 1
    }
  }
}

//
//  ViewController.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import UIKit

protocol ListViewProtocol: AnyObject {
    func initializeSnapshot(with pokemons: [Pokemon])
}

final class ListViewController: UIViewController {
    
    // MARK: Types
    
    private enum Constants {
        static let navigationItemTitle = "Pokemons"
    }
    
    // MARK: Public Properties
    
    var presenter: ListPresenterProtocol?
    
    // MARK: Private Properties
    // UICollectionView
    
    private lazy var pokemonCollectionView = createListCollectionView()
    private lazy var dataSource = createDiffableDataSource()
    private var snapshot: NSDiffableDataSourceSnapshot<Section, Item>?

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        initialise()
        presenter?.viewDidLoaded()
    }
    
    // MARK: Private Methods
    
    private func initialise() {
        view.backgroundColor = .white
        self.navigationItem.title = Constants.navigationItemTitle
        
        view.addSubview(pokemonCollectionView)
        pokemonCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pokemonCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            pokemonCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pokemonCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pokemonCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
     
}

// MARK: - ListViewProtocol

extension ListViewController: ListViewProtocol {

    // UICollectionView
    
    func initializeSnapshot(with pokemons: [Pokemon]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.pokemonList])
        snapshot.appendItems(pokemons.map { Item.pokemon($0) }, toSection: .pokemonList)
        dataSource.apply(snapshot)
        self.snapshot = snapshot
    }

}

// MARK: - UICollectionView

extension ListViewController {
    
    // MARK: Types
    
    private enum Section: Hashable {
        case pokemonList
    }
    
    private enum Item: Hashable {
        case pokemon(Pokemon)
    }
    
    // MARK: Private Methods
    
    private func createListLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func createListCollectionView() -> UICollectionView {
        let collectionViewLayout = createListLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        return collectionView
    }
    
    private func createListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Pokemon> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Pokemon> { cell, indexPath, pokemon in
            var contentConfiguration = UIListContentConfiguration.valueCell()
            contentConfiguration.text = "\(pokemon.id) \(pokemon.name)"
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.disclosureIndicator()]
        }
    }
    
    private func createDiffableDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let cellRegistration = createListCellRegistration()
        return UICollectionViewDiffableDataSource<Section, Item>(collectionView: pokemonCollectionView) {
            collectionView, indexPath, item in
            switch item {
            case .pokemon(let pokemon):
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: pokemon)
            }
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .pokemon(let pokemon):
            presenter?.didTapPokemon(pokemon: pokemon)
        }
    }
}

//
//  DetailViewController.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    func showImage(image: UIImage?)
}

final class DetailViewController: UIViewController {
    
    // MARK: Public Properties
    
    var presenter: DetailPresenterProtocol?
    
    // MARK: Private Properties
    
    private let stackView = UIStackView.makeVerticalStackView(
        spacing: 8.0,
        alignment: .leading,
        distribution: .equalSpacing
    )
    
    private let imageView = UIImageView.makeImageView(
        width: 96.0,
        height: 96.0,
        contentMode: .scaleAspectFit,
        cornerRadius: 3.0,
        clipsToBounds: true
    )
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoaded()
        initialise()
    }
    
    // MARK: Private Methods
    
    private func initialise() {
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor)
        ])
        
        stackView.addArrangedSubview(imageView)
    }
    
}

// MARK: - DetailViewProtocol

extension DetailViewController: DetailViewProtocol {
    
    // MARK: Public Methods
    
    func showImage(image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = image
        }
    }
    
}

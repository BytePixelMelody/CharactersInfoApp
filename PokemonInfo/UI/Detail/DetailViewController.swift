//
//  DetailViewController.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    func showDetail(name: String, image: UIImage?, type: String, weightKg: String, height: String)
}

final class DetailViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let navigationItemTitle  = "Pokemon details"
        
        static let stackViewSpacing = 8.0
        static let stackViewAlignment = UIStackView.Alignment.center
        static let stackViewDistribution = UIStackView.Distribution.equalSpacing
        
        static let imageViewContentMode = UIView.ContentMode.scaleAspectFit
        static let imageViewCornerRadius = 3.0
        static let imageViewClipsToBounds = true
        
        static let namePrefix = "Name: "
        static let typePrefix = "Types: "
        static let weightPrefix = "Weight: "
        static let weightSuffix = " kg"
        static let heightMeasurePrefix = "Height: "
        static let heightMeasureSuffix = " cm"
    }
    
    // MARK: Public Properties
    
    var presenter: DetailPresenterProtocol?
    
    // MARK: Private Properties
    
    private let stackView = UIStackView.makeVerticalStackView(
        spacing: Constants.stackViewSpacing,
        alignment: Constants.stackViewAlignment,
        distribution: Constants.stackViewDistribution
    )
    
    private let nameLabel = UILabel(frame: .zero)
    private let imageView = UIImageView.makeImageView(
        contentMode: Constants.imageViewContentMode,
        cornerRadius: Constants.imageViewCornerRadius,
        clipsToBounds: Constants.imageViewClipsToBounds
    )
    private let typeLabel = UILabel(frame: .zero)
    private let weightLabel = UILabel(frame: .zero)
    private let heightLabel = UILabel(frame: .zero)
    
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
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor)
        ])
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0)
        ])
        
        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(weightLabel)
        stackView.addArrangedSubview(heightLabel)
    }
    
}

// MARK: - DetailViewProtocol

extension DetailViewController: DetailViewProtocol {
    
    // MARK: Public Methods
    
    func showDetail(name: String, image: UIImage?, type: String, weightKg: String, height: String) {
        nameLabel.text = Constants.namePrefix + name
        imageView.image = image
        typeLabel.text = Constants.typePrefix + type
        weightLabel.text = Constants.weightPrefix + weightKg + Constants.weightSuffix
        heightLabel.text = Constants.heightMeasurePrefix + height + Constants.heightMeasureSuffix
    }
    
}

//
//  DetailViewController.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    @MainActor
    func showDetail(name: String, image: UIImage?, type: String, weight: String, height: String)
}

final class DetailViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let navigationItemTitle  = "Pokemon details"
        
        static let stackViewSpacing = 8.0
        static let stackViewAlignment = UIStackView.Alignment.leading
        static let stackViewDistribution = UIStackView.Distribution.equalSpacing
        
        static let imageViewWidth = 96.0
        static let imageViewHeight = 96.0
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
        width: Constants.imageViewWidth,
        height: Constants.imageViewHeight,
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
        
        Task {
            await presenter?.viewDidLoaded()
        }
        
        initialise()
    }
    
    // MARK: Private Methods
    
    private func initialise() {
        self.navigationItem.title = Constants.navigationItemTitle 
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor)
        ])
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(weightLabel)
        stackView.addArrangedSubview(heightLabel)
    }
    
}

// MARK: - DetailViewProtocol

extension DetailViewController: DetailViewProtocol {
    
    // MARK: Public Methods
    
    @MainActor
    func showDetail(name: String, image: UIImage?, type: String, weight: String, height: String) {
        nameLabel.text = Constants.namePrefix + name
        imageView.image = image
        typeLabel.text = Constants.typePrefix + type
        weightLabel.text = Constants.weightPrefix + weight + Constants.weightSuffix
        heightLabel.text = Constants.heightMeasurePrefix + height + Constants.heightMeasureSuffix
    }
    
}

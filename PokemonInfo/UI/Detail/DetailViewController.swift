//
//  DetailViewController.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    func showDetails(name: String, imageData: Data?, type: String, weightKg: String, height: String)
    func showDetailsImage(imageData: Data?)
}

final class DetailViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let navigationItemTitle  = "Details"
        
        static let stackViewSpacing = 8.0
        static let stackViewAlignment = UIStackView.Alignment.center
        static let stackViewDistribution = UIStackView.Distribution.equalSpacing
        static let stackViewTopOffset = 8.0
        
        static let imageViewContentMode = UIView.ContentMode.scaleAspectFit
        static let imageViewCornerRadius = 3.0
        static let imageViewClipsToBounds = true
        static let imageViewWidthAnchorMultiplier = 0.5
        static let imageViewHeightToWidthMultiplier = 1.0
        
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
    
    private let scrollView = UIScrollView.makeScrollView()
    private let stackView = UIStackView.makeVerticalStackView(
        spacing: Constants.stackViewSpacing,
        alignment: Constants.stackViewAlignment,
        distribution: Constants.stackViewDistribution
    )
    
    private let nameLabel = UILabel.makeLabel(textStyle: .headline)
    private let imageView = UIImageView.makeImageView(
        contentMode: Constants.imageViewContentMode,
        cornerRadius: Constants.imageViewCornerRadius,
        clipsToBounds: Constants.imageViewClipsToBounds
    )
    private let typeLabel = UILabel.makeLabel(textStyle: .body)
    private let weightLabel = UILabel.makeLabel(textStyle: .body)
    private let heightLabel = UILabel.makeLabel(textStyle: .body)
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialise()
        presenter?.viewDidLoaded()
    }
    
    // MARK: Private Methods
    
    private func initialise() {
        view.backgroundColor = .systemBackground
        self.navigationItem.title = Constants.navigationItemTitle
        self.navigationItem.largeTitleDisplayMode = .never

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // frameLayoutGuide
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            // contentLayoutGuide
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor, 
                constant: Constants.stackViewTopOffset
            ),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
        ])
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(
                equalTo: stackView.widthAnchor,
                multiplier: Constants.imageViewWidthAnchorMultiplier
            ),
            imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor,
                multiplier: Constants.imageViewHeightToWidthMultiplier
            )
        ])
        
        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(weightLabel)
        stackView.addArrangedSubview(heightLabel)
    }
    
}

// MARK: - DetailViewProtocol

extension DetailViewController: DetailViewProtocol {
    
    // MARK: Public Methods
    
    func showDetails(name: String, imageData: Data?, type: String, weightKg: String, height: String) {
        nameLabel.text = Constants.namePrefix + name
        if let imageData {
            imageView.image = UIImage(data: imageData)
        }
        typeLabel.text = Constants.typePrefix + type
        weightLabel.text = Constants.weightPrefix + weightKg + Constants.weightSuffix
        heightLabel.text = Constants.heightMeasurePrefix + height + Constants.heightMeasureSuffix
    }  
    
    func showDetailsImage(imageData: Data?) {
        guard let imageData else { return }
        imageView.image = UIImage(data: imageData)
    }
    
}

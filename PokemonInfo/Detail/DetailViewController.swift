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

class DetailViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet var imageView: UIImageView!
    
    // MARK: Public Properties
    
    var presenter: DetailPresenterProtocol?

    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoaded()
        initialise()
    }
    
    // MARK: Private Methods
    
    func initialise() {
        
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

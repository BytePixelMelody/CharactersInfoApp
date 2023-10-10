//
//  ViewController.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 09.10.2023.
//

import UIKit

protocol WelcomeViewProtocol: AnyObject {
    func showDate(date: String)
    func showWeather(temperature: String)
}

class WelcomeViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
    // MARK: Public Properties
    
    var presenter: WelcomePresenterProtocol?
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoaded()
    }

}

// MARK: - WelcomeViewProtocol

extension WelcomeViewController: WelcomeViewProtocol {
    
    // MARK: Public Methods
    
    func showDate(date: String) {
        DispatchQueue.main.async { [weak self] in
            self?.dateLabel.text = date
        }
    }
    
    func showWeather(temperature: String) {
        DispatchQueue.main.async { [weak self] in
            self?.temperatureLabel.text = temperature
        }
    }

}

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
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
    var presenter: WelcomePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoaded()
    }

}

extension WelcomeViewController: WelcomeViewProtocol {
    
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

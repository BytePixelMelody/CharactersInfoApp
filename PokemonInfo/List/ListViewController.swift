//
//  ViewController.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 09.10.2023.
//

import UIKit

protocol ListViewProtocol: AnyObject {
    func showDate(date: String)
    func showWeather(temperature: String)
}

class ListViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
    // MARK: Public Properties
    
    var presenter: ListPresenterProtocol?
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoaded()
    }
    
    // MARK: IBAction
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        presenter?.didTapDetails()
    }
    
}

// MARK: - ListViewProtocol

extension ListViewController: ListViewProtocol {
    
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

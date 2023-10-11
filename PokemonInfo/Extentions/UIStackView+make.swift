//
//  UIStackView+make.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023.
//

import UIKit

extension UIStackView {

    static func makeVerticalStackView(
        spacing: Double = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill
    ) -> UIStackView {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        return stackView
    }
    
}

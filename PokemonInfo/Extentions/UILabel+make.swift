//
//  UILabel+make.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 17.10.2023.
//

import UIKit

extension UILabel {

    static func makeLabel(
        textStyle: UIFont.TextStyle = .body,
        text: String? = nil
    ) -> UILabel {
        let label = UILabel(frame: .zero)
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: textStyle)
        return label
    }
    
}

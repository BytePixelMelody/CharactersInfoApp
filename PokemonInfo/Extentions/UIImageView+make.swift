//
//  UIImage+make.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023.
//

import UIKit

extension UIImageView {

    static func makeImageView(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        contentMode: UIView.ContentMode? = nil,
        cornerRadius: Double = 0,
        clipsToBounds: Bool = false
    ) -> UIImageView {
        let imageView = UIImageView(frame: .zero)

        if let width, let height {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: width),
                imageView.heightAnchor.constraint(equalToConstant: height)
            ])
        }

        if let contentMode {
            imageView.contentMode = contentMode
        }

        imageView.layer.cornerRadius = cornerRadius
        
        imageView.clipsToBounds = clipsToBounds

        return imageView
    }

}

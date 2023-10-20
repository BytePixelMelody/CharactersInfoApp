//
//  UIScrollView+make.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 20.10.2023.
//

import UIKit

extension UIScrollView {

    static func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }

}

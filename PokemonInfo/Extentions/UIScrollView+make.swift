//
//  UIScrollView+make.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023.
//

import UIKit

extension UIScrollView {

    static func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        // hide keyboard on any scroll gesture
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }

}

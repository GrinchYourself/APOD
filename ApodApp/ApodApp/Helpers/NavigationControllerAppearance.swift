//
//  NavigationControllerAppearance.swift
//  ApodApp
//
//  Created by Grinch on 17/12/2022.
//

import UIKit
import DesignSystem

class MainNavigationController: UINavigationController {

    override var navigationBar: UINavigationBar {
        let bar = super.navigationBar
        bar.tintColor = Color.primary
        return bar
    }

}

struct Appearance {
    var navigationAppearance: UINavigationBarAppearance = {
        let standard = UINavigationBarAppearance()

        standard.configureWithOpaqueBackground()

        standard.backgroundColor = Color.background
        standard.titleTextAttributes = [.foregroundColor: Color.primary,
                                        .font: UIFont.preferredFont(forTextStyle: .title2)]

        let button = UIBarButtonItemAppearance(style: .plain)
        button.normal.titleTextAttributes = [.foregroundColor: Color.primary]
        standard.buttonAppearance = button

        let back = UIBarButtonItemAppearance(style: .plain)
        back.normal.titleTextAttributes = [.foregroundColor: Color.primary]
        standard.backButtonAppearance = back

        return standard
    }()
}

//
//  Extentions.swift
//  FileManagement
//
//  Created by Дмитрий Никоноров on 07.07.2022.
//

import Foundation
import UIKit

extension UIView {
    func toAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0)}
    }
}

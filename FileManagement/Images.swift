//
//  Images.swift
//  FileManagement
//
//  Created by Дмитрий Никоноров on 07.07.2022.
//

import Foundation
import UIKit

struct ImagesProviger{
    static func get() -> [UIImage] {
        let imagesInString: [String] = [
                "photo1", "photo2", "photo3", "photo4", "photo5", "photo6", "photo7", "photo8", "photo9", "photo10", "photo11", "photo12", "photo13", "photo14", "photo1", "photo2", "photo3", "photo4", "photo5", "photo6", "photo7", "photo8", "photo9", "photo10", "photo11", "photo12", "photo13", "photo14", "photo15", "photo16", "photo17"
            ]
        var arrayOfImages: [UIImage] = []

        imagesInString.forEach {
            arrayOfImages.append(UIImage(named: $0) ?? UIImage())
        }
        return arrayOfImages
    }
}


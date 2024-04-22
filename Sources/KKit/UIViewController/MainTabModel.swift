//
//  File.swift
//  
//
//  Created by Krishna Venkatramani on 23/04/2024.
//

import UIKit

public struct MainTabModel: Equatable {
    public let name: String
    public let iconName: ImageSource

    public init(name: String, iconName: ImageSource) {
        self.name = name
        self.iconName = iconName
    }
    
    public static func == (lhs: MainTabModel, rhs: MainTabModel) -> Bool {
        lhs.name == rhs.name
    }
}

public extension MainTabModel {
    var tabImage: UIImage {
        let imgView = UIImageView()
        switch iconName {
        case .asset(let asset):
            imgView.image = asset.image
        case .local(let img):
            imgView.image = img
        case .symbol(let name):
            imgView.image = .init(systemName: name)
        default:
            break
        }
        imgView.frame = .init(origin: .zero, size: .init(squared: 24))
        imgView.contentMode = .scaleAspectFit
        return imgView.snapshot
    }

    var tabBarItem: UITabBarItem {
        return .init(title: name, image: tabImage, selectedImage: tabImage)
    }
}

extension UIViewController {
   
}

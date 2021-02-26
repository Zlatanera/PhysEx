//
//  MainScreenSettings.swift
//  PhysicEx
//
//  Created by User on 29.09.2020.
//

import Foundation
import Combine

enum Screen {
    case menu
    case arhimed
    case friction
}

class MainScreenSettings: ObservableObject {
    
    public static let shared = MainScreenSettings()
    
    @Published var screen: Screen = .menu
    
}

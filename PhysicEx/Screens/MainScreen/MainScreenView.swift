//
//  MainScreenView.swift
//  PhysicEx
//
//  Created by User on 29.09.2020.
//

import SwiftUI

struct MainScreenView: View {
    
    @EnvironmentObject var settings: MainScreenSettings // оболочка для наблюдаемого объекта
    
    var body: some View {
        ContainerView().environmentObject(settings)
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}

struct ContainerView: View {
    
    @EnvironmentObject var settings: MainScreenSettings
    
    var body: some View {
        switch settings.screen {
            case .menu: return AnyView(MenuScreenView().environmentObject(settings))
            case .arhimed: return AnyView(ArhimedScreenView().environmentObject(settings))
            case .friction: return AnyView(FrictionScreenView().environmentObject(settings))

        }
    }
}

//
//  MenuScreenView.swift
//  PhysicEx
//
//  Created by User on 29.09.2020.
//

import SwiftUI

struct MenuScreenView: View {
    
    @EnvironmentObject var settings: MainScreenSettings
    
    var body: some View {
        VStack {
            Button {
                settings.screen = .arhimed
            } label: {
                Text("Arhimed")
                    .padding()
            }
            
            Button {
                settings.screen = .friction
            } label: {
                Text("Friction")
                    .padding()
            }

            Text("Menu Screen")
        }
    }
}

struct MenuScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MenuScreenView()
    }
}

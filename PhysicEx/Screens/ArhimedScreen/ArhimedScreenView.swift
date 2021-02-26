//
//  ArhimedScreenView.swift
//  PhysicEx
//
//  Created by User on 29.09.2020.
//

import SwiftUI

struct ArhimedScreenView: View {
    
    @EnvironmentObject var settings: MainScreenSettings
    
    @ObservedObject private var intent = ArhimedScreenIntent.shared
    
    @State private var isShowSettings: Bool = false
    
    var body: some View {
        ZStack {

            VStack {
                
                HStack {
                    Button {
                        intent.clear()
                        settings.screen = .menu
                    } label: {
                        Text("Back Menu")
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }
            
            VStack {
                Rectangle()
                    .frame(width: intent.scaledCubSize, height: intent.scaledCubSize)
                    .foregroundColor(.red)
                    .offset(x: intent.offSet.x, y: intent.offSet.y)
                    .onTapGesture {
                        self.intent.start()
                    }
                Spacer()
            }
            VStack {
                Spacer()
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: intent.liquidLevel)
                    .foregroundColor(Color.blue.opacity(0.5))
                    
            }
        }
        .onAppear(perform: {
            intent.setup()
        })
        .sheet(isPresented: $isShowSettings) {
            self.isShowSettings = false
        } content: {
            ArhimedTestDataView(testData: $intent.testData)
        }
        .onLongPressGesture {
            self.isShowSettings = true
        }
    }
}

struct ArhimedScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ArhimedScreenView()
    }
}

struct ArhimedTestDataView: View {
    
    @Binding var testData: ArhimedScreen.ExperimentData
    
    @State private var cubSize: String = ""
    @State private var cubMass: String = ""
    @State private var densityLiquid: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Cube Size")
                TextField("", text: $cubSize)
            }
            HStack {
                Text("Cube Mass")
                TextField("", text: $cubMass)
            }
            HStack { 
                Text("Density Liquid")
                TextField("", text: $densityLiquid)
            }
        }
        .onDisappear {
            self.testData = ArhimedScreen.ExperimentData(
                cubSize: CGFloat(Double(cubSize) ?? 0.8 ),
                cubMass: CGFloat(Double(cubMass) ?? 1.0 ),
                densityLiquid: CGFloat(Double(densityLiquid) ?? 1000.0 )
)
        }
    }
}

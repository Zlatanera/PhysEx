//
//  FrictionScreenView.swift
//  PhysicEx
//
//  Created by User on 29.09.2020.
//

import SwiftUI

struct FrictionScreenView: View {
    
    @EnvironmentObject var settings: MainScreenSettings
    
    @ObservedObject private var intent = FrictionScreenIntent.shared // Комбайн, подписка на объект, который передает сюда данные
    
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
                    .frame(width: 50, height: 50)
                    .position(x: intent.xPosition, y: UIScreen.main.bounds.height / 3 * 2 - 25)
                    .foregroundColor(Color.yellow.opacity(0.5))
                    .onTapGesture { // запуск по тапу на экран
                        intent.start()
                    }
                    
            }
            
            VStack {
                
                Spacer()
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
                    .foregroundColor(Color.black.opacity(0.5))
                
            }
            
          
        }
        
        .ignoresSafeArea(.all) // Отключение безопасных зон на дисплее смартфона
        
        .onAppear(perform: {
            intent.setup()
        })
        .sheet(isPresented: $isShowSettings) { // выскакивающая панель
            self.isShowSettings = false
        } content: {
            FrictionTestDataView(testData: $intent.testData)
        }
        .onLongPressGesture {
            self.isShowSettings = true
        }
    }
}
     
struct FrictionScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FrictionScreenView()
    }
}

struct FrictionTestDataView: View {
    
    @Binding var testData: FrictionScreen.ExperimentData // Соединение с другим файлом
    
    @State private var massObject: String = ""
    @State private var coefOfFriction: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Mass Object")
                TextField("", text: $massObject)
            }
            HStack {
                Text("Coef of Friction")
                TextField("", text: $coefOfFriction)
            }
        }
        .onDisappear {
            self.testData = FrictionScreen.ExperimentData(
                massObject: CGFloat(Double(massObject) ?? 1.0 ),
                coefOfFriction: CGFloat(Double(coefOfFriction) ?? 0.3 )
)
            }
        }

}


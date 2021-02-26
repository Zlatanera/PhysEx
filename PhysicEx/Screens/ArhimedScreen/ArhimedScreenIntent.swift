//
//  ArhimedScreenIntent.swift
//  PhysicEx
//
//  Created by User on 29.09.2020.
//

import Foundation
import Combine
import CoreGraphics
import SwiftUI

class ArhimedScreenIntent: ObservableObject {
    
    public static let shared = ArhimedScreenIntent()
    
    @Published var testData: ArhimedScreen.ExperimentData = ArhimedScreen.ExperimentData(cubSize: .zero, cubMass: .zero, densityLiquid: .zero)
    @Published var offSet: CGPoint = .zero
    @Published var liquidLevel: CGFloat = UIScreen.main.bounds.height/2
    @Published var scaledCubSize: CGFloat = 50
    
    private var worker =  ArhimedScreenWorker()
    private var cancellables: [AnyCancellable] = []
    private var animationTimer: Timer?
    
    func setup () {
        setupBindings()
    }
    
    func start () {
        doCalc(hasTimer: animationTimer != nil)
    }
    
    func clear() {
        clearCancellables()
    }
    
    private func clearCancellables() {
        cancellables.forEach({ $0.cancel() })
        cancellables = []
    }
    
    private func setupBindings() {
        let testDataCancellable = $testData
            .sink { (data) in
                self.worker.doInitialSettings(cubSize: data.cubSize, cubMass: data.cubMass, densityLiquid: data.densityLiquid, screenSize: UIScreen.main.bounds.size) { (scaledCubSize) in
                    self.scaledCubSize = scaledCubSize
                }
            }
        cancellables.append(testDataCancellable)
    }
    
    private func fire(timer: inout Timer?, for interval: Float = 1.0, invalidate: Bool, selector: Selector? = nil) {
      if invalidate {
        timer?.invalidate()
        timer = nil
      } else {
        if let selector = selector, timer == nil {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: selector, userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
        }
      }
    }
    
    private func doCalc(hasTimer: Bool) {
        self.fire(timer: &animationTimer, for: 0.01, invalidate: hasTimer, selector: #selector(updateAnimation))
    }
    @objc func updateAnimation() {
        let newLevelData = worker.RunSystem()
        offSet = CGPoint(x: offSet.x, y: newLevelData.cubLevel - scaledCubSize/2) 
        liquidLevel = newLevelData.waterLevel
    }

    
}

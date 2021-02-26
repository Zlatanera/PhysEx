//
//  FrictionScreenIntent.swift
//  PhysicEx
//
//  Created by User on 29.09.2020.
//

import Foundation
import Combine
import CoreGraphics
import SwiftUI
import CoreMotion.CMDeviceMotion

class FrictionScreenIntent: ObservableObject { // Комбайн, издатель, отсюда прокидываются подписки
    
    public static var shared = FrictionScreenIntent()
    
    @Published var testData: FrictionScreen.ExperimentData = FrictionScreen.ExperimentData(massObject: .zero, coefOfFriction: .zero) // прописываются свойства
    
    @Published var xPosition = UIScreen.main.bounds.width / 2
    
    private let worker =  FrictionScreenWorker()
    private var cancellables: [AnyCancellable] = []
    private let motion = MotionManager.shared
    private var animationTimer: Timer?
    
    
    

    
    func setup () {
        motion.startUpdate()
        setupBindings()
    }
    
    func clear() {
        clearCancellables()
    }
    
    private func clearCancellables() {
        cancellables.forEach({ $0.cancel() })
        cancellables = []
    }
    
    func start () {
        doCalc(hasTimer: animationTimer != nil)
    }
    
    private func setupBindings() {
        let testDataCancellable = $testData
            .sink { (data) in // Подключает подписчика к издателю, Комбайн
                self.worker.doInitialSettings(massObject: data.massObject, coefFriction: data.coefOfFriction)
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
        self.fire(timer: &animationTimer, for: 0.1, invalidate: hasTimer, selector: #selector(updateAnimation))
    }
    
    @objc func updateAnimation() {
        if let motionData = motion.getMotionData() {
            worker.runSystem(motionData: motionData) { dx in
                let newX = self.xPosition + dx //dx * 10
                switch true {
                case newX < 25: self.xPosition = 25
                case newX > UIScreen.main.bounds.width - 25: self.xPosition = UIScreen.main.bounds.width - 25
                default: self.xPosition = newX
                }
            }
        }
    }

    
}




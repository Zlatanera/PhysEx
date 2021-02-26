//
//  FrictionScreenWorker.swift
//  PhysicEx
//
//  Created by User on 12.10.2020.
//

import CoreGraphics
import CoreMotion.CMDeviceMotion

class FrictionScreenWorker {
    
    private var massObject: CGFloat = 0 //масса объекта
    private var coefFriction: CGFloat = 0  //  коэфициент трения
    private let accelerationOfGravity: CGFloat = 9.8 //
    private var speed: CGFloat = 10 //скорость передвижения объекта
    private var valueX: CGFloat = 0  // изменение по иксу
    private var powerFriction: CGFloat = 0 // сила трения
    
    private var changeFriction: FrictionScreen.Coef = FrictionScreen.Coef(power: .zero)
    
    func doInitialSettings(massObject: CGFloat, coefFriction: CGFloat) {
        
        self.massObject = massObject
        self.coefFriction = coefFriction
        
        calculateFrictionPower()
        
//        speed = 0
//        valueX = 0
        
        
    }
    
    private func calculateFrictionPower() {
        powerFriction = coefFriction * (massObject * accelerationOfGravity)
    }
    
//    func calculateSpeed() {
//
//    }
    
    func runSystem(motionData: CMDeviceMotion, completion: ( (CGFloat) -> Void )? = nil ) { // присоединяем датчики и выводим значения в формулу
        print(motionData.gravity.x)
        completion?(CGFloat(motionData.gravity.x) * powerFriction)
        print(powerFriction)
        
    }
    
    
    
    
    
}

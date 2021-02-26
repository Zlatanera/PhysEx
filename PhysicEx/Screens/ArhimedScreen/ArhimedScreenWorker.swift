//
//  ArhimedScreenWorker.swift
//  PhysicEx
//
//  Created by User on 07.10.2020.
//

import CoreGraphics

class ArhimedScreenWorker {

    private var scaleCoefXY: CGPoint = .zero
    private var screenSize: CGSize = .zero
    private var cubSize: CGFloat = 0
    private var cubMass: CGFloat = 0 //В килограммах
    private var vCub: CGFloat = 0 //Вычисляем объём куба
    private var densityLiquid: CGFloat = 0
    private var densityCub: CGFloat = 0  //Плотность куба
    private let dt: CGFloat = 0.0001
    private let TankHeight: CGFloat = 10 //В метрах
    private var TankHeightScreen: CGFloat = 0 //Экранная высота
    private let TankWidth: CGFloat = 4 //В метрах
    private var TankWidthScreen: CGFloat = 0 //Экранная ширина
    private var TankDepth: CGFloat = 0.0 //В метрах
    private var TankBottomArea: CGFloat = 0  // Площадь основания
    private let LiquidLevelBase: CGFloat = 5 // Начальный уровень воды
    private var LiquidLevelMax: CGFloat = 0 // Максимальный уровень воды

    private var V0: CGFloat = 0
    private var typ: CGFloat = 0
    private var y: CGFloat = 3 // 0
    private var t: CGFloat = 0
    private var oldLiquidY: CGFloat = 0
    private var dl: CGFloat = 0
    private var L: CGFloat = 0
    
    private var CalcOutsideLiquid: Bool = false

    func doInitialSettings (cubSize: CGFloat, cubMass: CGFloat, densityLiquid: CGFloat, screenSize: CGSize, completion: @escaping (CGFloat) -> ()) {
        self.cubMass = cubMass
        self.vCub = cubSize*cubSize*cubSize
        self.densityLiquid = densityLiquid
        self.densityCub = vCub/cubMass
        self.TankHeightScreen = TankHeight * 100
        self.TankWidthScreen = TankWidth * 100
        self.TankDepth = cubSize + 0.1
        self.TankBottomArea = TankWidth * TankDepth
        self.LiquidLevelMax = (vCub + TankBottomArea * LiquidLevelBase)/TankBottomArea
        self.cubSize = cubSize
        self.screenSize = screenSize
        self.scaleCoefXY = CGPoint(x:screenSize.width / TankWidth,y:screenSize.height / TankHeight)
        t = dt
        V0 = 0
        typ = 6
        y = 3 // CubSize/2
        oldLiquidY = LiquidLevelBase
        dl = 0.1
        L = 0
        CalcOutsideLiquid = false
        completion(cubSize * scaleCoefXY.x)
    }
    
    private func calcNewLiquidLevel(newY: CGFloat)->CGFloat {
        if (newY - cubSize/2) < LiquidLevelBase {
            
            if (newY + cubSize/2) <= LiquidLevelBase {
                    
                        return LiquidLevelMax
            }
                else
                {
                        return ((LiquidLevelBase - (newY - cubSize/2)) + TankBottomArea * LiquidLevelBase)/TankBottomArea
                }
        }
        else
        {
                return LiquidLevelBase;
        }

    }

 

    private func CalcObjectPositionInsideLiquid(oldY: CGFloat) {
        
        L = oldY+dl
        dl = V0*t-9.8*((densityLiquid*densityCub)-1)*t*t/2; //изменение положения куба с учетом ускорения
        V0 = V0+9.8*((densityLiquid*densityCub)-1)*t; //изменение скорости движения
        if L>8 { dl = V0*t-9.8*((densityLiquid*densityCub)-1)*t*t/2 } //ускорение куба вне среды
        if L>8 { V0 = V0-9.8*2*((3*densityLiquid*densityCub)-1)*t } //изменение скорости вне среды
        if L>9 { CalcOutsideLiquid = true }
        if L<0 { L = 0 } //дно
        y = oldY + dl
    }
    

    private func CalcObjectPositionOutsideLiquid() {
       
        if CalcOutsideLiquid {
            if y<typ { dl = V0*t-9.8*((densityLiquid*densityCub)-1)*t*t/2 } //движение после вылета из среды
            if L<typ { V0 = V0+9.8*((densityLiquid*densityCub)-1)*t } //изменение скорости движения
        }
        
    }
    

    private func CalcObjectPosition() {
        CalcObjectPositionOutsideLiquid()
        CalcObjectPositionInsideLiquid(oldY: y)
    }
    
    
    func RunSystem() -> ArhimedScreen.LevelCubWater {
    CalcObjectPosition()
        let newWaterLevel = calcNewLiquidLevel(newY: y)
        print("newWaterLevel \(newWaterLevel)")
        let levels = ArhimedScreen.LevelCubWater(
            cubLevel: screenSize.height - y * scaleCoefXY.y,
            waterLevel: calcNewLiquidLevel(newY: y) * scaleCoefXY.y
        )
        return levels
    }
}

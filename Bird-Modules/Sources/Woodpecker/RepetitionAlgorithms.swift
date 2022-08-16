//
//  File.swift
//  
//
//  Created by Marcos Chevis on 15/08/22.
//

import Foundation

struct SM2CardInfo {
    var userGrade: Int
    var streak: Int
    var easeFactor: Float
    var interval: Int
    
    static func SM2(_ cardInfo: SM2CardInfo) -> SM2CardInfo {
        
        let userGrade: Int = cardInfo.userGrade
        var streak: Int = cardInfo.streak
        var easeFactor: Float = cardInfo.easeFactor
        var interval: Int = cardInfo.interval
        
        if userGrade >= 3 {
            if streak == 0 {
                interval = 1
            } else if streak == 1 {
                interval = 6
            } else {
                interval = Int(round((Float(interval) * easeFactor)))
            }
            streak += 1
        } else {
            streak = 0
            interval = 1
        }
        
        easeFactor = easeFactor + (0.1 - (5 - Float(userGrade)) * (0.08 + (5 - Float(userGrade)) * 0.02))
        
        if easeFactor < 1.3 {
            easeFactor = 1.3
        }
        
        return SM2CardInfo(userGrade: userGrade, streak: streak, easeFactor: easeFactor, interval: interval)
    }
}








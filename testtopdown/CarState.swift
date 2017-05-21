//
//  CarState.swift
//  topdowngame
//
//  Created by Matias Rivas on 14/05/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import Foundation

struct CarState {
    static let TDC_NO_MOVE:UInt32 = 0b0
    static let TDC_LEFT:UInt32 = 0b01
    static let TDC_RIGHT:UInt32 = 0b10
    static let TDC_UP:UInt32 = 0b11
    static let TDC_DOWN:UInt32 = 0b100
}


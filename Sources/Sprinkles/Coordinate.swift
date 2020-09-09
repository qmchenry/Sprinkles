//
//  Coordinate.swift
//  
//
//  Created by Quinn McHenry on 9/8/20.
//

import Foundation

struct Coordinate {
    let x: Int
    let y: Int
}

extension Coordinate: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

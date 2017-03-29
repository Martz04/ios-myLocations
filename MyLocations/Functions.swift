//
//  Functions.swift
//  MyLocations
//
//  Created by Mario Alberto Gonzalez on 23/03/17.
//  Copyright © 2017 Mario Alberto Gonzalez. All rights reserved.
//

import Foundation
import Dispatch

func afterDelay(_ seconds: Double, closure: @escaping() -> ()){
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
}

func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

//
//  NSTextField+Animation.swift
//  Quto
//
//  Created by Mohamed EL Meseery on 1/12/19.
//  Copyright © 2019 Meseery. All rights reserved.
//

import AppKit

extension NSTextField {
    func setTextWithTypeAnimation(typedText: String,
                                  characterDelay: TimeInterval = 5.0) {
        stringValue = ""
        let typeTask = DispatchWorkItem { [weak self] in
            for character in typedText {
                DispatchQueue.main.async {
                    self?.stringValue.append(character)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }
        
        let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
        queue.asyncAfter(deadline: .now() + 0.05, execute: typeTask)
    }
}

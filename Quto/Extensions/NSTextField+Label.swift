//
//  NSTextField+Label.swift
//  Quto
//
//  Created by Mohamed EL Meseery on 1/6/19.
//  Copyright © 2019 Meseery. All rights reserved.
//

import AppKit

extension NSTextField {
    static func label(bounds: CGRect) -> NSTextField {
        let label = NSTextField(frame: bounds)
        label.autoresizingMask = NSView.AutoresizingMask.width
        label.stringValue = "Loading…"
        label.backgroundColor = .clear
        label.isEditable = false
        label.isBezeled = false
        return label
    }
}

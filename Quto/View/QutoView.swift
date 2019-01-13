//
//  QutoView.swift
//  Quto
//
//  Created by Mohamed EL Meseery on 1/6/19.
//  Copyright © 2019 Meseery. All rights reserved.
//

import Foundation
import ScreenSaver

class QutoView: ScreenSaverView {
    private var quoteLabel: NSTextField!
    private var quoteBackground: NSImageView!
    private var backgroundColor = NSColor.black
    private var textColor = NSColor.white
    private var textFont = NSFont.init(name: "Skia", size: 48.0)
    private var fileName: String = "quotes"

    open var quotes: [Quote]?

    convenience init() {
        self.init(frame: .zero, isPreview: false)
        quoteLabel = .label(bounds: frame)
        quoteBackground = .init(frame: frame)
        initialize()
    }

    override init!(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        quoteLabel = .label(bounds: frame)
        quoteBackground = .init(frame: frame)
        initialize()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        quoteLabel = .label(bounds: bounds)
        quoteBackground = .init(frame: frame)
        initialize()
    }

    private func initialize() {
        self.quotes = readQuotesArray(fileName: fileName)
        quoteBackground.image = getBackgroundImage()
        quoteBackground.imageScaling = .scaleAxesIndependently
        animationTimeInterval = 10
        addSubview(quoteBackground)
        addSubview(quoteLabel)
    }

    override open var configureSheet: NSWindow? {
        return nil
    }

    override open var hasConfigureSheet: Bool {
        return false
    }

    override func animateOneFrame() {
        if let quote = getQuote() {
            let quoteText = (quote.quote ?? "Ooooh - Unavailable Quote!") + "\n\n\t\t\t\t --" + (quote.author ?? "")
            quoteLabel.setTextWithTypeAnimation(typedText: quoteText)
        }
        setNeedsDisplay(frame)
    }
    
    func getQuote() -> Quote? {
        return quotes?.randomElement()
    }
    
   func readQuotesArray(fileName: String) -> [Quote]? {
    if let path = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json"),
        let contents = try? Data.init(contentsOf: path) {
            let map = JSONDecoder()
            return try? map.decode([Quote].self, from: contents)
        }
        return nil
    }
    
    func getBackgroundImage() -> NSImage? {
        if let path = Bundle(for: type(of: self)).url(forResource: "quoteBackground", withExtension: "jpg"){
            return NSImage.init(contentsOf: path)
        }        
        return nil
    }

    override open func draw(_ rect: NSRect) {
        super.draw(rect)
        let labelWidth = rect.size.width - 20
        let labelHeight = rect.size.height / 3
        let labelX = rect.maxX - (rect.maxX/2.0) - (labelWidth/2.0)
        let labelY = rect.maxY - (rect.maxY/2.0) - (labelHeight/2.0)
        quoteLabel.frame = CGRect.init(x: labelX,
                                  y: labelY,
                                  width: labelWidth,
                                  height: labelHeight)
        quoteLabel.textColor = textColor
        quoteLabel.lineBreakMode = .byWordWrapping
        quoteLabel.maximumNumberOfLines = 0
        quoteLabel.alignment = .center
        quoteLabel.font = textFont
        backgroundColor.setFill()
        quoteBackground.frame = rect
        rect.fill()
    }
}

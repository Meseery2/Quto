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

    public var backgroundColor = NSColor.black
    public var textColor = NSColor.white
    public var textFont = NSFont.init(name: "Skia", size: 48.0)
    
    var quotes: [Quote]?
    var fileName: String = "quotes"
    
    convenience init() {
        self.init(frame: .zero, isPreview: false)
        quoteLabel = .label(bounds: frame)
        initialize()
    }
    
    override init!(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        quoteLabel = .label(bounds: frame)
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        quoteLabel = .label(bounds: bounds)
        initialize()
    }
    
    private func initialize() {
        self.quotes = readQuotesArray(fileName: fileName)
        animationTimeInterval = 6
        addSubview(quoteLabel)
    }

    override open var configureSheet: NSWindow? {
        return nil
    }
    
    override open var hasConfigureSheet: Bool {
        return false
    }
    
    override func animateOneFrame() {
        if let text = getQuote() {
            quoteLabel.attributedStringValue = text
            setNeedsDisplay(frame)
        }
    }

    func getQuote() -> NSAttributedString? {
        if let quote = quotes?.randomElement() {
            let quoteText = quote.quote ?? "Ooooh - Unavailable Quote!"
            let quoteAuthor = quote.author ?? "No Author"
            let fullText = "\(quoteText)"
            let attributedString = NSMutableAttributedString(string: fullText, attributes: [.font:textFont ?? .systemFont(ofSize: 48.0)])
            attributedString.setAlignment(.center,
                                          range:
                (fullText as NSString).range(of: fullText))
            return attributedString
        }
        return nil
    }
    
    func getTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
   func readQuotesArray(fileName: String) -> [Quote]? {
        if let path = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json"),
            let contents = try? Data.init(contentsOf: path) {
            let map = JSONDecoder()
            return try? map.decode([Quote].self, from: contents)
        }
        return nil
    }

    override open func draw(_ rect: NSRect) {
        super.draw(rect)
        let labelWidth = rect.size.width - 20
        let labelHeight = rect.size.height / 4
        let labelX = rect.maxX - (rect.maxX/2.0) - (labelWidth/2.0)
        let labelY = rect.maxY - (rect.maxY/2.0) - (labelHeight/2.0)
        quoteLabel.frame = CGRect.init(x: labelX,
                                  y: labelY,
                                  width: labelWidth,
                                  height: labelHeight)
        quoteLabel.textColor = textColor
        quoteLabel.lineBreakMode = .byWordWrapping
        quoteLabel.maximumNumberOfLines = 0
        backgroundColor.setFill()
        rect.fill()
    }

}

//
//  QutoView.swift
//  Quto
//
//  Created by Mohamed EL Meseery on 1/6/19.
//  Copyright © 2019 Meseery. All rights reserved.
//

import Foundation
import ScreenSaver
import AVKit

class QutoView: ScreenSaverView {
    private var quoteLabel: NSTextField!
    private var videoPlayer: AVPlayerView!
    private var player: AVPlayer!
    private var textColor = NSColor.white
    private var textFont = NSFont.init(name: "Skia", size: 48.0)
    private var jsonFileName: String = "quotes"
    private var videoFileName: String = "Traffic"
    open var quotes: [Quote]?

    convenience init() {
        self.init(frame: .zero, isPreview: false)
        initialize()
    }

    override init!(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        initialize()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        animationTimeInterval = 10
        quotes = readQuotesArray(fileName: jsonFileName)
        quoteLabel = .label(bounds: bounds)
        videoPlayer = .init(frame: frame)
        setupVideoPlayer()
        addSubview(videoPlayer)
        addSubview(quoteLabel)
    }
    
    private func setupVideoPlayer() {
        if let path = Bundle(for: type(of: self)).url(forResource: videoFileName, withExtension: "mp4"){
            let asset = AVURLAsset(url: path)
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            videoPlayer?.player = player
            videoPlayer.controlsStyle = .none
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] notification in
                self?.player.seek(to: CMTime.zero)
                self?.player.play()
            }
        }
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
        videoPlayer.player?.play()
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
        rect.fill()
    }
}

//
//  MarkDownRenderTextView.swift
//  Quantum
//
//  Created by Javax on 07/07/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa

class MarkDownRenderTextView: NSTextView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func prepare () {
        self.isRichText = true
        self.isEditable = false
        self.isSelectable = false
        self.drawsBackground = false
        
        self.backgroundColor = .clear
        
        basicFont = NSFont (name: "Helvetica Neue Regular", size: 12)
        heading1Font = NSFont (name: "Helvetica Neue Bold", size: 24)
        heading1Font = NSFont (name: "Helvetica Neue Bold", size: 20)

        
        //self.font = basicFont
        isPrepared = true
    }
    
    var isPrepared:Bool = false
    
    var basicFont:NSFont?
    var boldFont:NSFont?
    var italicFont:NSFont?
    var heading1Font:NSFont?
    var heading2Font:NSFont?
    var heading3Font:NSFont?
    var unorderedListFont:NSFont?
    var linkFont:NSFont?
    
    func updateRender (_ text:String) {
        var fixedText = text
        fixedText = fixedText.replacingOccurrences(of: "*", with: "")
        fixedText = fixedText.replacingOccurrences(of: "-", with: "")
        fixedText = fixedText.replacingOccurrences(of: "_", with: "")
        fixedText = fixedText.replacingOccurrences(of: "*", with: "")

        self.string = fixedText
        
        var loc = 0
        
       // let chars = text.components(separatedBy: "")
        let chars = Array (text)
        
        var parts:[(String, NSFont?)] = []
        
        var isAlreadyCountingToChar:Character? = nil
        
        for c in text {
            if (isAlreadyCountingToChar == nil) {
                if (c == "#") {
                    if (chars[loc+1] == " ") {
                        isAlreadyCountingToChar = "\n"
                        parts.append(("", heading1Font))
                        loc += 1
                    } else if (chars[loc+1] == "#" && chars[loc+2] == " ") {
                        isAlreadyCountingToChar = "\n"
                        parts.append(("", heading2Font))
                        loc += 2
                    } else if (chars[loc+1] == "#" && chars[loc+2] == "#" && chars[loc+3] == " ") {
                        isAlreadyCountingToChar = "\n"
                        parts.append(("", heading3Font))
                        loc += 3
                    }
                } else {
                    parts.append((String(c), basicFont))
                }
            } else {
                if (c == isAlreadyCountingToChar) {
                    isAlreadyCountingToChar = nil
                } else {
                    let lastIndex = parts.count-1
                    parts[lastIndex].0.append(c)
                }
            }
            
            loc += 1
        }
        
        self.string = ""
        var prevEndLoc = 0
        for part in parts {
            if (part.1 != nil) {
                self.string.append(part.0)
                self.setSelectedRange(NSRange(location: prevEndLoc, length: part.0.count))
                self.selectedTextAttributes.updateValue(part.1 as Any, forKey: NSAttributedStringKey.font)
                self.typingAttributes.updateValue(NSColor.lightGray, forKey: NSAttributedStringKey.foregroundColor)
                self.typingAttributes.updateValue(NSColor.clear, forKey: NSAttributedStringKey.backgroundColor)
            
                self.setFont(part.1!, range: NSRange(location: prevEndLoc, length: part.0.count))
                prevEndLoc += part.0.count
            }
        }
        self.setSelectedRange(NSRange (location: 0, length: 0))
    }
    
}

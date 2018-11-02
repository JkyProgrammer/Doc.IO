//
//  EditorView.swift
//  Quantum
//
//  Created by Javax on 12/07/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa

class EditorView: NSTextView {

	let mainCursor: NSCursor = NSCursor(image: NSImage(named: "MainCursor")!, hotSpot: NSPoint (x: 43, y: 15))
	let textCursor: NSCursor = NSCursor(image: NSImage(named: "TextCursor")!, hotSpot: NSPoint (x: 128, y: 128))
	
	override func resetCursorRects() {
		super.resetCursorRects()
		//self.addCursorRect(self.bounds, cursor: textCursor)
		//Swift.print ("rect added")
		//NSRect (x: 0, y: 0, width: self.frame.width, height: (self.superview?.frame.height)!)
		//self.addCursorRect((self.superview?.superview?.frame)!, cursor: textCursor)
		//let b = NSBox (frame: (self.superview?.superview?.frame)!)
		
		//self.addSubview(b)
		
	}
	
	override func cursorUpdate(with event: NSEvent) {
		//Swift.print ("upc")
		
	}
	
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}

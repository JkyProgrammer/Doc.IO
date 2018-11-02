//
//  View.swift
//  Quantum
//
//  Created by Javax on 12/07/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa

class View: NSView {

	let mainCursor: NSCursor = NSCursor(image: NSImage(named: "MainCursor")!, hotSpot: NSPoint (x: 43, y: 15))
	let textCursor: NSCursor = NSCursor(image: NSImage(named: "TextCursor")!, hotSpot: NSPoint (x: 128, y: 128))
	
	override func resetCursorRects() {
		super.resetCursorRects()
		//self.window?.discardCursorRects()
		//Swift.print ("discarded")
		//self.addCursorRect(NSRect (x: 0, y: 0, width: (self.window?.frame.width)!, height: (self.window?.frame.height)!), cursor: mainCursor)
		//self.addCursorRect(self.editorViewHolder.frame, cursor: textCursor)
		
	}
	@IBOutlet var editorViewHolder: NSScrollView!
	@IBOutlet var editorView: NSTextView!
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}

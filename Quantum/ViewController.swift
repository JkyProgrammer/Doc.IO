//
//  ViewController.swift
//  Doc.IO
//
//  Created by Javax on 23/06/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear() {
		//self.view.window?.backgroundColor = NSColor (red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
		//self.view.layer?.backgroundColor = NSColor (red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0).cgColor
		
		self.view.window!.appearance = NSAppearance(named:NSAppearance.Name.vibrantDark)
		//NSApp.delegate
		Swift.print ("Loaded")
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBOutlet var editorView: NSTextView!
	
}


//
//  WindowController.swift
//  Quantum
//
//  Created by Javax on 13/07/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        self.window!.appearance = NSAppearance(named:NSAppearance.Name.vibrantDark)
    }
    
    override func newWindowForTab(_ sender: Any?) {
        //(self.window?.contentViewController as! ViewController).createNew()
    }
}

//
//  AppDelegate.swift
//  Quantum
//
//  Created by Javax on 23/06/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    @IBOutlet weak var newBut: NSMenuItem!
    
    @IBAction func showInFinder(_ sender: Any) {
        if (NSApp.orderedDocuments[0].fileURL != nil) {
            NSWorkspace.shared.activateFileViewerSelecting([NSApp.orderedDocuments[0].fileURL!])
        } else {
            
        }
    }
}


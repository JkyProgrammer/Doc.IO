//
//  AppDelegate.swift
//  Doc.IO
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
	
	var encoding:String.Encoding = .utf8
	var viewingMode:Int = 0
	var shouldHighlightSyntax:Bool = false
	var language:String = "None"
	var buildScriptPath:String = ""
	var executionCommand:String = ""
	var shouldLivePreviewMarkdown:Bool = false

}


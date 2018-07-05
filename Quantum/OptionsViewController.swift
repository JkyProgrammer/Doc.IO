//
//  OptionscViewController.swift
//  Quantum
//
//  Created by Javax on 28/06/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa

class OptionsViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		// Load all settings
		let ad = NSApp.orderedDocuments.first as! Document
		
		// Encoding
		switch (ad.encoding) {
		case .utf8:
			encodingSelector.selectItem(withTitle: "UTF-8")
			break
		case .ascii:
			encodingSelector.selectItem(withTitle: "ASCII")
			break
		default:
			encodingSelector.selectItem(withTitle: "Unicode")
			break
		}
		
		// Viewing mode
		viewingModeSelector.selectSegment(withTag: ad.viewingMode)
		
		// Syntax highlighting enabled
		syntaxHighlightingEnabler.state = .off
		if (ad.shouldHighlightSyntax) {syntaxHighlightingEnabler.state = .on}
		
		// Selected language
		languageSelector.selectItem(withTitle: ad.language)
		
		// Build script path
		buildScriptPathField.stringValue = ad.buildScriptPath
		
		// Execution command
		executionCommandField.stringValue = ad.executionCommand
		
		// Live preview enabled
		livePreviewPaneEnabler.state = .off
		if (ad.shouldLivePreviewMarkdown) {livePreviewPaneEnabler.state = .on}
    }
	
	override func viewDidAppear() {
		self.segmentedControlChanged(self)
	}
	
	@IBAction func cancel(_ sender: Any) {
		self.dismiss(self)
		self.view.window?.close()
	}
	
	@IBAction func save(_ sender: Any) {
		// Write all settings
		let ad = NSApp.orderedDocuments.first as! Document
		
		// Encoding
		switch (encodingSelector.selectedItem?.title) {
		case "UTF-8":
			ad.encoding = .utf8
			break
		case "ASCII":
			ad.encoding = .ascii
			break
		default:
			ad.encoding = .unicode
			break
		}
		
		// Viewing mode
		ad.viewingMode = viewingModeSelector.selectedSegment
		
		// Syntax highlighting enabled
		ad.shouldHighlightSyntax = (syntaxHighlightingEnabler.state == .on)
		
		// Selected language
		ad.language = (languageSelector.selectedItem?.title)!
		
		// Build script path
		ad.buildScriptPath = buildScriptPathField.stringValue
		
		// Execution command
		ad.executionCommand = executionCommandField.stringValue
		
		// Live preview enabled
		ad.shouldLivePreviewMarkdown = (livePreviewPaneEnabler.state == .on)
		
		self.dismiss(self)
		self.view.window?.close()
	}
	
	@IBOutlet var encodingSelector: NSPopUpButton!
	@IBOutlet var viewingModeSelector: NSSegmentedControl!
	@IBOutlet var syntaxHighlightingEnabler: NSButton!
	@IBOutlet var languageSelector: NSPopUpButton!
	@IBOutlet var buildScriptPathField: NSTextField!
	@IBOutlet var buildScriptPathSelectButton: NSButton!
	@IBOutlet var executionCommandField: NSTextField!
	@IBOutlet var livePreviewPaneEnabler: NSButton!
	
	@IBAction func segmentedControlChanged(_ sender: Any) {
		let selectedSegment = viewingModeSelector.selectedSegment
		if (selectedSegment != 1) {
			syntaxHighlightingEnabler.isEnabled = false
			languageSelector.isEnabled = false
			buildScriptPathField.isEnabled = false
			buildScriptPathSelectButton.isEnabled = false
			executionCommandField.isEnabled = false
			livePreviewPaneEnabler.isEnabled = false
		} else {
			syntaxHighlightingEnabler.isEnabled = true
			languageSelector.isEnabled = true
			buildScriptPathField.isEnabled = true
			buildScriptPathSelectButton.isEnabled = true
			executionCommandField.isEnabled = true
			livePreviewPaneEnabler.isEnabled = false
		}
		if (selectedSegment == 2) {
			livePreviewPaneEnabler.isEnabled = true
		}
	}
	
	
	@IBAction func selectPath(_ sender: Any) {
		let sp = NSOpenPanel ()
		sp.title = "Save File"
		sp.allowedFileTypes = ["sh", "bash", "app", ""]
		sp.allowsOtherFileTypes = true
		sp.allowsMultipleSelection = false
		//self.windowControllers[0].contentViewController?.presentViewControllerAsModalWindow(sp)
		if (sp.runModal() == NSApplication.ModalResponse.OK) {
			buildScriptPathField.stringValue = (sp.url?.absoluteString)!
		}
	}
}

//
//  Document.swift
//  Doc.IO
//
//  Created by Javax on 23/06/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa
let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
class Document: NSDocument {

	override init() {
	    super.init()
		// Add your subclass-specific initialization here.
	}

	override class var autosavesInPlace: Bool {
		return true
	}

	override func makeWindowControllers() {
		// Returns the Storyboard that contains your Document window.
		let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
		((windowController.contentViewController as! ViewController).editorView.string) = textValue
		self.addWindowController(windowController)
	}

	override func data(ofType typeName: String) throws -> Data {
		// Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
		// You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
		//throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		let data = ((self.windowControllers[0].contentViewController as! ViewController).editorView.string).data(using: String.Encoding.ascii)
		Swift.print ("saved document")
		return data!
	}
	
	override func save(_ sender: Any?) {
		let string = ((self.windowControllers[0].contentViewController as! ViewController).editorView.string)//.data(using: String.Encoding.ascii)
		Swift.print (string)
		//self.fileURL
		do {
			if (self.fileURL == nil) {
				saveAs(nil)
			} else {
				try string.write(to: self.fileURL!, atomically: false, encoding: .utf8)
				self.updateChangeCount(.changeAutosaved)
			}
		} catch {
			
		}

	}
	
	override func saveAs(_ sender: Any?) {
		let sp = NSSavePanel ()
		sp.title = "Save File"
		sp.canCreateDirectories = true
		sp.nameFieldStringValue = self.displayName
		sp.allowedFileTypes = ["dio", "txt"]
		//self.windowControllers[0].contentViewController?.presentViewControllerAsModalWindow(sp)
		if (sp.runModal() == NSApplication.ModalResponse.OK) {
			self.fileURL = sp.url
            self.displayName = sp.nameFieldStringValue
		}
		Swift.print ("Saving...")
	}
	
	var textValue = ""
	
	override func read(from data: Data, ofType typeName: String) throws {
		// Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
		// You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
		// If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
		textValue = String (data: data, encoding: .utf8)!
		//throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
	}
}


//
//  Document.swift
//  Quantum
//
//  Created by Javax on 23/06/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa
//let sstoryboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
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
		let windowController = sstoryboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
		((windowController.contentViewController as! ViewController).editorView).string = textValue
		self.addWindowController(windowController)
	}

	override func data(ofType typeName: String) throws -> Data {
		// Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
		// You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
		//throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		let data = (mainViewController.editorView.string).data(using: self.encoding)
		if (data != nil) {
			// Write settings to storage
			// Write
			return data!
		}
		
		
		return Data()
	}
	
	var mainViewController:ViewController {
		get {
			return (self.windowControllers[0].contentViewController as! ViewController)
		}
	}
	
	override func save(_ sender: Any?) {
		let string = ((self.windowControllers[0].contentViewController as! ViewController).editorView.string)
		do {
			if (self.fileURL == nil) {
				saveAs(nil)
			} else {
				try string.write(to: self.fileURL!, atomically: false, encoding: .utf8)
				self.updateChangeCount(withToken: self.changeCountToken(for: NSDocument.SaveOperationType.saveOperation), for: NSDocument.SaveOperationType.saveOperation)
				//self.windowControllers[0].setDocumentEdited(false)
				Swift.print ("Saving document")
			}
		} catch {
			
		}

	}
	
	override func saveAs(_ sender: Any?) {
		let sp = NSSavePanel ()
		sp.title = "Save File"
		sp.canCreateDirectories = true
		sp.nameFieldStringValue = self.displayName
		sp.allowedFileTypes = ["quantum"]
		sp.allowsOtherFileTypes = true
		//self.windowControllers[0].contentViewController?.presentViewControllerAsModalWindow(sp)
		if (sp.runModal() == NSApplication.ModalResponse.OK) {
			self.fileURL = sp.url
            self.displayName = sp.nameFieldStringValue
			Swift.print ("Saving document as")
			save(self)
		}
	}
	
	var textValue = ""
	
	override func read(from url: URL, ofType typeName: String) throws {
        Swift.print ("Reading from URL")
        do {
            textValue = (try String (contentsOf: url))
        } catch (let e) {
            throw e
        }
		if (false) {
			// Read
		} else {
			// Detect
			let ext = url.pathExtension
			switch (ext) {
			case "py":
				self.language = "Python"
				self.viewingMode = 1
				break
			case "java":
				self.language = "Java"
				self.viewingMode = 1
				break
			case "sh":
				self.language = "Shell"
				self.viewingMode = 1
				break
			case "bash":
				self.language = "Shell"
				self.viewingMode = 1
				break
			case "swift":
				self.viewingMode = 1
				break
			case "c":
				self.viewingMode = 1
				break
			case "cpp":
				self.viewingMode = 1
				break
			case "cc":
				self.viewingMode = 1
				break
			case "md":
				self.viewingMode = 2
				break
			default:
				self.viewingMode = 0
			}
		}
	}
	
	var encoding:String.Encoding = .utf8
    var viewingMode:Int = 0
	var shouldHighlightSyntax:Bool = false
	var language:String = "None"
	var buildScriptPath:String = ""
	var executionCommand:String = ""
	var shouldLivePreviewMarkdown:Bool = true
}


//
//  ViewController.swift
//  Doc.IO
//
//  Created by Javax on 23/06/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa
let sstoryboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSTextViewDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		//tableViewer.delegate = self
		
		//tableViewer.dataSource = self
		//tableViewer.refusesFirstResponder = true
		
		//editorView = NSTextView (frame: NSRect(x: Int(editorViewHolder.frame.minX), y: Int(editorViewHolder.frame.minY), width: Int(editorViewHolder.frame.maxX) - 30, height: Int(editorViewHolder.frame.maxY)))
		
		
		//self.editorViewHolder.addSubview(editorView)
	}
	
	@IBOutlet var tableViewer: NSTableView!

	
	override func viewDidAppear() {
		//self.view.window?.backgroundColor = NSColor (red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
		//self.view.layer?.backgroundColor = NSColor (red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0).cgColor
		self.view.window!.appearance = NSAppearance(named:NSAppearance.Name.vibrantDark)
		//NSApp.delegate
		editorView.delegate = self
        editorView.typingAttributes.updateValue(NSFont (name: "Courier", size: 16) as Any, forKey: NSAttributedStringKey.font)
        editorView.typingAttributes.updateValue(NSColor.controlTextColor, forKey: NSAttributedStringKey.foregroundColor)
        editorView.isAutomaticQuoteSubstitutionEnabled = false;
		
		updateColumnAndLineLabels()
		Swift.print ("Loaded")
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	
	
	@IBOutlet var editorViewHolder: NSScrollView!
	
//	@IBAction func documentOptionsOpened(_ sender: Any) {
//		let ovc = (sstoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "OVC")) as! NSViewController)
//		self.presentViewControllerAsModalWindow(ovc)
//		//ovc.showWindow(self)
//	}
	
	@IBOutlet var editorView: NSTextView!
	
	var lineNumbers:[String] = ["1","2","3"]
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return lineNumbers.count
	}

	func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
		let cell = NSTextFieldCell (textCell: lineNumbers[row])
		return cell
	}
	
	func textDidChange(_ notification: Notification) {
		(self.view.window?.windowController?.document as! Document).updateChangeCount(NSDocument.ChangeType.changeDone)
		updateColumnAndLineLabels()
	}
	
	func textViewDidChangeSelection(_ notification: Notification) {
		updateColumnAndLineLabels()
	}
	
	func updateColumnAndLineLabels () {
		let realCursorLoc = editorView.selectedRanges[0].rangeValue.location
		//var lnStarts:[Int] = []
		var lineLoc = 0
		var colLoc = 0
		var charLoc = 0
		for c in editorView.string {
			if (c == "\n") {
				if (realCursorLoc > charLoc) {
					colLoc = 0
					lineLoc += 1
				} else if (realCursorLoc == charLoc) {
					break
				}
			} else {
				if (realCursorLoc > charLoc) {
					colLoc += 1
				} else if (realCursorLoc == charLoc) {
					break
				}
			}
			charLoc += 1
		}
		let lineString = "Line: \(lineLoc+1) of \(editorView.string.components(separatedBy: "\n").count)"
		let columnString = "Column: \(colLoc)"
		
		lineLabel.stringValue = lineString
		//touchBarLineLabel.stringValue = lineString
		
		columnLabel.stringValue = columnString
		//touchBarColumnLabel.stringValue = columnString
	}
	
	@IBAction func runBuildScriptFromTouchBar(_ sender: Any) {
		self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "callBuildScript"), sender: self)
	}
	
	@IBAction func runExecuteScriptFromTouchBar(_ sender: Any) {
		self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "execCommand"), sender: self)
	}
	
	@IBOutlet var lineLabel: NSTextField!
	@IBOutlet var columnLabel: NSTextField!
	
	@IBOutlet var touchBarLineLabel: NSTextField!
	@IBOutlet var touchBarColumnLabel: NSTextField!
}


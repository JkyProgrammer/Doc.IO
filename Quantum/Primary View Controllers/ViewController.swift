//
//  ViewController.swift
//  Quantum
//
//  Created by Javax on 23/06/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa
let sstoryboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSTextViewDelegate, NSWindowDelegate {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.window?.invalidateCursorRects(for: editorViewHolder)
	}
    
    func createNew () {
        let but = (NSApp.delegate as! AppDelegate).newBut
        NSApp.sendAction((but?.action)!, to: but?.target, from: but)
        
    }
	
	func windowDidBecomeKey (_ notification: Notification) {
		if (livePreviewWindow != nil && self.document.shouldLivePreviewMarkdown && self.document.viewingMode == 2) {
			livePreviewWindow?.setIsVisible(true)
		}
		//Swift.print ("Became key")
	}
	
	func windowDidResignKey (_ notification: Notification) {
		if (livePreviewWindow != nil) {
			livePreviewWindow?.setIsVisible(false)
		}
		//Swift.print ("Lost key")
	}
	
	@IBOutlet var tableViewer: NSTableView!

	
	override func viewDidAppear() {
        NSAppearance.current = NSAppearance (named: NSAppearance.Name.vibrantDark)
        
		editorView.delegate = self
        
        editorView.typingAttributes.updateValue(NSFont (name: "Courier", size: 16) as Any, forKey: NSAttributedStringKey.font)
        
        editorView.typingAttributes.updateValue(NSColor.controlTextColor, forKey: NSAttributedStringKey.foregroundColor)
        
        editorView.isAutomaticQuoteSubstitutionEnabled = false
        editorView.isAutomaticLinkDetectionEnabled = false
        editorView.isAutomaticDashSubstitutionEnabled = false
        editorView.isAutomaticTextReplacementEnabled = false
        editorView.isAutomaticDataDetectionEnabled = false
        
		updateColumnAndLineLabels()
        updatePreviewView()
		
		self.view.window?.delegate = self
		
		if ((NSApp.orderedDocuments[0] as! Document) == self.document && livePreviewWindow != nil) {
			self.livePreviewWindow?.setIsVisible(true)
		} else {
			self.livePreviewWindow?.setIsVisible(false)
		}
        
        timer = Timer.scheduledTimer (timeInterval: 1, target: self, selector: #selector (ViewController.updateShouldRerenderMarkDown), userInfo: nil, repeats: true)
		//timer.fire()
        Swift.print ("Loaded window successfully")
        Swift.print ("View appeared")
        Swift.print (self.view.window?.contentViewController)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	
	
	@IBOutlet var editorViewHolder: NSScrollView!
	
    
    var document:Document {
        return (self.view.window?.windowController?.document as! Document)
    }
	
	@IBOutlet var editorView: NSTextView!
    var timer:Timer!
    
	var lineNumbers:[String] = ["1","2","3"]
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return lineNumbers.count
	}

	func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
		let cell = NSTextFieldCell (textCell: lineNumbers[row])
		return cell
	}
    
    override func viewWillDisappear() {
        timer.invalidate()
    }
    
    @objc func updateShouldRerenderMarkDown () {
        if (rendererView != nil && !hasOldChanges && didHaveOldChanges) {
            rendererView?.updateRender(editorView.string)
            didHaveOldChanges = false
        }
        if (hasOldChanges) {
            hasOldChanges = false
            didHaveOldChanges = true
        }        
    }
    var hasOldChanges = false
    var didHaveOldChanges = false
    
	func textDidChange(_ notification: Notification) {
		self.document.updateChangeCount(NSDocument.ChangeType.changeDone)
		updateColumnAndLineLabels()
        hasOldChanges = true
        Swift.print(self.editorView.typingAttributes)
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
		touchBarLineLabel.cell?.stringValue = lineString
		
		columnLabel.stringValue = columnString
		touchBarColumnLabel.cell?.stringValue = columnString
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
    
    // Markdown Rendering Code
    
    func updatePreviewView () {
		if (self.document.viewingMode == 2 && self.document.shouldLivePreviewMarkdown) {
            if (livePreviewWindow != nil) {
                livePreviewWindow?.setIsVisible(true)
                
                if (rendererView?.isPrepared)! {
                    rendererView?.updateRender(editorView.string)
                } else {
                    rendererView?.prepare()
                    rendererView?.updateRender(editorView.string)
                }
            } else {
                livePreviewWindow = NSPanel (contentRect: NSRect (x: Int((self.view.window?.frame.maxX)!)-500, y: Int((self.view.window?.frame.maxY)!)-300, width: 500, height: 300), styleMask: NSWindow.StyleMask.borderless, backing: .buffered, defer: false)
                let vc = NSStoryboard (name: NSStoryboard.Name(rawValue: "Main"), bundle: Bundle.main).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MarkDownRenderViewController")) as! MarkDownRenderViewController
                livePreviewWindow?.contentViewController = vc
                livePreviewWindow?.level = .floating
				livePreviewWindow?.styleMask = NSWindow.StyleMask(rawValue: NSWindow.StyleMask.RawValue(UInt16((livePreviewWindow?.styleMask)!.rawValue) | UInt16(NSWindow.StyleMask.resizable.rawValue)))
                //livePreviewWindow?.isMovable = true
				livePreviewWindow?.isOpaque = false
				livePreviewWindow?.backgroundColor = NSColor (deviceWhite: 0.2, alpha: 0.7)
				livePreviewWindow?.isMovableByWindowBackground = true
				//livePreviewWindow
                if (rendererView?.isPrepared)! {
                    rendererView?.updateRender(editorView.string)
                } else {
                    rendererView?.prepare()
                    rendererView?.updateRender(editorView.string)
                }
                //rendererView?.setFrameSize(NSSize(width: 500, height: 300))
                //rendererView?.setFrameOrigin(NSPoint(x:0, y:0))
                //livePreviewWindow?.contentView?.addSubview(rendererView!)
                let controller = NSWindowController (window: livePreviewWindow)
                controller.showWindow(self)
            }
        } else {
            livePreviewWindow?.setIsVisible(false)
        }
    }
    
    var rendererView:MarkDownRenderTextView? {
        if (livePreviewWindow != nil) {
            return (livePreviewWindow?.contentViewController as! MarkDownRenderViewController).textView
        } else {
            return nil
        }
    }
    var livePreviewWindow:NSWindow?
}

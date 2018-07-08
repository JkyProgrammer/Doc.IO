//
//  ExecCommandViewController.swift
//  Quantum
//
//  Created by Javax on 01/07/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa

class ExecCommandViewController: NSViewController {
	
	let task = Process()
	let pipe = Pipe()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.window?.title = "Execute Command"
	}
	
	override func viewDidAppear() {
		// Do view setup here.
		let path = (NSApp.orderedDocuments[0] as! Document).executionCommand
		if (path != "" && (NSApp.orderedDocuments[0] as! Document).fileURL != nil) {
			// Set the task parameters
            let absolutePath = (((NSApp.orderedDocuments[0] as! Document).fileURL)!.deletingLastPathComponent().appendingPathComponent(path).path)
            Swift.print (absolutePath)
            if FileManager.default.fileExists(atPath: absolutePath)/* && FileManager.default.isExecutableFile(atPath: absolutePath)*/ {
                task.currentDirectoryPath = ((NSApp.orderedDocuments[0] as! Document).fileURL?.deletingLastPathComponent().path)!
				task.launchPath = "/bin/bash"
                Swift.print (task.currentDirectoryPath, task.launchPath!)

                task.arguments = [path]
				
				// Create a Pipe and make the task
				// put all the output there
				
				task.standardOutput = pipe
				let main = Thread.current
				
				spinner.startAnimation(self)
				
				let delayQueue = DispatchQueue(label: "net.Javax-Inc.Quatum", qos: .userInitiated)
				let _: DispatchTimeInterval = .seconds(2)
				self.task.launch()
				delayQueue.async {
					
					while (self.task.isRunning) {
						let data = self.pipe.fileHandleForReading.readDataToEndOfFile()
						let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
						self.perform(#selector (ExecCommandViewController.setText), on: main, with: output! as String, waitUntilDone: false)
					}
					self.perform(#selector (ExecCommandViewController.stopAnimating), on: main, with: nil, waitUntilDone: false)
				}
			} else {
				setText(t: "Command executable not found, file may not be executable.")
			}
			
		} else {
			setText(t: "No execution command found.")
		}
	}
	
	@IBOutlet var spinner: NSProgressIndicator!
	
	@IBOutlet var outputView: NSTextView!
	
	@objc func setText (t:String) {
		self.outputView.string = self.outputView.string + "\n" + t
		Swift.print (t)
	}
	
	@objc func stopAnimating () {
		self.spinner.stopAnimation(self)
		let data = self.pipe.fileHandleForReading.readDataToEndOfFile()
		let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
		setText(t: output! as String)
	}
	
	@IBAction func cancelButton(_ sender: Any) {
		if (task.isRunning) {
			task.terminate()
			spinner.stopAnimation(sender)
		}
		self.dismiss(sender)
		//self.view.window?.close()
	}
	
}

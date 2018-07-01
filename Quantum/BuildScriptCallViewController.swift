//
//  BuildScriptCallViewController.swift
//  Quantum
//
//  Created by Javax on 30/06/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa

class BuildScriptCallViewController: NSViewController {

	let task = Process()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.window?.title = "Run Build Script"
    }
	
	override func viewDidAppear() {
		// Do view setup here.
		let path = (NSApp.delegate as! AppDelegate).buildScriptPath
		if (path != nil) {
			// Set the task parameters
			task.launchPath = path
			//task.arguments = ["pwd"]
			
			// Create a Pipe and make the task
			// put all the output there
			let pipe = Pipe()
			task.standardOutput = pipe
			let main = Thread.current
			
			spinner.startAnimation(self)
			
			let delayQueue = DispatchQueue(label: "com.theappmaker.in", qos: .userInitiated)
			let _: DispatchTimeInterval = .seconds(2)
			
			delayQueue.async {
				self.task.launch()
				Swift.print ("Hey")
				while (self.task.isRunning) {
					let data = pipe.fileHandleForReading.readDataToEndOfFile()
					let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
					self.perform(#selector (BuildScriptCallViewController.setText), on: main, with: output! as String, waitUntilDone: false)
				}
				self.spinner.stopAnimation(self)
			}
			
			
		} else {
			outputView.string = "No build script found."
			cancelButton(self)
		}
	}
	
	@IBOutlet var spinner: NSProgressIndicator!
	
	@IBOutlet var outputView: NSTextView!
	
	@objc func setText (t:String) {
		self.outputView.string = t
	}
	
	@IBAction func cancelButton(_ sender: Any) {
		if (task.isRunning) {
			task.terminate()// NOT WORKING
			spinner.stopAnimation(sender)
		}
		self.dismiss(sender)
		self.view.window?.close()
	}
}

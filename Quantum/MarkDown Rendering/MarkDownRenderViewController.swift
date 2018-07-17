//
//  MarkDownRenderViewController.swift
//  Quantum
//
//  Created by Javax on 09/07/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa

class MarkDownRenderViewController: NSViewController {
    
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var textView: MarkDownRenderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//        scrollView.contentSize = NSSize (textView.size.width, textView.size.height)
		self.view.window?.minSize.width = 500
        
    }
    
}

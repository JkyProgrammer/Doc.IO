//
//  MarkDownRenderTextView.swift
//  Quantum
//
//  Created by Javax on 07/07/2018.
//  Copyright © 2018 Javax Inc. All rights reserved.
//

import Cocoa

extension NSImage {
	func resizeToFit(containerWidth: CGFloat) -> NSSize{
		var scaleFactor : CGFloat = 1.0
		let currentWidth = self.size.width
		let currentHeight = self.size.height
		if currentWidth > containerWidth {
			scaleFactor = (containerWidth * 0.9) / currentWidth
		}
		let newWidth = currentWidth * scaleFactor
		let newHeight = currentHeight * scaleFactor
		return NSSize (width: newWidth, height: newHeight)
		//self.size = NSSize(width: newWidth, height: newHeight)
		print("Size: \(size)")
	}
	
	func scaleFactorToFit (containerWidth: CGFloat) -> CGFloat{
		var scaleFactor : CGFloat = 1.0
		let currentWidth = self.size.width
		let currentHeight = self.size.height
		if currentWidth > containerWidth {
			scaleFactor = (containerWidth * 0.9) / currentWidth
		}
		let newWidth = currentWidth * scaleFactor
		let newHeight = currentHeight * scaleFactor
		return scaleFactor
		//self.size = NSSize(width: newWidth, height: newHeight)
		print("Size: \(size)")
	}
}

class MarkDownRenderTextView: NSTextView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func prepare () {
		//self.selected
        self.isRichText = true
        self.isEditable = false
        self.isSelectable = true
        self.drawsBackground = false
		
        self.backgroundColor = .clear
        
        basicFont = NSFont (name: "Helvetica Neue", size: 14)
        heading1Font = NSFont (name: "Helvetica Neue Bold", size: 24)
        heading2Font = NSFont (name: "Helvetica Neue Bold", size: 20)
        heading3Font = NSFont (name: "Helvetica Neue Bold", size: 16)
        
        boldFont = NSFont (name: "Helvetica Neue Bold", size: 14)
        italicFont = NSFont (name: "Helvetica Neue Italic", size: 14)
        bulletFont = NSFont (name: "Helvetica Neue", size: 1)
		strikeFont = NSFont (name: "Helvetica Neue", size: 2)
		codeFont = NSFont (name: "Courier", size: 12)
		linkFont = NSFont (name: "Helvetica Neue", size: 3)
		
		self.typingAttributes.updateValue(NSColor.lightGray, forKey: NSAttributedStringKey.foregroundColor)
		self.typingAttributes.updateValue(NSColor.clear, forKey: NSAttributedStringKey.backgroundColor)
		self.typingAttributes.removeValue(forKey: NSAttributedStringKey.font)
		self.layoutManager?.defaultAttachmentScaling = .scaleProportionallyDown

        isPrepared = true
    }
    
    var isPrepared:Bool = false
    
    var basicFont:NSFont?
    var boldFont:NSFont?
    var italicFont:NSFont?
    var heading1Font:NSFont?
    var heading2Font:NSFont?
    var heading3Font:NSFont?
    var bulletFont:NSFont?
    var linkFont:NSFont?
	var strikeFont:NSFont?
	var codeFont:NSFont?
	
    func updateRender (_ text:String) {
		//Swift.print ("Updating MarkDown render")
		let tmpScrollLoc = ((self.superview?.superview as! NSScrollView).verticalScroller?.doubleValue)!
        var loc = 0
        let chars = Array (text)
        var parts:[(String, NSFont?)] = []
        var isAlreadyCountingToChar:Character? = nil
        var isCountingToEndOfBold = 0
		
		var tmpLinks:[String] = []
		
        while loc < text.count {
            if (isAlreadyCountingToChar == nil) {
                if (chars[loc] == "#") {
					if (chars.count > loc + 1) {
						if (chars[loc+1] == " ") {
							isAlreadyCountingToChar = "\n"
							parts.append(("", heading1Font))
							loc += 1
						} else if (chars.count > loc + 2 && chars[loc+1] == "#" && chars[loc+2] == " ") {
							isAlreadyCountingToChar = "\n"
							parts.append(("", heading2Font))
							loc += 2
						} else if (chars.count > loc + 3 && chars[loc+1] == "#" && chars[loc+2] == "#" && chars[loc+3] == " ") {
							isAlreadyCountingToChar = "\n"
							parts.append(("", heading3Font))
							loc += 3
						}
					}
                } else if (chars[loc] == "*") {
					if (chars.count > loc + 1) {
						if (chars[loc+1] == " ") {
							isAlreadyCountingToChar = "\n"
							parts.append(("", bulletFont))
							loc += 0
						} else if (chars.count > loc + 2 && chars[loc+1] == "*" && chars[loc+2] != " ") {
							isAlreadyCountingToChar = "*"
							isCountingToEndOfBold = 1
							parts.append(("", boldFont))
							loc += 1
						} else {
							isAlreadyCountingToChar = "*"
							parts.append(("", italicFont))
							loc += 0
						}
					}
				} else if (chars[loc] == "~") {
					if (chars.count > loc + 1) {
						if (chars.count > loc + 2 && chars[loc+1] == "~" && chars[loc+2] != " ") {
							isAlreadyCountingToChar = "~"
							isCountingToEndOfBold = 3
							parts.append(("", strikeFont))
							loc += 1
						}
					}
				} else if (chars[loc] == "`") {
						isAlreadyCountingToChar = "`"
						parts.append(("", codeFont))
						loc += 0
				} else if (chars[loc] == "_") {
					if (chars.count > loc + 1) {
						if (chars[loc+1] == " ") {
							isAlreadyCountingToChar = "\n"
							parts.append(("", bulletFont))
							loc += 0
						} else if (chars.count > loc + 2 && chars[loc+1] == "_" && chars[loc+2] != " ") {
							isAlreadyCountingToChar = "_"
							isCountingToEndOfBold = 2
							parts.append(("", boldFont))
							loc += 1
						} else {
							isAlreadyCountingToChar = "_"
							parts.append(("", italicFont))
							loc += 0
						}
					}
				} else if (chars[loc] == "[") {
					isAlreadyCountingToChar = "]"
					parts.append(("", linkFont))
					loc += 0
				} else {
					parts.append((String(chars[loc]), basicFont))
                }
            } else {
                if (chars[loc] == isAlreadyCountingToChar) {
                    if (isCountingToEndOfBold == 0) {
                        isAlreadyCountingToChar = nil
                    } else if (isCountingToEndOfBold == 1) {
                        if (chars.count > loc + 1 && chars[loc + 1] == "*") {
                            isAlreadyCountingToChar = nil
							loc += 1
							isCountingToEndOfBold = 0
                        }
                    } else if (isCountingToEndOfBold == 2) {
                        if (chars.count > loc + 1 && chars[loc + 1] == "_") {
                            isAlreadyCountingToChar = nil
							loc += 1
							isCountingToEndOfBold = 0
                        }
					} else if (isCountingToEndOfBold == 3) {
						if (chars.count > loc + 1 && chars[loc + 1] == "~") {
							isAlreadyCountingToChar = nil
							loc += 1
							isCountingToEndOfBold = 0
						}
					}
					if (chars[loc] == "\n") {
						let lastIndex = parts.count-1
						parts[lastIndex].0.append(chars[loc])
					} else if (chars[loc] == "]") {
						isAlreadyCountingToChar = ")"
						tmpLinks.append ("")
						loc += 1
					}
				} else if (chars[loc] == "\n" && isAlreadyCountingToChar != "`") {
					let lastIndex = parts.count-1
					parts[lastIndex].0.append(chars[loc])
					isAlreadyCountingToChar = nil
					isCountingToEndOfBold = 0
				} else {
					if (isAlreadyCountingToChar == ")") {
						let lastIndex = tmpLinks.count-1
						tmpLinks[lastIndex].append(chars[loc])
					} else {
						let lastIndex = parts.count-1
						parts[lastIndex].0.append(chars[loc])
					}
                }
            }
            
            loc += 1
        }
        
        self.string = ""
        var prevEndLoc = 0
		var linkIndex = 0
		
        for part in parts {
            if (part.1 != nil) {
				var fnt = part.1
				
				if ((fnt!.pointSize) < CGFloat(2)) {
					fnt = basicFont
					let atString = NSAttributedString (string: "\u{2022}" + part.0, attributes: [NSAttributedStringKey.font:fnt!, NSAttributedStringKey.foregroundColor:NSColor.controlLightHighlightColor])
					
					self.textStorage?.append(atString)
					prevEndLoc += 1
				} else if ((fnt!.pointSize) < CGFloat(3)) {
					fnt = basicFont
					let atString = NSAttributedString (string: part.0, attributes: [NSAttributedStringKey.font:fnt!, NSAttributedStringKey.foregroundColor:NSColor.controlLightHighlightColor, NSAttributedStringKey.strikethroughStyle:1])
					
					self.textStorage?.append(atString)
					//prevEndLoc += 1
				} else if ((fnt!.pointSize) < CGFloat(4)) {
					if (tmpLinks.count > linkIndex) {
						if !(["png","jpg","gif"].contains (URL(string: tmpLinks[linkIndex])?.pathExtension)) {
							fnt = basicFont
							
								let atString = NSAttributedString (string: part.0, attributes: [NSAttributedStringKey.font:fnt!, NSAttributedStringKey.foregroundColor:NSColor.controlLightHighlightColor, NSAttributedStringKey.link:tmpLinks[linkIndex], NSAttributedStringKey.underlineStyle:1])
						
								self.textStorage?.append(atString)
								//prevEndLoc += 1
						} else {
							if let url = URL(string: tmpLinks[linkIndex]) {
								let attachment = NSTextAttachment ()
								let data = FileManager.default.contents(atPath: url.absoluteString)
								if (data != nil) {
									let img = NSImage (contentsOfFile: url.absoluteString)
									let newImg = NSImage (size: (img?.resizeToFit(containerWidth: self.frame.width))!)
									let sf = img?.scaleFactorToFit(containerWidth: self.frame.width)
									newImg.lockFocus()
									let t = NSAffineTransform (transform: AffineTransform (scaleByX: 1.0, byY: 1.0))
									t.scaleX(by: 1.0, yBy: -1.0)
									t.scale(by: sf!)
									t.set()
									let cuttingRect = NSRect (origin: CGPoint (x:0,y:0), size: (img?.size)!)
									
									img?.draw(at: NSPoint (x: 0, y: 0.000-(img?.size.height)!), from: cuttingRect, operation: NSCompositingOperation.copy, fraction: 1.0)
									newImg.unlockFocus()
									
									attachment.image = newImg
									attachment.bounds = cuttingRect
									let istring = NSMutableAttributedString (attributedString: NSAttributedString(attachment: attachment))
									self.textStorage?.append(istring)
								} else {
									Swift.print ("Unable to load image")
								}
							}
						}
					}
					linkIndex += 1
				} else if ((fnt!.fontName) == "Courier") {
					let atString = NSAttributedString (string: part.0, attributes: [NSAttributedStringKey.font:fnt!, NSAttributedStringKey.foregroundColor:NSColor.controlLightHighlightColor, NSAttributedStringKey.backgroundColor:NSColor.gray])
					
					self.textStorage?.append(atString)
					//prevEndLoc += 1
				} else {
					let atString = NSAttributedString (string: part.0, attributes: [NSAttributedStringKey.font:fnt!, NSAttributedStringKey.foregroundColor:NSColor.controlLightHighlightColor])
				
					self.textStorage?.append(atString)
				}
				
				prevEndLoc += part.0.count
			}
        }
		
		(self.superview?.superview as! NSScrollView).verticalScroller?.doubleValue = tmpScrollLoc
    }
	
	override func clicked(onLink link: Any, at charIndex: Int) {
		Swift.print (link)
		if let url = URL(string: link as! String) {
			NSWorkspace.shared.open(url)
		}
	}
    
}

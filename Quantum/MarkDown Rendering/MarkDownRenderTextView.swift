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
	}
	
	func scaleFactorToFit (containerWidth: CGFloat) -> CGFloat{
		var scaleFactor : CGFloat = 1.0
		let currentWidth = self.size.width
		if currentWidth > containerWidth {
			scaleFactor = (containerWidth * 0.9) / currentWidth
		}
		return scaleFactor
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
		
		self.typingAttributes.updateValue(NSColor.lightGray, forKey: NSAttributedString.Key.foregroundColor)
		self.typingAttributes.updateValue(NSColor.clear, forKey: NSAttributedString.Key.backgroundColor)
		self.typingAttributes.removeValue(forKey: NSAttributedString.Key.font)
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
		let tmpGlyphRange = self.layoutManager?.glyphRange(forBoundingRect: self.visibleRect, in: self.textContainer!)

		parts = []
		isAlreadyCountingToChar = nil
		isCountingToEndOfBold = 0
		
		tmpLinks = []
		
		processParts(text: text)
		
        //self.string = ""
        var prevEndLoc = 0
		var linkIndex = 0
		let newString:NSTextStorage = NSTextStorage ()
		
        for part in parts {
            if (part.1 != nil) {
				var fnt = part.1
				
				if (part.2) {

					let atString = NSAttributedString (string:part.0, attributes: [NSAttributedString.Key.font:fnt!, NSAttributedString.Key.foregroundColor:NSColor.controlLightHighlightColor])

					newString.append(atString)
					prevEndLoc += 1
				} else if ((fnt!.pointSize) < CGFloat(3)) {
					fnt = basicFont
					let atString = NSAttributedString (string: part.0, attributes: [NSAttributedString.Key.font:fnt!, NSAttributedString.Key.foregroundColor:NSColor.controlLightHighlightColor, NSAttributedString.Key.strikethroughStyle:1])
					
					newString.append(atString)
					//prevEndLoc += 1
				} else if ((fnt!.pointSize) < CGFloat(4)) {
					if (tmpLinks.count > linkIndex) {
						if !(["png","jpg","gif"].contains (URL(string: tmpLinks[linkIndex])?.pathExtension)) {
							fnt = basicFont
							
								let atString = NSAttributedString (string: part.0, attributes: [NSAttributedString.Key.font:fnt!, NSAttributedString.Key.foregroundColor:NSColor.controlLightHighlightColor, NSAttributedString.Key.link:tmpLinks[linkIndex], NSAttributedString.Key.underlineStyle:1])
						
							newString.append(atString)
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
									newString.append(istring)
								} else {
									Swift.print ("Unable to load image")
								}
							}
						}
					}
					linkIndex += 1
				} else if ((fnt!.fontName) == "Courier") {
					let atString = NSAttributedString (string: part.0, attributes: [NSAttributedString.Key.font:fnt!, NSAttributedString.Key.foregroundColor:NSColor.controlLightHighlightColor, NSAttributedString.Key.backgroundColor:NSColor.gray])
					
					newString.append(atString)
					//prevEndLoc += 1
				} else {
					let atString = NSAttributedString (string: part.0, attributes: [NSAttributedString.Key.font:fnt!, NSAttributedString.Key.foregroundColor:NSColor.controlLightHighlightColor])
				
					newString.append(atString)
				}
				
				prevEndLoc += part.0.count
			}
        }
		self.textStorage?.setAttributedString(newString.attributedSubstring(from: NSRange (location: 0, length: newString.length)))
		self.scrollRangeToVisible(tmpGlyphRange!)
    }
	
	
	var parts:[(String, NSFont?, Bool)]!
	var isAlreadyCountingToChar:Character?
	var isCountingToEndOfBold:Int!
	
	var tmpLinks:[String] = []
	
	func processParts (text: String, appendingStart: Int = -1, isAlreadyBullet isAlreadyBulleti: Bool = false, startLoc: Int = 0) {
		var isAlreadyBullet = isAlreadyBulleti
		var loc:Int = startLoc
		var chars:Array<Character>! = Array (text)
		var appendingPoint = appendingStart
		while loc < text.count {
			if (isAlreadyCountingToChar == nil) {
				if (chars[loc] == "#") {
					if (chars.count > loc + 1) {
						if (chars[loc+1] == " ") {
							isAlreadyCountingToChar = "\n"
							appendingPoint += 1
							parts.insert(("", heading1Font, (false || isAlreadyBullet)), at: appendingPoint)
							
							loc += 1
						} else if (chars.count > loc + 2 && chars[loc+1] == "#" && chars[loc+2] == " ") {
							isAlreadyCountingToChar = "\n"
							appendingPoint += 1
							parts.insert(("", heading2Font, (false || isAlreadyBullet)), at: appendingPoint)
							
							loc += 2
						} else if (chars.count > loc + 3 && chars[loc+1] == "#" && chars[loc+2] == "#" && chars[loc+3] == " ") {
							isAlreadyCountingToChar = "\n"
							appendingPoint += 1
							parts.insert(("", heading3Font, (false || isAlreadyBullet)), at: appendingPoint)
							
							loc += 3
						}
					}
				} else if (chars[loc] == "*") {
					if (chars.count > loc + 1) {
						if (chars[loc+1] == " ") {
							//isAlreadyCountingToChar = "\n"
							appendingPoint += 1
							parts.insert(("\u{2022}", basicFont, true), at: appendingPoint)
							loc += 0
							isAlreadyBullet = false
						} else if (chars.count > loc + 2 && chars[loc+1] == "*" && chars[loc+2] != " ") {
							isAlreadyCountingToChar = "*"
							isCountingToEndOfBold = 1
							appendingPoint += 1
							parts.insert(("", boldFont, (false || isAlreadyBullet)), at: appendingPoint)
							
							loc += 1
						} else {
							isAlreadyCountingToChar = "*"
							appendingPoint += 1
							parts.insert(("", italicFont, (false || isAlreadyBullet)), at: appendingPoint)
							
							loc += 0
						}
					}
				} else if (chars[loc] == "~") {
					if (chars.count > loc + 1) {
						if (chars.count > loc + 2 && chars[loc+1] == "~" && chars[loc+2] != " ") {
							isAlreadyCountingToChar = "~"
							isCountingToEndOfBold = 3
							appendingPoint += 1
							parts.insert(("", strikeFont, (false || isAlreadyBullet)), at: appendingPoint)
							
							loc += 1
						}
					}
				} else if (chars[loc] == "`") {
					isAlreadyCountingToChar = "`"
					appendingPoint += 1
					parts.insert(("", codeFont, (false || isAlreadyBullet)), at: appendingPoint)
					
					loc += 0
				} else if (chars[loc] == "_") {
					if (chars.count > loc + 1) {
						if (chars[loc+1] == " ") {
							//isAlreadyCountingToChar = "\n"
							appendingPoint += 1
							parts.insert(("\u{2022} ", basicFont, true), at: appendingPoint)
							loc += 0
							isAlreadyBullet = false
						} else if (chars.count > loc + 2 && chars[loc+1] == "_" && chars[loc+2] != " ") {
							isAlreadyCountingToChar = "_"
							isCountingToEndOfBold = 2
							appendingPoint += 1
							parts.insert(("", boldFont, (false || isAlreadyBullet)), at: appendingPoint)
							
							loc += 1
						} else {
							isAlreadyCountingToChar = "_"
							appendingPoint += 1
							parts.insert(("", italicFont, (false || isAlreadyBullet)), at: appendingPoint)
							
							loc += 0
						}
					}
				} else if (chars[loc] == "[") {
					isAlreadyCountingToChar = "]"
					appendingPoint += 1
					parts.insert(("", linkFont, (false || isAlreadyBullet)), at: appendingPoint)
					
					loc += 0
				} else {
					appendingPoint += 1
					parts.insert((String(chars[loc]), basicFont, (false || isAlreadyBullet)), at: appendingPoint)
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
						let lastIndex = appendingPoint
						parts[lastIndex].0.append(chars[loc])
					} else if (chars[loc] == "]") {
						isAlreadyCountingToChar = ")"
						tmpLinks.append ("")
						loc += 1
					}
				} else if (chars[loc] == "\n" && isAlreadyCountingToChar != "`") {
					let lastIndex = appendingPoint
					parts[lastIndex].0.append(chars[loc])
					isAlreadyCountingToChar = nil
					isCountingToEndOfBold = 0
					
				} else {
					if (isAlreadyCountingToChar == ")") {
						let lastIndex = tmpLinks.count-1
						tmpLinks[lastIndex].append(chars[loc])
					} else {
						let lastIndex = appendingPoint
						parts[lastIndex].0.append(chars[loc])
					}
				}
			}
			loc += 1
			isAlreadyBullet = false
		}
//		var locy = 0
//		for part in parts {
//			if (part.2 && (part.0.contains("*") || part.0.contains("_"))) {
//				let pt = part
//				parts.remove (at:locy)
//
//				processParts(text: pt.0, appendingStart: locy - 1, isAlreadyBullet:true, startLoc: 0)
//			}
//			locy += 1
//		}
	}
	
	override func clicked(onLink link: Any, at charIndex: Int) {
		Swift.print (link)
		if let url = URL(string: link as! String) {
			NSWorkspace.shared.open(url)
		}
	}
    
}

//
//  String.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/3.
//

import Foundation

extension String {
   
    /// HEX ->  RGB 0 - 255
    func toRGB() -> (Int, Int, Int) {
        if let color = Int(self, radix: 16) {
            let mask = 0x000000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            return (r, g, b)
        }
        return (0, 0, 0)
    }
    
    /// HEX  ->  RGBA  0 - 255
    func toRGBA() -> (Int, Int, Int, Int) {
        if let color = Int(self, radix: 16) {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask
            return (r, g, b, a)
        }
        return (0, 0, 0, 0)
    }
    
   
    /// RGB -> HEX
    static func getHex(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> String {
        return String(format: "%02lX%02lX%02lX", Int(r), Int(g), Int(b))
    }
    
 
    func isLetters() -> Bool {
        return validate(regular: "[A-Z]")
    }
   
    func validate(regular expression: String) -> Bool{
        let predicate = NSPredicate(format: "SELF MATCHES %@" , expression)
        return predicate.evaluate(with: self)
    }
 
    
    var isHEXA: Bool {
        validate(regular: "^[0-F]{8}$")
    }
  
    
    func toLetter() -> String {
        if count == 0 {
            return self
        }
 
        let mString = NSMutableString(string: self)
        CFStringTransform(mString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mString, nil, kCFStringTransformStripDiacritics, false)
        
        return String(mString)
    }
}

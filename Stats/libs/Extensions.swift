//
//  Extensions.swift
//  Mini Stats
//
//  Created by Serhiy Mytrovtsiy on 29/05/2019.
//  Copyright © 2019 Serhiy Mytrovtsiy. All rights reserved.
//

import Foundation
import Cocoa

extension Double {
    func roundTo(decimalPlaces: Int) -> String {
        return NSString(format: "%.\(decimalPlaces)f" as NSString, self) as String
    }
    
    func usageColor(reversed: Bool = false) -> NSColor {
        if !colors.value {
            return NSColor.textColor
        }
        
        if reversed {
            switch self {
            case 0.6...0.8:
                return NSColor.systemOrange
            case 0.8...1:
                return NSColor.systemGreen
            default:
                return NSColor.systemRed
            }
        } else {
            switch self {
            case 0.6...0.8:
                return NSColor.systemOrange
            case 0.8...1:
                return NSColor.systemRed
            default:
                return NSColor.systemGreen
            }
        }
    }
    
    func batteryColor() -> NSColor {
        switch self {
        case 0.2...0.4:
            if !colors.value {
                return NSColor.controlTextColor
            }
            return NSColor.systemOrange
        case 0.4...1:
            if self == 1 {
                return NSColor.controlTextColor
            }
            if !colors.value {
                return NSColor.controlTextColor
            }
            return NSColor.systemGreen
        default:
            return NSColor.systemRed
        }
    }
    
    func splitAtDecimal() -> [Int64] {
        return "\(self)".split(separator: ".").map{Int64($0)!}
    }
}

public enum Unit : Float {
    case byte     = 1
    case kilobyte = 1024
    case megabyte = 1048576
    case gigabyte = 1073741824
}

public struct Units {
    public let bytes: Int64
    
    public init(bytes: Int64) {
        self.bytes = bytes
    }
    
    public var kilobytes: Double {
        return Double(bytes) / 1_024
    }
    public var megabytes: Double {
        return kilobytes / 1_024
    }
    public var gigabytes: Double {
        return megabytes / 1_024
    }
    
    public func getReadableTuple() -> (Double, String) {
        switch bytes {
        case 0..<1_024:
            return (0, "KB/s")
        case 1_024..<(1_024 * 1_024):
            return (Double(String(format: "%.2f", kilobytes))!, "KB/s")
        case 1_024..<(1_024 * 1_024 * 1_024):
            return (Double(String(format: "%.2f", megabytes))!, "MB/s")
        case (1_024 * 1_024 * 1_024)...Int64.max:
            return (Double(String(format: "%.2f", gigabytes))!, "GB/s")
        default:
            return (Double(String(format: "%.2f", kilobytes))!, "KB/s")
        }
    }
    
    public func getReadableUnit() -> String {
        switch bytes {
        case 0..<1_024:
            return "0 KB/s"
        case 1_024..<(1_024 * 1_024):
            return String(format: "%.0f KB/s", kilobytes)
        case 1_024..<(1_024 * 1_024 * 1_024):
            return String(format: "%.2f MB/s", megabytes)
        case (1_024 * 1_024 * 1_024)...Int64.max:
            return String(format: "%.2f GB/s", gigabytes)
        default:
            return String(format: "%.0f KB/s", kilobytes)
        }
    }
}

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}

extension NSBezierPath {
    func addArrow(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
        self.move(to: start)
        self.line(to: end)
        
        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))
        
        self.line(to: arrowLine1)
        self.move(to: end)
        self.line(to: arrowLine2)
    }
}

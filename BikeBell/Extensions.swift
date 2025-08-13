import Foundation

extension FixedWidthInteger {
    var bytes: [UInt8] {
        withUnsafeBytes(of: self.littleEndian) { Array($0) }
    }
} 
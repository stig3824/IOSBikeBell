import Foundation
import AVFoundation

func createBellSound() {
    let sampleRate = 44100.0
    let duration = 0.2
    let numSamples = Int(duration * sampleRate)
    let frequency = 1760.0 // A6 note
    
    // Create WAV header
    var data = Data()
    let headerSize = 44
    let dataSize = numSamples * 2 // 16-bit samples
    let fileSize = headerSize + dataSize
    
    // RIFF header
    data.append(contentsOf: "RIFF".utf8)
    data.append(contentsOf: UInt32(fileSize - 8).littleEndian.bytes)
    data.append(contentsOf: "WAVE".utf8)
    
    // Format chunk
    data.append(contentsOf: "fmt ".utf8)
    data.append(contentsOf: UInt32(16).littleEndian.bytes) // Chunk size
    data.append(contentsOf: UInt16(1).littleEndian.bytes)  // Audio format (PCM)
    data.append(contentsOf: UInt16(1).littleEndian.bytes)  // Num channels
    data.append(contentsOf: UInt32(Int(sampleRate)).littleEndian.bytes) // Sample rate
    data.append(contentsOf: UInt32(Int(sampleRate * 2)).littleEndian.bytes) // Byte rate
    data.append(contentsOf: UInt16(2).littleEndian.bytes)  // Block align
    data.append(contentsOf: UInt16(16).littleEndian.bytes) // Bits per sample
    
    // Data chunk
    data.append(contentsOf: "data".utf8)
    data.append(contentsOf: UInt32(dataSize).littleEndian.bytes)
    
    // Audio samples
    let amplitude = Int16(32767 * 0.8) // 80% of maximum amplitude
    for i in 0..<numSamples {
        let t = Double(i) / sampleRate
        let sample = Int16(Double(amplitude) * sin(2.0 * .pi * frequency * t))
        data.append(contentsOf: sample.littleEndian.bytes)
    }
    
    // Save to bundle
    let bundlePath = Bundle.main.bundlePath
    let soundPath = (bundlePath as NSString).appendingPathComponent("bell.wav")
    
    do {
        try data.write(to: URL(fileURLWithPath: soundPath))
        print("Bell sound created at: \(soundPath)")
    } catch {
        print("Failed to write sound file: \(error)")
    }
} 
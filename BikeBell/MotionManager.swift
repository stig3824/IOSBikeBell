import CoreMotion
import Combine
import UIKit

enum MotionManagerError: Error, LocalizedError {
    case accelerometerNotAvailable
    case failedToStartUpdates
    case failedToStopUpdates
    
    var errorDescription: String? {
        switch self {
        case .accelerometerNotAvailable:
            return "Accelerometer is not available on this device"
        case .failedToStartUpdates:
            return "Failed to start motion updates"
        case .failedToStopUpdates:
            return "Failed to stop motion updates"
        }
    }
}

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    private var lastShakeTime = Date()
    private let minimumShakeInterval: TimeInterval = 0.08
    
    @Published var acceleration: Double = 0.0
    @Published var isActive = false
    @Published var errorMessage: String?
    
    init() {
        motionManager.accelerometerUpdateInterval = 0.015
        queue.qualityOfService = .userInteractive
    }
    
    func startUpdates() throws {
        guard motionManager.isAccelerometerAvailable else {
            throw MotionManagerError.accelerometerNotAvailable
        }
        
        // Prevent screen from locking
        UIApplication.shared.isIdleTimerDisabled = true
        
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Motion detection error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else { return }
            
            let now = Date()
            let timeInterval = now.timeIntervalSince(self.lastShakeTime)
            
            // Only process if enough time has passed
            guard timeInterval >= self.minimumShakeInterval else { return }
            
            // Calculate acceleration components separately
            let xSquared = data.acceleration.x * data.acceleration.x
            let ySquared = data.acceleration.y * data.acceleration.y
            let zSquared = data.acceleration.z * data.acceleration.z
            
            // Calculate total magnitude
            let totalMagnitude = sqrt(xSquared + ySquared + zSquared)
            let magnitude = totalMagnitude - 0.8
            
            // Check thresholds
            let baseThreshold = 0.006
            let significantThreshold = 0.015
            
            if magnitude > baseThreshold {
                DispatchQueue.main.async {
                    self.acceleration = magnitude * 1.5
                    
                    if magnitude > significantThreshold {
                        self.lastShakeTime = now
                    }
                }
            }
        }
        
        isActive = true
    }
    
    func stopUpdates() {
        motionManager.stopAccelerometerUpdates()
        
        // Allow screen to lock again
        UIApplication.shared.isIdleTimerDisabled = false
        
        isActive = false
        acceleration = 0.0
    }
    
    deinit {
        // Make sure we re-enable screen locking when the manager is deallocated
        UIApplication.shared.isIdleTimerDisabled = false
    }
} 
import SwiftUI

struct BellAnimationView: View {
    let isRinging: Bool
    let isActive: Bool
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(Color.black)
                .frame(width: 400, height: 400)
            
            // Main bell icon
            Group {
                if let path = Bundle.main.path(forResource: bellImageName, ofType: "png") {
                    Image(uiImage: UIImage(contentsOfFile: path) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 360, height: 360)
                        .animation(.easeInOut(duration: 0.15), value: bellImageName)
                } else {
                    // Fallback to SF Symbol
                    Image(systemName: "bell.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 360, height: 360)
                        .foregroundColor(bellColor)
                        .animation(.easeInOut(duration: 0.15), value: bellColor)
                }
            }
        }
    }
    
    private var bellImageName: String {
        if !isActive {
            return "belliconred"
        } else if isRinging {
            return "belliconorange"
        } else {
            return "bellicongreen"
        }
    }
    
    private var bellImageNameWithExtension: String {
        if !isActive {
            return "belliconred.png"
        } else if isRinging {
            return "belliconorange.png"
        } else {
            return "bellicongreen.png"
        }
    }
    
    private var bellColor: Color {
        if !isActive {
            return .red
        } else if isRinging {
            return .orange
        } else {
            return .green
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        BellAnimationView(isRinging: false, isActive: false)
        BellAnimationView(isRinging: false, isActive: true)
        BellAnimationView(isRinging: true, isActive: true)
    }
    .padding()
    .background(Color.black)
} 
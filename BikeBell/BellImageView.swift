import SwiftUI

struct BellImageView: View {
    enum BellState {
        case inactive
        case ready
        case ringing
        
        var color: Color {
            switch self {
            case .inactive:
                return .red
            case .ready:
                return .green
            case .ringing:
                return .orange
            }
        }
        
        var shouldGlow: Bool {
            if case .ringing = self {
                return true
            }
            return false
        }
    }
    
    let state: BellState
    
    var body: some View {
        Image(systemName: "bell.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(state.color)
            .frame(width: 60, height: 60)
            .padding(20)
            .background(
                Circle()
                    .fill(Color.black.opacity(0.2))
                    .blur(radius: state.shouldGlow ? 20 : 0)
            )
            .shadow(color: state.shouldGlow ? Color.orange.opacity(0.8) : Color.clear, radius: 20)
            .shadow(color: state.shouldGlow ? Color.orange.opacity(0.5) : Color.clear, radius: 30)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 20) {
            BellImageView(state: .inactive)
            BellImageView(state: .ready)
            BellImageView(state: .ringing)
        }
    }
} 
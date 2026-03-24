import SwiftUI

struct ScorePill: View {
    let icon: String
    let count: Int
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption.bold())
                .foregroundColor(color)
            Text("\(count)")
                .font(.headline.bold())
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

struct StatCell: View {
    let icon: String
    let label: String
    let value: Int
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            Spacer(minLength: 2)
            
            Text("\(value)")
                .font(.system(size: 16, weight: .black))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

import SwiftUI

struct DayCounterView: View {
    let day: Int
    var isOverdue: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .fill((isOverdue ? Color.orange : Color.green).opacity(0.2))
            Text("D\(day)")
                .font(.caption.bold())
                .foregroundStyle(isOverdue ? Color.orange : Color.green)
        }
        .frame(width: 44, height: 44)
    }
}

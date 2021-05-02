// Kevin Li - 7:14 PM - 6/14/20

import SwiftUI

struct ScrollBackToTodayButton: View {

    let scrollBackToToday: () -> Void
    let color: Color

    var body: some View {
        Button(action: scrollBackToToday) {
            Image.uTurnLeft
                .resizable()
                .frame(width: 30, height: 25)
                .foregroundColor(Color(#colorLiteral(red: 0.438621819, green: 0.7752870917, blue: 0.6692710519, alpha: 1)))
        }
        .animation(.easeInOut)
    }

}

struct ScrollBackToTodayButton_Previews: PreviewProvider {
    static var previews: some View {
        LightDarkThemePreview {
            ScrollBackToTodayButton(scrollBackToToday: {}, color: .purple)
        }
    }
}

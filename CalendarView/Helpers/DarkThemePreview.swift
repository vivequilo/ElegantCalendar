// Kevin Li - 11:19 AM - 6/7/20

import SwiftUI

struct DarkThemePreview<Preview: View>: View {

    let preview: Preview

    var body: some View {
        preview
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    init(@ViewBuilder preview: @escaping () -> Preview) {
        self.preview = preview()
    }

}

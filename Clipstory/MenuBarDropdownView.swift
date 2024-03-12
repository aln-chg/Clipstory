//
//  MenuBarDropdownView.swift
//  Clipstory
//
//  Created by Alan Chang on 3/4/24.
//
import SwiftUI

struct MenuBarListView: View {
    @ObservedObject var viewModel: ClipboardHistoryViewModel
    var copyTextToClipboard: (ClipboardContent) -> Void  // Changed to ClipboardContent

    var body: some View {
        List(viewModel.clipboardItems) { item in
            HStack {
                Text(extractContent(item: item))
                    .padding(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                // Always show the copy button regardless of the content type
                Button(action: {
                    self.copyTextToClipboard(item.content)
                }) {
                    Image(systemName: "doc.on.clipboard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private func extractContent(item: ClipboardItem) -> String {
        switch item.content {
        case .text(let text):
            return text
        case .image:
            return "Image"
        }
    }
}

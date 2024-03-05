//
//  MenuBarDropdownView.swift
//  Clipstory
//
//  Created by Alan Chang on 3/4/24.
//
import SwiftUI

struct MenuBarListView: View {
    @ObservedObject var viewModel: ClipboardHistoryViewModel
    var copyTextToClipboard: (String) -> Void

    var body: some View {
        List {
            ForEach(viewModel.clipboardItems) { item in
                HStack {
                    Text(extractContent(item: item))
                        .padding(6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    if case .text(let text) = item.content {
                        Button(action: {
                            self.copyTextToClipboard(text)
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

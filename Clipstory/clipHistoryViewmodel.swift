//
//  clipHistoryViewmodel.swift
//  Clipstory
//
//  Created by Alan Chang on 2/18/24.
//

import Foundation


struct ClipboardItem: Identifiable{
    let id = UUID()
    let content: ClipboardContent
}

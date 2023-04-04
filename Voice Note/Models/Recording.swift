//
//  Recording.swift
//  Voice Note
//
//  Created by iosdev on 2.4.2023.
//

import Foundation

struct Recording {
    let fileUrl: URL
    let createdAt: Date
    var isPlaying: Bool
    var duration: TimeInterval?
}

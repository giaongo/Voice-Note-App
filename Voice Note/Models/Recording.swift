//
//  Recording.swift
//  Voice Note
//
//  Created by iosdev on 2.4.2023.
//

import Foundation

struct Recording: Identifiable /*Codable*/ {
    let id: UUID
    let fileUrl: URL
    let createdAt: Date
    var isPlaying: Bool
    var duration: TimeInterval?
}

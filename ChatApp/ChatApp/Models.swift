//
//  Models.swift
//  ChatApp
//
//  Created by Muzahid on 30/12/22.
//

import Foundation

struct SubmittedChatMessage: Encodable {
    let message: String
}

struct ReceivingChatMessage: Decodable, Identifiable {
    let date: Date
    let id: UUID
    let message: String
}

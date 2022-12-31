//
//  File.swift
//  
//
//  Created by Muzahid on 30/12/22.
//

import Foundation
struct SubmittedChatMessage: Decodable {
    let message: String
}
struct ReceivingChatMessage: Encodable, Identifiable {
    let date = Date()
    let id = UUID()
    let message: String
}

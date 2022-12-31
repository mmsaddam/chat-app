//
//  ChatScreenModel.swift
//  ChatApp
//
//  Created by Muzahid on 30/12/22.
//

import Combine
import Foundation
import SwiftUI

final class ChatScreenModel: ObservableObject {
    @Published private(set) var messages: [ReceivingChatMessage] = []
    private var webSocketTask: URLSessionWebSocketTask?
    
    init() {}
    
    func connect() {
        let url = URL(string: "ws://127.0.0.1:8080/chat")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.resume()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    func send(text: String) {
        let message = SubmittedChatMessage(message: text)
        guard let json = try? JSONEncoder().encode(message),
        let jsonString = String(data: json, encoding: .utf8)
        else { return }
        
        webSocketTask?.send(.string(jsonString), completionHandler: { error in
            if let error = error {
                print("Error in sending message:", error)
            }
        })
    }
    
    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
        webSocketTask?.receive(completionHandler: onReceive)
        if case .success(let message) = incoming {
            onMessage(message: message)
        } else if case .failure(let error) = incoming {
            print("Error \(error)")
        }
    }
    
    private func onMessage(message: URLSessionWebSocketTask.Message) {
        if case .string(let text) = message {
            guard let data = text.data(using: .utf8) else { return}
            guard let chatMessage = try? JSONDecoder().decode(ReceivingChatMessage.self, from: data) else { return  }
            
            DispatchQueue.main.async {
                self.messages.append(chatMessage)
            }
                    
        }
    }
    
    deinit {
        disconnect()
    }
    

    
}

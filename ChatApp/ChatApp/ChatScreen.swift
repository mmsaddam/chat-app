//
//  ChatScreen.swift
//  ChatApp
//
//  Created by Muzahid on 30/12/22.
//

import SwiftUI

struct ChatScreen: View {
    @State private var message = ""
    @StateObject private var model = ChatScreenModel()

    
    private func onAppear() {
        model.connect()
    }
    private func onDisappear() {
        print(#function)
        model.disconnect()
    }
    private func onCommit() {
        if !message.isEmpty {
            model.send(text: message)
            message = ""
        }
    }
    
    var body: some View {
        VStack {
            // Chat history.
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(model.messages) { message in
                        Text(message.message)
                    }
                }
            }

            // Message field.
            HStack {
                TextField("Message", text: $message, onEditingChanged: { _ in }) // 2
                    .padding(10)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(5)
                
                Button(action: onCommit) { // 3
                    Image(systemName: "arrowshape.turn.up.right")
                        .font(.system(size: 20))
                }
                .padding()
                .disabled(message.isEmpty) // 4
            }
            .padding()
        }
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
}

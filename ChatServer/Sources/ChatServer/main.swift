
import Vapor

var env =  try Environment.detect()
let app = Application(env)

defer {
    app.shutdown()
}

var clientConnections = Set<WebSocket>()

app.webSocket("chat") { req, client in
    print("connected: \(client)")
    clientConnections.insert(client)
    
    client.onClose.whenComplete { _ in
        print("Disconnected: \(client)")
        clientConnections.remove(client)
    }
    
    client.onText { _ , text in
        do {
            guard let data = text.data(using: .utf8) else {
                print("Data format invalid")
                return
            }
            let encomingMessage = try JSONDecoder().decode(SubmittedChatMessage.self, from: data)
            let outgoingMessage = ReceivingChatMessage(message: encomingMessage.message)
            
            let json = try JSONEncoder().encode(outgoingMessage)
            guard let jsonString = String(data: json, encoding: .utf8) else {
                return
            }
            
            for clientConnection in clientConnections {
                clientConnection.send(jsonString)
            }
            
        } catch {
           print(error)
        }
    }
}

try app.run()

extension WebSocket: Hashable {
    public static func == (lhs: WebSocketKit.WebSocket, rhs: WebSocketKit.WebSocket) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

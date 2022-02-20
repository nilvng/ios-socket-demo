//
//  SocketService.swift
//  socket-demo
//
//  Created by LAP11353 on 19/02/2022.
//

import Foundation
import SocketIO
var ip = "1.238"
var url = "http://bb59-2405-4803-c6b8-8c00-fd8a-f6a0-7b8-9aed.ngrok.io"
class SocketService  {
    static let shared = SocketService()
    var socket : SocketIOClient!
    var manager = SocketManager(socketURL: URL(string: url)!,
                               config: [.log(true), .reconnects(true),
                                        .forcePolling(true)])
    init(){
        socket = manager.defaultSocket
    }
    func establishConnection() {
        disconnectSocket()
        socket.on(clientEvent: .connect) {[weak self] (data, ack) in
            print("socket connected")
            self?.socket.removeAllHandlers()
        }
        socket.connect()
    }
    func disconnectSocket() {
        socket.removeAllHandlers()
        socket.disconnect()
        print("socket Disconnected")
    }

    func closeConnection() {
        socket.disconnect()
    }
    
    enum Events {

            case chat

            var emitterName: String {
                switch self {
                case .chat:
                    return "on-chat"
                }
            }

            var listnerName: String {
                switch self {
                case .chat:
                    return "user-chat"
                }
            }

            func emit(params: [String : Any]) {
                SocketService.shared.socket.emit(emitterName, params)
            }

            func listen(completion: @escaping (Any) -> Void) {
                SocketService.shared.socket.on(listnerName) { (response, emitter) in
                    completion(response)
                }
            }

            func off() {
                SocketService.shared.socket.off(listnerName)
            }
        }
}

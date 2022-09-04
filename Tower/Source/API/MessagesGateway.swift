//
//  MessagesGateway.swift
//  Tower
//
//  Created by Mat Cartmill on 2022-08-14.
//

import Foundation

protocol MessagesGateway {
    func fetchCurrentMessages(_ conversation: Identifier<Conversation>) async -> [Message]
}

class MockMessagesGateway: MessagesGateway {
    func fetchCurrentMessages(_ conversation: Identifier<Conversation>) async -> [Message] {
        return [
            .init(
                content: "Hey everyone, I’ve got something on my mind that I would love to share. Please bear with me, this could get a bit lengthy.",
                sender: Participant.sender.id
            ),
            .init(
                content: "No worries! Feel free to vent. I’m here to listen!",
                sender: Participant.receiver.id
            )
        ]
    }
}

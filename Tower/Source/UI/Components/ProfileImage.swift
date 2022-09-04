//
//  ProfileImage.swift
//  Tower
//
//  Created by Mat Cartmill on 2022-08-17.
//

import SwiftUI

struct ProfileImage: View {
    let participant: Participant
    let size: CGFloat
    
    init(participant: Participant, size: CGFloat = 40) {
        self.participant = participant
        self.size = size
    }
    
    var body: some View {
        AsyncImage(url: participant.profileImageUrl) { phase in
            switch phase {
            case .empty:
                ProgressView()
                
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                
            default: EmptyView()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(participant: .sender)
    }
}

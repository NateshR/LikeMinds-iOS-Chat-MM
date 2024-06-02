//
//  CustomMessageBubbleView.swift
//  LikemindsChatSample
//
//  Created by Devansh Mohata on 01/06/24.
//

import LikeMindsChatUI
import UIKit

final class CustomMessageBubbleView: LMChatMessageBubbleView {
    override var incomingColor: UIColor {
        .red
    }
    
    override var outgoingColor: UIColor {
        .green
    }
}

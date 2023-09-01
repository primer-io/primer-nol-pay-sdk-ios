//
//  PrimerNolPayCard.swift
//  PrimerNolPaySDK
//
//  Created by Boris on 1.9.23..
//

import Foundation
import TransitSDK

public class PrimerNolPayCard {
    public var cardNumber: String = ""
    public var expiredTime: String = ""
    
    private init(cardNumber: String, expiredTime: String) {
        self.cardNumber = cardNumber
        self.expiredTime = expiredTime
    }
    
    static func makeFrom(arrayOf nolCards: [TransitPaymentCard]) -> [PrimerNolPayCard] {
        return nolCards.map { PrimerNolPayCard(cardNumber: $0.cardNumber, expiredTime: $0.expiredTime) }
    }
}

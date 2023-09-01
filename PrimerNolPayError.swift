//
//  PrimerNolPayError.swift
//  PrimerNolPaySDK
//
//  Created by Boris on 1.9.23..
//

import Foundation
import TransitSDK

public struct PrimerNolPayError: LocalizedError {
    private var description: String
    var errorCode: Int?
        
    public static var invalidCardNumber: PrimerNolPayError {
        return PrimerNolPayError(description: "The scanned card does not match the one the user selected to pay with.")
    }
    
    public static func nolPaySdkError(code: String? = nil, message: String) -> PrimerNolPayError {
        return PrimerNolPayError(description: "Nol SDK encountered an error \(code ?? "") - \(message)")
    }
    
    public var errorDescription: String? {
        return description
    }
    
    public init(description: String, errorCode: Int? = nil) {
        self.description = description
        self.errorCode = errorCode
    }
}

extension PrimerNolPayError {
    static func makeFrom(transitSdkError: TransitSDK.TransitException) -> PrimerNolPayError {
        let error = PrimerNolPayError.nolPaySdkError(code: transitSdkError.code, message: transitSdkError.toString())
        return error
    }
}

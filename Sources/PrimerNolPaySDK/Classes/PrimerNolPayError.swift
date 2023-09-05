//
//  PrimerNolPayError.swift
//  PrimerNolPaySDK
//
//  Created by Boris on 1.9.23..
//

import Foundation
import TransitSDK

public struct PrimerNolPayError: LocalizedError {
    public var description: String
    public var errorCode: Int?
        
    public init(description: String, errorCode: Int? = nil) {
        self.description = description
        self.errorCode = errorCode
    }
    
    public static func nolPaySdkError(code: String? = nil, message: String) -> PrimerNolPayError {
        return PrimerNolPayError(description: "TransitSDK encountered an error with code[\(code ?? "")], and message[ \(message)]")
    }
}

internal extension PrimerNolPayError {
    static func makeFrom(transitSdkError: TransitSDK.TransitException) -> PrimerNolPayError {
        let error = PrimerNolPayError.nolPaySdkError(code: transitSdkError.code, message: transitSdkError.toString())
        return error
    }
}

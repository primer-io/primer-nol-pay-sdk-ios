//
//  PrimerNolPay.swift
//  Pods-PrimerNolPaySDK_Example
//
//  Created by Boris on 14.8.23..
//

import Foundation
import TransitSDK
import CoreNFC

public class PrimerNolPay {
    public static var version: String = VersionUtils.wrapperSDKVersionNumber
    public static var transitSDKVersion = VersionUtils.transitSDKVersionNumber

    private let appSecretHandler: (String, String) async throws -> String
    
    /// Initialisation of the wrapper SDK
    required public init(appId: String, isDebug: Bool, isSandbox: Bool, appSecretHandler: @escaping (String, String) async throws -> String) {
        
        self.appSecretHandler = appSecretHandler
        
        let config = TransitSDK.TransitConfiguration()
        config.setAppID(appId)
        config.enableDebug(isDebug)
        config.enableSandbox(isSandbox)
        config.setAppSecretKeyHandler { [weak self] sdkId, deviceId, completion in
            guard let self = self else {
                let error = PrimerNolPayError.nolPaySdkError(code: "-1", message: "Reference to self is lost.")
                completion(nil, error)
                return
            }
            
            Task {
                do {
                    let appSecretKey = try await self.appSecretHandler(sdkId, deviceId)
                    completion(appSecretKey, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
        Transit.initSDK(config)
    }
    
    /// Get Nol card number by scanning it with NFC
    public func scanNFCCard(completion: @escaping (Result<String, PrimerNolPayError>) -> Void) {
        
        let request = TransitGetPhysicalCardRequest()
        
        Transit.shared.getPhysicalCard(request, delegate: self) { result in
            switch result {
                
            case .success(let card):
                completion(.success(card.cardNumber))
            case .failure(let error):
                completion(.failure(PrimerNolPayError.makeFrom(transitSdkError: error)))
            }
        }
    }
    
    /// Make linking token from scanned card
    public func makeLinkingToken(for cardNumber: String, completion: @escaping (Result<String, PrimerNolPayError>) -> Void) {
        
        let request = TransitLinkPaymentCardTokenRequest()
        request.setCardNumber(cardNumber)
        
        Transit.shared.getLinkPaymentCardToken(request) { response in
            switch response {
                
            case .success(let token):
                completion(.success(token.linkToken))
            case .failure(let error):
                completion(.failure(PrimerNolPayError.makeFrom(transitSdkError: error)))
            }
        }
    }
    
    /// Trigger OTP SMS sending for linking
    public func sendLinkOTP(to mobileNumber: String,
                            with countryCode: String,
                            and token: String,
                            completion: ((Result<Bool, PrimerNolPayError>) -> Void)? = nil) {
        
        let request = TransitLinkPaymentCardOTPRequest()
        request.setMobile(mobileNumber)
        request.setRegionCode(countryCode)
        request.setLinkToken(token)
        
        Transit.shared.getLinkPaymentCardOTP(request) { response in
            switch response {
                
            case .success(let success):
                completion?(.success(success))
            case .failure(let error):
                completion?(.failure(PrimerNolPayError.makeFrom(transitSdkError: error)))
            }
        }
    }
    
    /// Link Nol payment card
    public func linkCard(for otp: String,
                         and linkToken: String,
                         completion: @escaping (Result<Bool, PrimerNolPayError>) -> Void) {
        
        let request = TransitLinkPaymentCardRequest()
        request.setOTPCode(otp)
        request.setLinkPaymentCardToken(linkToken)
        
        Transit.shared.linkPaymentCard(request) { response in
            switch response {
                
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(PrimerNolPayError.makeFrom(transitSdkError: error)))
            }
        }
    }
    
    /// Trigger OTP SMS sending for unlinking
    public func sendUnlinkOTP(to mobileNumber: String,
                              with countryCode: String,
                              and cardNumber: String,
                              completion: @escaping (Result<(String, String), PrimerNolPayError>) -> Void) {
        
        let request = TransitUnlinkPaymentCardOTPRequest()
        request.setMobile(mobileNumber)
        request.setRegionCode(countryCode)
        request.setCardNumber(cardNumber)
        
        Transit.shared.getUnlinkPaymentCardOTP(request) { response in
            switch response {
                
            case .success(let unlinkData):
                completion(.success((unlinkData.cardNumber, unlinkData.token)))
            case .failure(let error):
                completion(.failure(PrimerNolPayError.makeFrom(transitSdkError: error)))
            }
        }
    }
    
    /// Unlink payment card
    public func unlinkCard(with cardNumber: String,
                           otp: String,
                           and unlinkToken: String,
                           completion: @escaping (Result<Bool, PrimerNolPayError>) -> Void) {
        
        let request = TransitUnlinkPaymentCardRequest()
        request.setOTPCode(otp)
        request.setCardNumber(cardNumber)
        request.setUnLinkPaymentCardToken(unlinkToken)
        
        Transit.shared.unlinkPaymentCard(request) { response in
            switch response {
                
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(PrimerNolPayError.makeFrom(transitSdkError: error)))
            }
        }
    }
    
    /// Get linked cards from Nol
    public func getAvailableCards(for mobileNumber: String,
                                  with countryCode: String,
                                  completion: @escaping (Result<[PrimerNolPayCard], PrimerNolPayError>) -> Void) {
        
        let request = TransitPaymentCardListRequest()
        request.setMobile(mobileNumber)
        request.setRegionCode(countryCode)
        
        Transit.shared.getPaymentCardList(request) { result in
            switch result {
                
            case .success(let cardsResponse):
                if cardsResponse.data.count > 0 {
                    let cards = PrimerNolPayCard.makeFrom(arrayOf: cardsResponse.data)
                    completion(.success(cards))
                } else {
                    completion(.success([]))
                }
            case .failure(let error):
                completion(.failure(PrimerNolPayError.makeFrom(transitSdkError: error)))
            }
        }
    }
    
    /// Request payment
    public func requestPayment(for cardNumber: String,
                               and transactionNumber: String,
                               completion: @escaping (Result<Bool, PrimerNolPayError>) -> Void) {
        
        let request = TransitPayRequest()
        request.setCardNumber(cardNumber)
        request.setTransactionNo(transactionNumber)
        
        Transit.shared.requestPayment(request, delegate: self) { result in
            switch result {
                
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.failure(PrimerNolPayError.makeFrom(transitSdkError: error)))
            }
        }
    }
}

extension PrimerNolPay: TransitNFCReaderDelegate {
    
    public func startCardReading(_ session: NFCTagReaderSession) {
        
        session.alertMessage =  "There is an NFC transaction on your physical nol card. Please do not remove your card until the transaction is complete."
    }
    public func readCardSuccess(_ session: NFCTagReaderSession?) {
        if session != nil{
            session!.alertMessage = "Card read successfully"
        }
    }
    public func readCardFailure(_ session: NFCTagReaderSession?) {
        if session != nil{
            session!.alertMessage = "An error occured"
        }
    }
}

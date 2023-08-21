//
//  PrimerNolPay.swift
//  Pods-PrimerNolPaySDK_Example
//
//  Created by Boris on 14.8.23..
//

import Foundation
import TransitSDK


struct GetAppSecretResponse: Codable {
    let appSecretKey: String
}

public class PrimerNolPay {
    
    
    /// Initialisation of the wrapper SDK
    public init(appId: String) {
        let config = TransitSDK.TransitConfiguration()
        config.setAppID(appId)
            .enableDebug(true)
            .enableSandbox(true)
            .setAppSecretKeyHandler { sdkId, deviceId, completion in
                Task {
                    do {
                        let appSecretKey = try await self.fetchAppSecretKey()
                        print("Fetched appSecretKey: \(appSecretKey)")
                        completion(appSecretKey, nil)
                    } catch {
                        print("Error fetching appSecretKey: \(error)")
                        completion(nil, error)
                    }
                }
            }
        Transit.initSDK(config)
        Transit.shared.setLang(language: .EN)
    }
    
    private func fetchAppSecretKey() async throws -> String {
        let urlString = "https://your-api-endpoint.com/secretkey"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GetAppSecretResponse.self, from: data)
        
        return response.appSecretKey
    }
        
    /// Get Nol card number by scanning it with NFC
    public func scanNFCCard(completion: @escaping (Result<String, Error>) -> Void) {
        let request = TransitGetPhysicalCardRequest()
        request.setAccount("?????")
        Transit.shared.getPhysicalCard(request) { result in
            switch result {
                
            case .success(let card):
                completion(.success(card.cardNumber))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Make token from scanned card
    public func makeToken(for cardNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = TransitLinkPaymentCardTokenRequest()
        request.setCardNumber(cardNumber)
        
        Transit.shared.getLinkPaymentCardToken(request) { response in
            switch response {
                
            case .success(let token):
                completion(.success(token.linkToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Trigger OTP sms sending
    public func sendOTP(to mobileNumber: String,
                        with countryCode: String,
                        and token: String,
                        completion: ((Result<Bool, Error>) -> Void)? = nil) {
        
        var request = TransitLinkPaymentCardOTPRequest()
        request.setMobile(mobileNumber)
        request.setRegionCode(countryCode)
        request.setLinkToken(token)
        
        Transit.shared.getLinkPaymentCardOTP(request) { response in
            switch response {
                
            case .success(let success):
                completion?(.success(success))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    /// Vault payment card
    public func linkCard(for otp: String,
                         and token: String,
                         completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let request = TransitLinkPaymentCardRequest()
        request.setOTPCode(otp)
        request.setLinkPaymentCardToken(token)
        
        Transit.shared.linkPaymentCard(request) { response in
            switch response {
                
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    /// Trigger OTP sms sending
    public func sendUnvaultOTP(to mobileNumber: String,
                        with countryCode: String,
                        and cardNumber: String,
                        completion: @escaping (Result<(String, String), Error>) -> Void) {
        
        var request = TransitUnlinkPaymentCardOTPRequest()
        request.setMobile(mobileNumber)
        request.setRegionCode(countryCode)
        request.setCardNumber(cardNumber)
        
        Transit.shared.getUnlinkPaymentCardOTP(request) { response in
            switch response {
                
            case .success(let unlinkData):
                completion(.success((unlinkData.cardNumber, unlinkData.token)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    /// Unvault payment card
    public func unvaultCard(for cardNumber: String,
                            otp: String,
                            and token: String,
                            completion: @escaping (Result<Bool, Error>) -> Void) {
        let request = TransitUnlinkPaymentCardRequest()
        request.setOTPCode(otp)
        request.setCardNumber(cardNumber)
        request.setUnLinkPaymentCardToken(token)
        
        Transit.shared.unlinkPaymentCard(request) { response in
            switch response {
                
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

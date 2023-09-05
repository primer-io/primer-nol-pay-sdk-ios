//
//  ViewController.swift
//  PrimerNolPaySDK
//
//  Created by Boris Nikolic on 08/14/2023.
//  Copyright (c) 2023 Boris Nikolic. All rights reserved.
//

import UIKit
import CoreNFC
import PrimerNolPaySDK

class ViewController: UIViewController {
    
    private var nolPay: PrimerNolPay!
    
    // UI Components
    private var scanCardButton: UIButton!
    private var cardNumberLabel: UILabel!
    private var countryCodeTextField: UITextField!
    private var phoneNumberTextField: UITextField!
    private var submitPhoneNumberButton: UIButton!
    private var otpTextField: UITextField!
    private var submitOTPButton: UIButton!
    private var resultLabel: UILabel!
    
    private var unlinkPhoneNumberTextField: UITextField!
    private var unlinkCountryCodeTextField: UITextField!
    private var unlinkSubmitPhoneNumberButton: UIButton!
    private var unlinkOtpTextField: UITextField!
    private var unlinkSubmitOTPButton: UIButton!
    
    private var listCardsPhoneNumberTextField: UITextField!
    private var listCardsCountryCodeTextField: UITextField!
    private var listCardsButton: UIButton!
    
    private var startPaymentButton: UIButton!
    private var transactionNumberTextField: UITextField!
    
    // Data
    // link
    private var cardLinkingToken: String?
    private var linkedCardsTableView: UITableView!
    private var linkedCards: [PrimerNolPayCard] = []
    // unlink
    private var unlinkCard: PrimerNolPayCard?
    private var unlinkCardToken: String?
    // payment
    private var paymentInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nolPay = PrimerNolPay(appId: "", isDebug: true, isSandbox: true) { sdkId, deviceId in
            // Implement your API call here and return the fetched secret key
            //            Task {
            //               ... async await
            //            }
            return ""
        }
        setupUI()
    }
    
    func setupUI() {
        
        view.backgroundColor = .lightGray
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Linking
        let linkLabel = UILabel()
        linkLabel.textAlignment = .left
        linkLabel.text = "LINKING FLOW"
        
        scanCardButton = UIButton(type: .roundedRect)
        scanCardButton.setTitle("Scan NOL NFC Card", for: .normal)
        scanCardButton.addTarget(self, action: #selector(scanCardButtonTapped), for: .touchUpInside)
        
        cardNumberLabel = UILabel()
        cardNumberLabel.textAlignment = .center
        cardNumberLabel.text = "Card Number Will Appear Here"
        
        countryCodeTextField = UITextField()
        countryCodeTextField.placeholder = "Country Code"
        countryCodeTextField.borderStyle = .roundedRect
        countryCodeTextField.keyboardType = .phonePad
        
        phoneNumberTextField = UITextField()
        phoneNumberTextField.placeholder = "Phone Number"
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.keyboardType = .phonePad
        
        let phoneStackView = UIStackView(arrangedSubviews: [countryCodeTextField, phoneNumberTextField])
        phoneStackView.axis = .horizontal
        phoneStackView.spacing = 10
        phoneStackView.distribution = .fillEqually
        
        submitPhoneNumberButton = UIButton(type: .roundedRect)
        submitPhoneNumberButton.setTitle("Submit Phone Number", for: .normal)
        submitPhoneNumberButton.addTarget(self, action: #selector(submitPhoneNumberTapped), for: .touchUpInside)
        
        otpTextField = UITextField()
        otpTextField.placeholder = "Enter OTP"
        otpTextField.borderStyle = .roundedRect
        otpTextField.keyboardType = .numberPad
        
        submitOTPButton = UIButton(type: .roundedRect)
        submitOTPButton.setTitle("Submit OTP", for: .normal)
        submitOTPButton.addTarget(self, action: #selector(submitLinkOTPTapped), for: .touchUpInside)
        
        resultLabel = UILabel()
        resultLabel.textAlignment = .center
        resultLabel.text = "Results Will Appear Here"
        
        // Unlinking
        let unlinkLabel = UILabel()
        unlinkLabel.textAlignment = .left
        unlinkLabel.text = "UNLINKING FLOW"
        
        unlinkCountryCodeTextField = UITextField()
        unlinkCountryCodeTextField.placeholder = "Country Code"
        unlinkCountryCodeTextField.borderStyle = .roundedRect
        unlinkCountryCodeTextField.keyboardType = .phonePad
        
        unlinkPhoneNumberTextField = UITextField()
        unlinkPhoneNumberTextField.placeholder = "Phone Number"
        unlinkPhoneNumberTextField.borderStyle = .roundedRect
        unlinkPhoneNumberTextField.keyboardType = .phonePad
        
        let unlinkPhoneStackView = UIStackView(arrangedSubviews: [unlinkCountryCodeTextField, unlinkPhoneNumberTextField])
        unlinkPhoneStackView.axis = .horizontal
        unlinkPhoneStackView.spacing = 10
        unlinkPhoneStackView.distribution = .fillEqually
        
        unlinkSubmitPhoneNumberButton = UIButton(type: .roundedRect)
        unlinkSubmitPhoneNumberButton.setTitle("Submit Phone Number", for: .normal)
        unlinkSubmitPhoneNumberButton.addTarget(self, action: #selector(submitUnlinkPhoneNumberTapped), for: .touchUpInside)
        
        unlinkOtpTextField = UITextField()
        unlinkOtpTextField.placeholder = "Enter Unlink OTP"
        unlinkOtpTextField.borderStyle = .roundedRect
        unlinkOtpTextField.keyboardType = .numberPad
        
        unlinkSubmitOTPButton = UIButton(type: .roundedRect)
        unlinkSubmitOTPButton.setTitle("Submit unlink OTP", for: .normal)
        unlinkSubmitOTPButton.addTarget(self, action: #selector(submitUnlinkOTPTapped), for: .touchUpInside)
        
        // List linked cards
        let listCardsLabel = UILabel()
        listCardsLabel.textAlignment = .left
        listCardsLabel.text = "LIST LINKED CARDS FLOW"
        
        listCardsCountryCodeTextField = UITextField()
        listCardsCountryCodeTextField.placeholder = "Country Code"
        listCardsCountryCodeTextField.borderStyle = .roundedRect
        listCardsCountryCodeTextField.keyboardType = .phonePad
        
        listCardsPhoneNumberTextField = UITextField()
        listCardsPhoneNumberTextField.placeholder = "Phone Number"
        listCardsPhoneNumberTextField.borderStyle = .roundedRect
        listCardsPhoneNumberTextField.keyboardType = .phonePad
        
        let listPhoneStackView = UIStackView(arrangedSubviews: [listCardsCountryCodeTextField, listCardsPhoneNumberTextField])
        listPhoneStackView.axis = .horizontal
        listPhoneStackView.spacing = 10
        listPhoneStackView.distribution = .fillEqually
        
        listCardsButton = UIButton(type: .roundedRect)
        listCardsButton.setTitle("List liked cards", for: .normal)
        listCardsButton.addTarget(self, action: #selector(getLinkedCards), for: .touchUpInside)
        
        // Payment flow
        let paymentFlowLabel = UILabel()
        paymentFlowLabel.textAlignment = .left
        paymentFlowLabel.text = "PAYMENT FLOW"
        
        transactionNumberTextField = UITextField()
        transactionNumberTextField.placeholder = "Enter transaction number"
        transactionNumberTextField.borderStyle = .roundedRect
        
        startPaymentButton = UIButton(type: .roundedRect)
        startPaymentButton.setTitle("Start Payment Flow", for: .normal)
        startPaymentButton.addTarget(self, action: #selector(startPaymentFlow), for: .touchUpInside)
        
        
        let stackView = UIStackView(arrangedSubviews: [linkLabel, scanCardButton, cardNumberLabel, phoneStackView, submitPhoneNumberButton, otpTextField, submitOTPButton, resultLabel, unlinkLabel, unlinkPhoneStackView, unlinkSubmitPhoneNumberButton, unlinkOtpTextField, unlinkSubmitOTPButton, listCardsLabel, listPhoneStackView, listCardsButton, paymentFlowLabel, transactionNumberTextField, startPaymentButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        setupTableView(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),  // This makes sure our content is only scrollable vertically
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            linkedCardsTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            linkedCardsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            linkedCardsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            linkedCardsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    func setupTableView(_ contentView: UIView) {
        linkedCardsTableView = UITableView()
        linkedCardsTableView.dataSource = self
        linkedCardsTableView.delegate = self
        linkedCardsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cardCell")
        
        contentView.addSubview(linkedCardsTableView)
        
        // Add AutoLayout constraints or frame setup here
        // (For brevity, this assumes the table is taking up the entire screen below the existing UI components)
        linkedCardsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            linkedCardsTableView.topAnchor.constraint(equalTo: startPaymentButton.bottomAnchor, constant: 20),
            linkedCardsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            linkedCardsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            linkedCardsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Link
    
    @objc func scanCardButtonTapped() {
        self.nolPay.scanNFCCard { result in
            switch result {
                
            case .success(let cardNumber):
                self.cardNumberLabel.text = cardNumber
                self.nolPay.makeLinkingTokenFor(cardNumber: cardNumber) { result in
                    switch result {
                        
                    case .success(let token):
                        self.cardLinkingToken = token
                        self.showAlert(title: "Next step", message: "Enter phone number and country code")
                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc func submitPhoneNumberTapped() {
        guard let countryCode = countryCodeTextField.text, !countryCode.isEmpty,
              let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty
        else {
            showAlert(title: "Error", message: "Please enter both country code and phone number.")
            return
        }
        
        guard let linkToken = cardLinkingToken
        else {
            showAlert(title: "Error", message: "Missing a link token")
            return
        }
        
        nolPay.sendLinkOTPTo(mobileNumber: phoneNumber, withCountryCode: countryCode, andToken: linkToken) { result in
            switch result {
            case .success(let success):
                if success {
                    self.showAlert(title: "OTP Sent", message: "Check you SMS inbox")// Handle successful OTP send. Maybe update UI or show an alert.
                    
                } else {
                    self.showAlert(title: "OTP Sending failed", message: "Something went wrong")// Handle successful OTP send. Maybe update UI or show an alert.
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc func submitLinkOTPTapped() {
        guard let otp = otpTextField.text, !otp.isEmpty else {
            showAlert(title: "Error", message: "Please enter the OTP.")
            return
        }
        
        guard let linkToken = cardLinkingToken
        else {
            showAlert(title: "Error", message: "Missing a link token")
            return
        }
        
        nolPay.linkCardFor(otp: otp, andLinkToken: linkToken) { result in
            switch result {
            case .success(let success):
                if success {
                    self.showAlert(title: "Success", message: "Card linked successfully!")
                    self.getLinkedCards()
                    
                } else {
                    self.showAlert(title: "Error", message: "Failed to link the card.")
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Unlink
    
    @objc func submitUnlinkPhoneNumberTapped() {
        guard let countryCode = unlinkCountryCodeTextField.text, !countryCode.isEmpty,
              let mobileNumber = unlinkPhoneNumberTextField.text, !mobileNumber.isEmpty
        else {
            showAlert(title: "Error", message: "Please enter both country code and phone number.")
            return
        }
        
        guard let cardNumber = unlinkCard?.cardNumber
        else {
            showAlert(title: "Error", message: "Select card for unlinking.")
            return
        }
        
        nolPay.sendUnlinkOTPTo(mobileNumber: mobileNumber, withCountryCode: countryCode, andCardNumber: cardNumber) { result in
            switch result {
                
            case .success((_, let token)):
                self.unlinkCardToken = token
                self.showAlert(title: "OTP Sent", message: "Check you SMS inbox")
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc func submitUnlinkOTPTapped() {
        guard let otp = unlinkOtpTextField.text, !otp.isEmpty else {
            showAlert(title: "Error", message: "Please enter the OTP.")
            return
        }
        
        guard let cardNumber = unlinkCard?.cardNumber else {
            showAlert(title: "Error", message: "Please select card for unlinking.")
            return
        }
        
        guard let unlinkToken = unlinkCardToken
        else {
            showAlert(title: "Error", message: "Missing a unlink token")
            return
        }
        
        nolPay.unlinkCardWith(cardNumber: cardNumber, otp: otp, andUnlinkToken: unlinkToken) { result in
            switch result {
                
            case .success(let success):
                if success {
                    self.showAlert(title: "Success", message: "Card unlinked successfully!")
                    self.getLinkedCards()
                } else {
                    self.showAlert(title: "Error", message: "Failed to link the card.")
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Listing of the linked cards
    
    @objc private func getLinkedCards() {
        
        guard let phoneNumber = self.listCardsPhoneNumberTextField.text, !phoneNumber.isEmpty,
              let countryCode = self.listCardsCountryCodeTextField.text, !countryCode.isEmpty
        else {
            showAlert(title: "Error", message: "Invalid phone number or country code")
            return
        }
        
        nolPay.getAvaliableCardsFor(mobileNumber: phoneNumber, withCountryCode: countryCode) { result in
            switch result {
                
            case .success(let cards):
                self.linkedCards = cards
                self.linkedCardsTableView.reloadData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Payment flow
    
    @objc private func startPaymentFlow() {
        guard let transactionNumber = transactionNumberTextField.text, !transactionNumber.isEmpty
        else {
            self.showAlert(title: "Error", message: "Invalid transaction number")
            return
        }
        paymentInProgress = true
        showAlert(title: "Perform Payment", message: "To perform payment please select the card from the list of already linked cards")
    }
    
    private func performPaymentWith(card: PrimerNolPayCard) {
        guard let transactionNumber = transactionNumberTextField.text, !transactionNumber.isEmpty
        else {
            self.showAlert(title: "Error", message: "Invalid transaction number")
            paymentInProgress = false
            return
        }
        
        nolPay.requestPaymentFor(cardNumber: card.cardNumber, andTransactionNumber: transactionNumber) { result in
            self.paymentInProgress = false
            
            switch result {
            case .success(let success):
                if success {
                    self.showAlert(title: "Success", message: "Payment performed successfully!")
                    self.transactionNumberTextField.text = nil
                } else {
                    self.showAlert(title: "Error", message: "Failed to perform the payment.")
                }
            case let .failure(error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Helper
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linkedCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        cell.textLabel?.text = linkedCards[indexPath.row].cardNumber
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = linkedCards[indexPath.row]
        if paymentInProgress {
            performPaymentWith(card: card)
        } else {
            unlinkCard = card
            showAlert(title: "Unlink card", message: "To unlink this card enter phone number and country code, and then enter unlink OTP.")
        }
    }
}

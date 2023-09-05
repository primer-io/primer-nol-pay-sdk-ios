# PrimerNolPaySDK for iOS

PrimerNolPaySDK is a convenient iOS wrapper around the TransitSDK from Nol Payment. It facilitates interactions with the NFC Nol payment cards. Using this SDK, you can scan, link, unlink, and select NFC Nol payment cards for transactions.

The SDK provides a simple UI to demonstrate all available flows for implementation.

### Features:

- **NFC Scanning**: Scan NFC Nol payment cards.
- **Linking/Vaulting**: Safely store payment card details.
- **Unlinking**: Remove linked payment card details.
- **Transactions**: Use a selected card for payment.

## Requirements:

- iOS 13.1 or later
- Compatible with devices supporting NFC (Near Field Communication)
- Xcode 12 or later

## Installation:

### Using CocoaPods:

To integrate \`primer-nol-pay-sdk-ios\` into your Xcode project using CocoaPods, add the following line to your \`Podfile\`:

```ruby
pod 'PrimerNolPaySDK'
```

Then, run the following command in the terminal:

```
pod install
```

## Initialization:

For the example project to work:

- Set the bundle identifier of your app to match the one registered with Nol.
- Obtain an `AppId` from Nol. This ID must be used when initializing the library.
- Add NFC Capabilities
- Update content of Info.plist file

## NFC Capabilities:

To interact with NFC Nol payment cards, you'll need to enable NFC capabilities in your Xcode project:

1. Open your project in Xcode.
2. Navigate to the target settings.
3. Under the "Signing & Capabilities" tab, click on the "+ Capability" button.
4. Add "Near Field Communication Tag Reading".

## Info.plist Settings:

Add the following settings to your \`Info.plist\` to ensure proper NFC communication and network access:

```
<key>com.apple.developer.nfc.readersession.formats</key>
<array>
	<string>TAG</string>
</array>
<key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
<array>
	<string>D2760000850100</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
<key>NFCReaderUsageDescription</key>
<string>We use NFC to scan Nol payment card. (or whatever fits your needs)</string>
```
NSAllowsArbitraryLoads set to `true`` is required during the development while using the Sandbox environment.

## Usage:

```swift
...
import PrimerNolPaySDK

let primerNolPay = PrimerNolPay(appId: "<Your-AppID>", isDebug: true, isSandbox: true) { sdkId, deviceId in
    return ""
}
```
You will probably want to set debug and sandbox flags to false in PRODUCTION environment.


### Linking a Card:

```swift
primerNolPay.scanNFCCard { result in
    switch result {
    case .success(let cardNumber):
        print("Scanned Card Number: \(cardNumber)")
    case .failure(let error):
        print("Error scanning card: \(error)")
    }
}
```


First, create a token for the scanned card:

```swift
primerNolPay.makeLinkingTokenFor(cardNumber: "<Scanned-Card-Number>") { result in
    // Handle result
}
```

Then, send an OTP for linking:

```swift
primerNolPay.sendLinkOTPto(mobileNumber: "<Mobile-Number>", withCountryCode: "<Country-Code>", andToken: "<Token>") { result in
    // Handle result
}
```

Finally, link the card using the OTP:

```swift
primerNolPay.linkCardFor(otp: "<OTP>", andLinkToken: "<Token>") { result in
    // Handle result
}
```

### Unlinking a Card:

Start by sending an OTP for unlinking:

```swift
primerNolPay.sendUnlinkOTPTo(mobileNumber: "<Mobile-Number>", withCountryCode: "<Country-Code>", andCardNumber: "<Card-Number>") { result in
    // Handle result
}
```

Then, unlink the card using the OTP:

```swift
primerNolPay.unlinkCardWith(cardNumber: "<Card-Number>", otp: "<OTP>", andUnlinkToken: "<Token>") { result in
    // Handle result
}
```

### Get Linked Cards:

```swift
primerNolPay.getAvaliableCardsFor(mobileNumber: "<Mobile-Number>", withCountryCode: "<Country-Code>") { result in
    // Handle result
}
```

### Request Payment:

```swift
primerNolPay.requestPaymentFor(cardNumber: "<Card-Number>", andTransactionNumber: "<Transaction-Number>") { result in
    // Handle result
}
```

## Example Project:

The repository includes an example project that showcases the full capabilities of `PrimerNolPaySDK`. 

## Troubleshooting:

If you face any issues, please check if your bundle identifier matches the one registered with Nol and ensure that the \`AppId\` provided by Nol is correctly used during initialization.

## License:

See the [LICENSE](LICENSE) file for more details.

## Contributions:

Pull requests are welcome! We'd love to hear your feedback and improvements.

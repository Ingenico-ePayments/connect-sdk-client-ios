Ingenico Connect iOS SDK (Objective-C)
=======================

**This SDK has been rebranded to Worldline. As part of the rebranding the SDK has moved to https://github.com/Worldline-Global-Collect/connect-sdk-client-ios.**

---

The Ingenico Connect objective-C iOS SDK provides a convenient way to support a large number of payment methods inside your iOS app.
It supports iOS 6.1 and up out-of-the-box.
The objective-C iOS SDK comes with an [example app](https://github.com/Ingenico-ePayments/connect-sdk-client-ios-example) that illustrates the use of the SDK and the services provided by Ingenico ePayments on the Ingenico ePayments platform.

See the [Ingenico Connect Developer Hub](https://epayments.developer-ingenico.com/documentation/sdk/mobile/ios/) for more information on how to use the SDK.

Use the SDK with Carthage or CocoaPods
---------------------------------------
The Ingenico Connect objective-c SDK is available via two package managers: [CocoaPods](https://cocoapods.org/) or [Carthage](https://github.com/Carthage/Carthage).

### CocoaPods

You can add the objective-c SDK as a pod to your project by adding the following to your `Podfile`:

```
$ pod 'IngenicoConnectKit'
```

Afterwards, run the following command:

```
$ pod install
```

### Carthage

You can add the objective-c SDK with Carthage, by adding the following to your `Cartfile`:

```
$ github "Ingenico-ePayments/connect-sdk-client-ios"
```

Afterwards, run the following command:

```
$ carthage update
```


Run the SDK locally
------------
To obtain the objective-c SDK, first clone the code from GitHub:

```
$ git clone https://github.com/Ingenico-ePayments/connect-sdk-client-ios.git
```

Open the Xcode project that is included to test the SDK.
Afterwards, you can open and run the Xcode workspace that is now created to test the SDK.


Known issues
------------
There are known issues with the AFNetworking Library when it is built in xCode 11. If you include our SDK via Carthage, it is likely that you will encounter this issue. Please see [this Github issue](https://github.com/AFNetworking/AFNetworking/issues/4408) for more information and workarounds. 

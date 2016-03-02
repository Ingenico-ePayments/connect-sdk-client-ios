Ingenico Connect - iOS SDK
=======================

The Ingenico Connect iOS SDK provides a convenient way to support a large number of payment methods inside your iOS app.
It supports iOS 6.1 and up out-of-the box.
The iOS SDK comes with an example app that illustrates the use of the SDK and the services provided by Ingenico ePayments on the GlobalCollect platform.

The documentation is available on [https://developer.globalcollect.com/documentation/sdk/ios/](https://developer.globalcollect.com/documentation/sdk/ios/).

Installation
------------

To install the iOS SDK and the example app, first download the code from GitHub.

```
$ git clone https://github.com/Ingenico-ePayments/connect-sdk-client-ios.git
```

Afterwards, you can open and run the Xcode project you just downloaded to execute the example app.

To use the iOS SDK in your own app, you need to add the folders `GlobalCollectSDK` and `AFNetworking` to your project.
The code in these folders depends on the `Foundations`, `UIKit`, and `CoreGraphics` frameworks, which you should add as resources to your project as follow:

1. Select your project in the project navigator.
2. Select your app as a target.
3. Switch to the general tab.
4. Use the plus icon under `Linked Frameworks and Libraries` to add the following three frameworks:
  * CoreGraphics.framework
  * UIKit.framework
  * Foundation.framework

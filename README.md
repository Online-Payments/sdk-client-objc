Online Payments Objective-C SDK
=========================

The Online Payments objective-c SDK provides a convenient way to support a large number of payment methods inside your iOS app.
It supports iOS 9.0 and up out of the box.
The objective-c SDK comes with an example app that illustrates the use of the SDK and the services provided by the Online Payments platform.


Use the SDK with Carthage or CocoaPods
---------------------------------------
The Online Payments objective-c SDK is available via two package managers: [CocoaPods](https://cocoapods.org/) or [Carthage](https://github.com/Carthage/Carthage).

### CocoaPods

You can add the objective-c SDK as a pod to your project by adding the following to your `Podfile`:

```
$ pod 'OnlinePaymentsSDK'
```

Afterwards, run the following command:

```
$ pod install
```

### Carthage

You can add the Swift SDK with Carthage, by adding the following to your `Cartfile`:

```
$ github "online-payments/sdk-client-objc"
```

Afterwards, run the following command:

```
$ carthage update --use-xcframeworks
```

Navigate to the ```Carthage/Build``` directory, which was created in the same directory as where the ```.xcodeproj``` or ```.xcworkspace``` is. Inside this directory the ```.xcframework``` bundle is stored. Drag the ```.xcframework``` into the "Framework, Libraries and Embedded Content" section of the desired target. Make sure that it is set to "Embed & Sign".

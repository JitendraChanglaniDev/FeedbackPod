# FeedbackPod

![LogCamp](http://www.kahuna-mobihub.com/templates/ja_puresite/images/logo-trans.png)

A Swift 3.0 framework for integrating feedback screen to your project. Simple and quick to use.

## Installation

### CocoaPods

Setting up with [CocoaPods](http://cocoapods.org/?q=FeedbackPod)

```ruby
 pod 'FeedbackPod', '~> 1.2'
```


### Swift Code to navigate to feedback screen:

Import pod FeedbackPod
```swift
import FeedbackPod

```
You can copy paste below code and provide the details required to integrate the feedback screen.

```swift

// write below code in viewDidLoad of your controller
let bundle = Bundle(identifier: "org.cocoapods.FeedbackPod") // as need to access the Xib from other bundle
let controller = FeedbackVC(nibName: "FeedbackVC", bundle: bundle) // get the controller object

controller.appID = Constants.AppKeys.KALoggerAppID // provide KALogger id  
controller.appKey = Constants.AppKeys.KALoggerAppKey // provide KALogger application key
controller.langCode = self.getSelectedLanguageTextCode() // optional if your application supports language support e.g :- "en" , "es"
controller.submitButtonColor = Constants.AppColors.firstButtonColor // provide button color according to the theme of application
controller.userName = "" // optional if user is logged in
controller.userFirstName = "" // optional if user is logged in
controller.userLastName = "" // optional if user is logged in

// code to make feedback screen as child view of your controller
addChildViewController(controller)
self.view.addSubview(controller.view)
controller.view.frame = view.bounds
controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
controller.didMove(toParentViewController: self)

```
 Finally if you app has language support then in Localizable.string file provide below keys 
```swift
// Do not provide below keys if your app supports only Engish language as it is by default provided
// Feedback Screen keys
"keyPlaceHolder"                          = "Write your review here";
"keyHowInfoLabel"                         = "How Happy are you with VAP?";
"keyUserFeedback"                         = "User Feedback";
"keyMessage"                              = "Please rate us or write something in feedback";
"keyAppFeedBack"                          = "%@ App Feedback";
"keyThankYou"                             = "Thank you";
"keyFeedbackSubmitted"                    = "Your feedback submitted successfully";
"keyGallery"                              = "Gallery";
"keySelectSource"                         = "Select source";
"keyDelete"                               = "Delete";
"keyPreview"                              = "Preview";
"keyCameraText"                               = "Camera";
"keyPhotos"                               = "Photos";
"keyFeedbackOrComment"                         = "Your Feedback/Comments";
"keySubmit"                               = "Submit";
"keyOkButtonLabel"                        = "OK";
"keySourceNotAvailable"                   = "Source type not available";
"keyProcessing"                           = "Loading..";
"keyNetworkError"                         = "Network Error";
"keyNoInternet"                           = "Application requires network access either through WiFi or Mobile network.";
"keyCancelButtonlabel"                    = "Cancel";


```
Note:- Please make sure that your Xcode app is at /Application/Xcode destination.

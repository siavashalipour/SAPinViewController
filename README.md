# SAPinViewController

[![CI Status](http://img.shields.io/travis/Siavash/SAPinViewController.svg?style=flat)](https://travis-ci.org/siavashalipour/SAPinViewController.svg?branch=master)
[![Version](https://img.shields.io/cocoapods/v/SAPinViewController.svg?style=flat)](http://cocoapods.org/pods/SAPinViewController)
[![License](https://img.shields.io/cocoapods/l/SAPinViewController.svg?style=flat)](http://cocoapods.org/pods/SAPinViewController)
[![Platform](https://img.shields.io/cocoapods/p/SAPinViewController.svg?style=flat)](http://cocoapods.org/pods/SAPinViewController)

Simple and easy to use iOS 7 PIN screen. This simple library allows you to draw a fully customisable PIN screen same as the iOS default PIN view.
My inspiration to create this library was form [THPinViewController](https://github.com/antiraum/THPinViewController), however ```SAPinViewController``` is completyly implemented in ```Swift 2.2```. Also the main purpose of creating this library was to have simple, easy to use and fully customisable PIN screen.
## Features
- Support both iPhone and iPad landscape/portrait
- Designed with the help of [SnapKit](https://github.com/SnapKit/SnapKit)
- Fully customisable:
	- change title font/color
	- change subtitle font/color
	- change numbers font/color
	- change alphabet font/color
	- change numbers boundry color
	- change PIN dots color
	- add solid backgournd color
	- add custom image as background and gets blured automatically
	- hide alphabets
	- change cancel button font/color
	
## Usage
```swift
// initial a "SAPinViewController" via the designate initialiser
let pinVC = SAPinViewController(withDelegate: self, backgroundImage: UIImage(named: "bg3"))
// setup different properties
pinVC.subtitleText = "Your passcode is required to enable Touch ID"
pinVC.buttonBorderColor = UIColor.whiteColor()
pinVC.alphabetColor = UIColor.whiteColor()
pinVC.showAlphabet = true // default is true
// ... and other properties
// present it
presentViewController(pinVC, animated: true, completion: nil)
// implement delegate methods
extension ViewController: SAPinViewControllerDelegate {
    func pinEntryWasCancelled() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func pinEntryWasSuccessful() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func pinWasIncorrect() {

    }
    func isPinValid(pin: String) -> Bool {
        return pin == pinString
    }
}
```
## Screenshots
<img src="4s.png" width="49%" />
<img src="6.png" width="69%" />
<img src="6Plus.png" width="79%" />
<img src="5.png" width="59%" />
<img src="ipad-landscape.png" width="66%" />
<img src="iPad-potrait.png" width="66%" />
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- Minimum iOS 8

## Installation

SAPinViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SAPinViewController"
```

## Author

Siavash, siavash@siavashalipour.com

## License

SAPinViewController is available under the MIT license. See the LICENSE file for more info.

## License
If you have any feature requests or bugfixes feel free to create an issue or send a pull request. 

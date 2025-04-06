---
title: "FlexibleAVCapture: An Swift/iOS library for taking videos with any rectangular frame."
# image: "/images/tech-blog/slug/image.jpg"
description: "I created a library FlexibleAVCapture to take any rectangular shaped videos."
published: "2019-03-17"
updated: "2025-04-06"
category: "tech"
tags:
  [
    "hahnah's-library",
    "swift",
    "ios",
    "flexible-av-capture",
    "video",
    "flex-camera",
  ]
---

[FlexibleAVCapture](https://cocoapods.org/pods/FlexibleAVCapture) provides a kind of AV capture view controller with flexible camera frame. It includes default capture settings, preview layer, buttons, tap-gesture focusing, pinch-gesture zooming, and so on.

## Screen Capture

![screencapture](/images/tech-blog/2019-swift-flexible-av-capture/screencapture.gif)

## Example

You can try 2 examples. One is included in the pods and the another is on App Store.  
These 2 are almost same, but the one on App Store is more practical and better reference.

### Pods Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Flex Camera on App Store

You can download "Flex Camera" app from App Store.  
~~https://itunes.apple.com/us/app/flex-camera/id1455345286~~

NOTE: Currently, it is not available on App Store in 2025, but you can still see its source code on GitHub.

![flex camera](/images/tech-blog/2019-swift-flexible-av-capture-en/flex-camera-icon.avif)

See the fllowing post for its summary.  
[https://hahnah.github.io/tech-blog/2019-flex-camera-en/](https://hahnah.github.io/tech-blog/2019-flex-camera-en/)

And here is the source code of Flex Camera.  
[https://github.com/hahnah/FlexCamera](https://github.com/hahnah/FlexCamera)

## Installation of FlexibleAVCapture

FlexibleAVCapture is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'FlexibleAVCapture'
```

## Usage

Your view controller should satisfy the following conditions:

- Adopt `FlexibleAVCaptureDelegate` protocol and implement `didCapture(withFileURL fileURL: URL)` function.
- Create an `FlexibleAVCaptureViewController` object and set its `delegate`.

```swift
import UIKit
import FlexibleAVCapture

class ViewController: UIViewController, FlexibleAVCaptureDelegate {

    let flexibleAVCaptureVC: FlexibleAVCaptureViewController = FlexibleAVCaptureViewController()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.flexibleAVCaptureVC.delegate = self
        self.present(flexibleAVCaptureVC, animated: true, completion: nil)
    }

    func didCapture(withFileURL fileURL: URL) {
        print(fileURL)
    }

}
```

## API

API Informations in this section are for version 2.1.0.  
Visit [https://cocoapods.org/pods/FlexibleAVCapture](https://cocoapods.org/pods/FlexibleAVCapture) for the latest version.

### FlexibleAVCaptureViewController

An object that manages capture settings and a session. It also displays a preview layer and handles user interactions.

| Topics                    | API                                                                                                                                                                                                                           |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Initializing              | `init() -> FlexibleAVCaptureViewController`: Initializes a FlexibleAVCaptureViewController object with back camera.                                                                                                           |
|                           | `init(cameraPosition: AVCaptureDevice.Position) -> FlexibleAVCaptureViewController`: Initializes a FlexibleAVCaptureViewController object to use back camera or front camera.                                                 |
| Managing Interactions     | `var delegate: FlexibleAVCaptureDelegate?`: The object that acts as the delegate of the flexible AV capture view.                                                                                                             |
| Managing Capture Settings | `var allowsResizing: Bool`: A Boolean value that indicates whether users can resize camera frame. Allowing this feature hides a resizing slider and resizing buttons. The default value of this property is **true**.         |
|                           | `var allowsReversingCamera: Bool`: A Boolean value that indicates whether users can make the camera position reversed. Allowing this feature hides a camera-reversing button. The default value of this property is **true**. |
|                           | `var allowsSoundEffect: Bool`: A Boolean value that indicates whether sound effect rings at the beginning and the ending of video recording. The default value of this property is **true**.                                  |
|                           | `var cameraPosition: AVCaptureDevice.Position`: The camera position being used to capture video. Back camera will be used by default. (This is a get-only property.)                                                          |
|                           | `var maximumRecordDuration: CMTime`: The longest duration allowed for the recording. The default value of this property is **invalid**, which indicates no limit.                                                             |
|                           | `var minimumFrameRatio: CGFloat`: The ratio of the vertical(or horizontal) edge length in the full frame when the wideset(or tallest) frame is applied. The default value of this property is **0.34**.                       |
|                           | `var videoQuality: AVCaptureSession.Preset`: A constant value indicating the quality level or bit rate of the output. The default value of this property is **medium**. (This is a get-only property.)                        |
|                           | `func canSetVideoQuality(_ videoQuality: AVCaptureSession.Preset) -> Bool`: Returns a Boolean value that indicates whether the receiver can use the given preset.                                                             |
|                           | `func forceResize(withResizingParameter resizingParameter: Float) -> Void`: Recieve a Float value between 0.0 and 1.0 and resize the camera frame using the value.                                                            |
|                           | `func reverseCameraPosition() -> Void`: Change the camera position to the oppsite of the current position.                                                                                                                    |
|                           | `func setVideoQuality(_ videoQuality: AVCaptureSession.Preset) -> Void`: Change the video capturing quality.                                                                                                                  |
| Replasing Default UI      | `func replaceFullFramingButton(with button: UIButton) -> Void`: Replace the existing full-framing button.                                                                                                                     |
|                           | `func replaceResizingSlider(with slider: UISlider) -> Void`: Replace the existing resizing slider. The slider's range will be forced to be 0.0 to 1.0.                                                                        |
|                           | `func replaceRecordButton(with button: UIButton) -> Void`: Replace the existing record button.                                                                                                                                |
|                           | `func replaceReverseButton(with button: UIButton) -> Void`: Replace the existing camera-position-reversing button.                                                                                                            |
|                           | `func replaceSquareFramingButton(with button: UIButton) -> Void`: Replace the existing square-framing button.                                                                                                                 |
|                           | `func replaceTallFramingButton(with button: UIButton) -> Void`: Replace the existing tall-framing button.                                                                                                                     |
|                           | `func replaceWideFramingButton(with button: UIButton) -> Void`: Replace the existing wide-framing button.                                                                                                                     |

### FlexibleAVCaptureDelegate

Defines an interface for delegates of FlexibleAVCaptureViewController to respond to events that occur in the process of recording a single file.  
The delegate of an FlexibleAVCaptureViewController object must adopt the FlexibleAVCaptureDelegate protocol.

| Topics           | API                                                                                                                                      |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Delegate Methods | `didCapture(withFileURL fileURL: URL) -> Void`: Informs the delegate when all pending data has been written to an output file. Required. |

## Source Code on GitHub

You can see the whole source code of FlexibleAVCapture on GitHub.  
[https://github.com/hahnah/FlexibleAVCapture](https://github.com/hahnah/FlexibleAVCapture)

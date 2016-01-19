# DrawPathView
[![CI Status](http://img.shields.io/travis/Ahmet Kazım Günay/DrawPathView.svg?style=flat)](https://travis-ci.org/Ahmet Kazım Günay/DrawPathView)
[![Version](https://img.shields.io/cocoapods/v/DrawPathView.svg?style=flat)](http://cocoapods.org/pods/DrawPathView)
[![License](https://img.shields.io/cocoapods/l/DrawPathView.svg?style=flat)](http://cocoapods.org/pods/DrawPathView)
[![Platform](https://img.shields.io/cocoapods/p/DrawPathView.svg?style=flat)](http://cocoapods.org/pods/DrawPathView)

Drawable View with any colors you want to fill and can be erased last path or all paths anytime

![Anim](https://github.com/ahmetkgunay/DrawPathView/blob/master/anim.gif)

## Usage

Usage is simple, you can just add as a subview DrawPathView which is inheritted from UIView to any Custom view.

```swift

    lazy var drawView : DrawPathView = {
        let dv = DrawPathView(frame: self.view.bounds)
        dv.delegate = self
        return dv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(drawView)
    }
```

User also can delete paths as last drawn path or all paths at the same time.

```swift
internal func eraseLast() {
        drawView.clearLast()
    } 
    
internal func eraseAll() {
		drawView.clearAll()
	}
```
#### Delegates

DrawPathView has also two delegate methods :

- viewDrawStartedDrawing 	: Calls when user started drawing
- viewDrawEndedDrawing 		: Calls when user ended drawing


```swift

// MARK: - DrawPathView Delegate -

    func viewDrawStartedDrawing() {
        print("Started Drawing")
    }
    
    func viewDrawEndedDrawing() {
        print("Ended Drawing")
    }

```

## Requirements


## Installation

DrawPathView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DrawPathView"
```

## Author

Ahmet Kazım Günay, ahmetkgunay@gmail.com

## License

DrawPathView is available under the MIT license. See the LICENSE file for more info.

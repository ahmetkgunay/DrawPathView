# DrawPathView
Drawable View with any colors you want to fill and can be erased last path or all paths anytime

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

### Delegates

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
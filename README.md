# slidingmessage
===========

slidingmessage is a simple message view that slides down from the top of its parent. It's a way of displaying error messages in an iOS app that draws the user's attention. It can be configured to slide down to just under any control in a view, for example, under a text field with invalid input.

- The internal class name for the control is "ErrorView". 
- Requires AutoLayout. 
- Tapping anywhere closes the view. An X graphic is included to give users the hint that they can close it.
- Optionally closes automatically after N seconds.


## Example usage:
--------------

### Creating the control:
```swift
self.errorView = ErrorView(parentView: self.view,
    autoHideDelaySeconds: 5,
    backgroundColor: UIColor.redColor(),
    foregroundColor: UIColor.whiteColor(),
    minimumHeight: 100,
    positionBelowControl: button,   // "button" is any UIControl
    font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
```

### Showing the message:
-------------------
```swift
@IBAction func buttonPressed(sender: AnyObject)
{
    self.errorView?.showErrorView(self.textField.text)
}
```


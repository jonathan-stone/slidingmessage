# slidingmessage
===========

slidingmessage is a simple message view that slides down from the top of its parent. It's a way of displaying error messages or other important notifications in an iOS app, using an animation to draw the user's attention. It can be configured to slide down to just under any control in a view, for example, under a text field with invalid input.

- Requires AutoLayout. 
- Tapping anywhere closes the view. An X graphic is included to give users the hint that they can close it.
- Optionally closes automatically after N seconds.


## Example usage:
--------------

### Creating the control:
```swift
self.errorNotification = SlidingMessage(
    parentView: self.view,
    autoHideDelaySeconds: 5,
    backgroundColor: UIColor.redColor(),
    foregroundColor: UIColor.whiteColor(),
    minimumHeight: 100,
    positionBelowControl: self.requiredTextField,   // can be any UIControl
    font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
```

### Showing the message:
-------------------
```swift
@IBAction func buttonPressed(sender: AnyObject)
{
    if (self.requiredTextField.Text.isEmpty)
    {
        self.errorNotification?.show("You have to enter something!")
    }
}
```

## Demo project
Can be found in slidingMessageDemo.

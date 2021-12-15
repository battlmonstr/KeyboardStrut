# KeyboardStrut

KeyboardStrut is an utility to prevent the iOS virtual keyboard to cover your text fields and obscure typing.
This library provides a view - KeyboardStrutView - that adapts its size to the keyboard size.
It can be used as a dynamic strut to control the overall layout
by placing the other views relative to the KeyboardStrutView.

https://user-images.githubusercontent.com/11477595/146223574-19e4ae96-17f9-46b0-9611-07ecb4b923af.mov

## Example

Let's say there's a form with a text field that is shown at the bottom of the screen like this:

```Swift
let nameLabel = UILabel(frame: .zero)
nameLabel.text = "Enter your name:"
let nameField = UITextField(frame: .zero)
nameField.placeholder = "type your name here"

let form = UIStackView(arrangedSubviews: [
    nameLabel,
    nameField,
    KeyboardStrutView(frame: .zero),
])
form.axis = .vertical
form.alignment = .center

self.view.addSubview(form)
form.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    form.leftAnchor.constraint(equalTo: self.view.leftAnchor),
    form.rightAnchor.constraint(equalTo: self.view.rightAnchor),
    form.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200),
])
```

Without KeyboardStrutView when the virtual keyboard is open, it goes on top of the text field, and the form becomes hidden.
The KeyboardStrutView fixes this issue: it pushes the form up or down as needed.

KeyboardStrutView can also be placed outside of the form at the bottom of your view if you set up the constraints for it:

```Swift
let keyboardStrut = KeyboardStrutView(frame: .zero)
keyboardStrut.translatesAutoresizingMaskIntoConstraints = false
self.view.addSubview(keyboardStrut)
NSLayoutConstraint.activate([
    keyboardStrut.leftAnchor.constraint(equalTo: self.view.leftAnchor),
    keyboardStrut.rightAnchor.constraint(equalTo: self.view.rightAnchor),
    keyboardStrut.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
])

self.view.addSubview(form)
form.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    form.leftAnchor.constraint(equalTo: self.view.leftAnchor),
    form.rightAnchor.constraint(equalTo: self.view.rightAnchor),
    form.bottomAnchor.constraint(equalTo: keyboardStrut.topAnchor, constant: -200),
])
```

## XIB/Storyboard

This can also be used in a XIB or Storyboard:

1. Add a plain UIView view to the scene.
1. In the identity inspector pane set the class name KeyboardStrutView, module KeyboardStrut.
1. Create left, right and bottom constraints to be equal to the root view.
1. Create a constant height constraint, go to its properties in the size inspector pane, and set a checkbox "Placeholder - Remove at build time". This constraint is only needed during the IB design time to see how the layout looks like. In runtime it will be replaced by the real keyboard height if it is open, and zero otherwise.

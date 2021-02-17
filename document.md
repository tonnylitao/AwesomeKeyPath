# DataBinding with KeyPath

## One-way data binding
```swift
struct User {
    var aString:        String?
    var aButtonTitle:   String?
}

let userBinding = KPDataBinding<User>()

userBinding.bind([
    \.aString => uiLabel,
    \.aButtonTitle => uiButton,
])

userBinding.update(\.aString, with: "A new text")

//userBinding.model.aString == "A new text"
//uiLabel.text == "A new text"


userBinding.update(\.aButtonTitle, with: "A new title")

//userBinding.model.aButtonTitle == "A new title"
//uiButton.title(for: .normal) == "A new title"
```
##### Customised one-way data binding

* render a customised data in view

```swift
struct User {
    var aInt: Int
}

userBinding.oneWayBind(\.aInt, toLabel, { view, value in
    view.text = "Your Age: \(value)"
})

userBinding.update(\.aInt, with: 1)

//userBinding.model.aInt == 1
//uiLabel.text == "Your Age: 1"
```

## Two-way data binding

```swift
struct User {
    var aString:    String?
    var isOn:       Bool
    var isSelected: Bool
    var isSelected: Bool
    var aFloat:     Float
    var aDouble:    Double
}

userBinding.bind([
    \.aString     <=> uiTextField,
    \.isOn        <=> uiSwitcher,
    \.isSelected  <=> uiButton,
    \.aFloat      <=> uiSlider,
    \.aDouble     <=> uiSteper,
])

//view value and model value will be equal 

//userBinding.model.isOn == uiSwitcher.isOn

//userBinding.model.isSelected == uiButton.isSelected

//userBinding.model.aFloat == uiSlider.value

//userBinding.model.aDouble == uiSteper.value
```

Note: This text of UITextField is @"" by default. https://developer.apple.com/documentation/uikit/uitextfield/1619635-text

```
userBinding.update(\.aString, with: nil)
//userViewModel.model.aString == nil
//uiTextField.text == ""

userBinding.update(\.aString, with: "A new String")
//userBinding.model.aString == "A new String"
//uiTextField.text == "A new String"
```

##### Format and type cast in two-way data binding

* data formatted before when update model 
* render a customised data in view

```swift
userBinding.twoWayBind(\.age, ageSteper, formatter: { view, modal in
    return Int(view.value)
}, render: { view, value in
    view.value = Double(value)
})

//uiSteper's value changed to 3.0
//userBinding.model.aInt == Int(3.0)

//userBinding.model.aInt == 1
//uiSteper.value == Double(1)

```

## Update model and view

Always update model through ViewModel, and the binding view will be updated automatically.

```
userBinding.update(\User.name, with: "A new Name")
```

## Unbind

```
userBinding.unbind(\User.name)
```

## How KeyPath works in Data Binding?

```swift
model[keyPath: \User.name] = "Tonny"       //update model
view[keyPath: \UITextField.text] = "Tonny" //update view


view[keyPath: \UITextField.text] = model[keyPath: \User.name]  //update view from model


view.addTarget(self, #selector(viewChanged), for: event)

func viewChanged(view: UITextField) {
    model[keyPath: \User.name] = view[keyPath: \UITextField.text]  //update model from view
}
```
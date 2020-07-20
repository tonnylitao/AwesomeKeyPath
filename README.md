# AwesomeKeyPath


### Why KeyPath is awesome?

* KeyPath in Data Binding

```swift
viewModel.bind(User(), [
    uiLabel       <-   \User.title,
    uiTextField   <->  \User.email,
])
```

* KeyPath in validation

```swift
guard user.validate(
    \.email.isEmpty.not, 
    \.email.isEmail
) else {
	return
}
```

### Installation

```ruby
pod 'AwesomeKeyPath'
```

### Features

* Take advantage of KeyPath not only in model but also in views
* One-way and Two-way data binding
* Multiple views binding to one model's property
* Data format and casting
* Infix operators
* unbind
* validation


### One-way data binding
```swift
struct User {
    var aString:        String?
    var aButtonTitle:   String?
}

let userViewModel = KPDataBindingViewModel<User>()

userViewModel.bind(User(), [
    uiLabel     <-  \User.aString,
    uiButton    <-  \User.aButtonTitle,
])

userViewModel.update(\.aString, with: "A new text")

//userViewModel.model.aString == "A new text"
//uiLabel.text == "A new text"


userViewModel.update(\.aButtonTitle, with: "A new text")

//userViewModel.model.aButtonTitle == "A new text"
//uiButton.title(for: .normal) == "A new text"
```
##### Type casting in one-way data binding

* format data for display in view

```swift
struct User {
    var aInt: Int
}

userViewModel.bind(User(), [
    uiLabel <~ (\User.aInt, toLabel: { $0.text = "Your Age: \($0)" }),
])

userViewModel.update(\.aInt, with: 1)

//userViewModel.model.aInt == 1
//uiLabel.text == "Your Age: 1"
```

### Two-way data binding

```swift
struct User {
    var aString:    String?
    var isOn:       Bool
    var isSelected: Bool
    var isSelected: Bool
    var aFloat:     Float
    var aDouble:    Double
}

userViewModel.bind(initialData, [
    uiTextField     <-> \User.aString,
    uiSwitcher      <-> \User.isOn,
    uiButton        <-> \User.isSelected,
    uiSlider        <-> \User.aFloat,
    uiSteper        <-> \User.aDouble,
])

//view value and model value will be equal 

//userViewModel.model.isOn == uiSwitcher.isOn

//userViewModel.model.isSelected == uiButton.isSelected

//userViewModel.model.aFloat == uiSlider.value

//userViewModel.model.aDouble == uiSteper.value
```

Note: This text of UITextField is @"" by default. https://developer.apple.com/documentation/uikit/uitextfield/1619635-text

```
userViewModel.update(\.aString, with: nil)
//userViewModel.model.aString == nil
//uiTextField.text == ""

userViewModel.update(\.aString, with: "A new String")
//userViewModel.model.aString == "A new String"
//uiTextField.text == "A new String"
```

##### Format and type cast in two-way data binding

* format data for display in view
* type cast view's value to model 

```swift
userViewModel.bind(initialData, [
    ageSteper <~> (\User.age, { $0.value = Double($1) }, { view, _ in Int(view.value) }),
])

userViewModel.update(\.aInt, with: 1)

//userViewModel.model.aInt == 1
//uiSteper.value == Double(1)


//uiSteper's value changed to 3.0
//userViewModel.model.aInt == Int(3.0)
```

### Update model and view

Always update model through ViewModel, and the binding views will updated automatically.

```
userViewModel.update(\User.name, with: "A new Name")
```

### Unbind

```
userViewModel.unbind(\User.name)
```

## Data binding with KPDataBinding in action
```swift
import AwesomeKeyPath-DataBinding

class ViewController: UIViewController {
    
    @IBOutlet weak var groupNameLbl:     UILabel!
    @IBOutlet weak var nameField:        UITextField!
    @IBOutlet weak var emailField:       UITextField!
    @IBOutlet weak var ageLbl:           UILabel!
    @IBOutlet weak var ageSteper:        UIStepper!
    @IBOutlet weak var activitySlider:   UISlider!
    @IBOutlet weak var likeKiwiSwitcher: UISwitch!
    @IBOutlet weak var travelBtn:        UIButton!
    @IBOutlet weak var hikingBtn:        UIButton!
    @IBOutlet weak var readingBtn:       UIButton!
    
    lazy var userViewModel = KPDataBindingViewModel<User>()
    
    
    override func viewDidLoad() {
        
        let initialData = User(groupName: "Save NZ Animals Group 1", name: "Tonny")
        
        userViewModel.bind(initialData, [
            groupNameLbl     <-  \User.groupName,
            travelBtn        <-  \User.name,
            
            nameField        <-> \User.name,
            emailField       <-> \User.email,
            activitySlider   <-> \User.activity,
            likeKiwiSwitcher <-> \User.likeKiwi,
            travelBtn        <-> \User.travel,
            hikingBtn        <-> \User.hiking,
            readingBtn       <-> \User.reading,

            ageLbl           <~  (\User.age, { $0.text = "Your Age: \($1)" }),
            
            ageSteper        <~> (\User.age, { $0.value = Double($1) }, { view, _ in Int(view.value) }),
        ])
    }
    
    @IBAction func submit(_ sender: Any) {
        let data = userViewModel.model
        
        ...
    }
}
```

### How KeyPath works in DataBinding?

```swift
model[keyPath: \User.name] = "Tonny"       //update model
view[keyPath: \UITextField.text] = "Tonny" //update view


view[keyPath: \UITextField.text] = model[keyPath: \User.name]  //update view from model


view.addTarget(self, #selector(viewChanged), for: event)

func viewChanged(view: UITextField) {
    model[keyPath: \User.name] = view[keyPath: \UITextField.text]  //update model from view
}
```

### Validation

```swift
@IBAction func submit(_ sender: Any) {
    let data = userViewModel.model
    
    guard data.validate(\.name.isSome, \.name!.isNotEmpty) else {
        nameField.becomeFirstResponder()
        return
    }

    guard data.validate(\.email.isSome, \.email!.isEmail, { $0.email!.count > 5 }) else {
        emailField.becomeFirstResponder()
        return
    }
    
    ...
}
```


## License

AwesomeKeyPath is available under the MIT license. See the LICENSE file for more info.

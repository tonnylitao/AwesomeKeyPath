## KeyPath is awesome 🤟


* Using KeyPath in Data Binding, one way and two way both are easy-peasy

```swift
let user = User(title: "Mr.", email: "")

viewModel.bind(user, [
    uiLabel       <-   \.title,  //one way data binding
    uiTextField   <->  \.email,  //two way data binding
])
```

* Using KeyPath in Validation, KeyPath is coordinated with closures.

```swift
guard user.validate(
    \.email.isEmpty.not, 
    \.email.isEmail, 
    { $0.email.hasSuffix("@gmail.com") }
) else {    
    return
}
```

* Transform KeyPath into Closure

```swift
let closure1: (User) -> Bool = \User.password.count + { $0 >= 8 && $0 <= 20 }

let closure2: (User) -> String.Index? = \User.name + { $0.firstIndex(of: "T") }
```

## AwesomeKeyPath in Action [Read More](document.md)

### Installation

```ruby
pod 'AwesomeKeyPath'
```

### One-way data binding, Two-way data binding and Validation

```swift
import AwesomeKeyPath

class ViewController: UIViewController {
    
    @IBOutlet weak var groupNameLbl:     UILabel!
    
    @IBOutlet weak var nameField:        UITextField!
    @IBOutlet weak var emailField:        UITextField!
    
    @IBOutlet weak var ageLbl:           UILabel!
    @IBOutlet weak var ageSteper:        UIStepper!
    @IBOutlet weak var activitySlider:   UISlider!
    @IBOutlet weak var likeKiwiSwitcher: UISwitch!
    @IBOutlet weak var travelBtn:        UIButton!
    
    lazy var userViewModel = KPDataBindingViewModel<User>()
    
    
    override func viewDidLoad() {
        
        let initialData = User(groupName: "Save NZ Animals Group 1", name: "Tonny")
        
        userViewModel.bind(initialData, [
            groupNameLbl     <-  \User.groupName,
         
            nameField        <-> \User.name,
            emailField       <-> \User.email,
	    
            activitySlider   <-> \User.aFloat,
            likeKiwiSwitcher <-> \User.isOn,
            travelBtn        <-> \User.isSelected,

            ageLbl           <~  (\User.age, { $0.text = "Your Age: \($1)" }),
            
            ageSteper        <~> (\User.age, { $0.value = Double($1) }, { view, _ in Int(view.value) }),
        ])
    }
    
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
}
```

## License

AwesomeKeyPath is available under the MIT license. See the LICENSE file for more info.

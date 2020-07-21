## KeyPath is awesome 🤟


* Using KeyPath in Data Binding

```swift
let user = User(title: "Mr.", email: "")

viewModel.bind(, [
    uiLabel       <-   \.title,  //one way data binding
    uiTextField   <->  \.email,  //two way data binding
])
```

* Using KeyPath in Validation

```swift
guard user.validate(\.email.isEmpty.not, \.email.isEmail) else {
    return
}
```

## AwesomeKeyPath in action

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

[Read More](document.md)

## License

AwesomeKeyPath is available under the MIT license. See the LICENSE file for more info.

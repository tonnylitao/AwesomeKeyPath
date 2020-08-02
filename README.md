## KeyPath is awesome 🤟
A library of KeyPath make code more expressive in data binding, validation, caculation and more.

### Installation

```ruby
pod 'AwesomeKeyPath'
```

### Using KeyPath in Data Binding, one way and two way both are easy-peasy

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
...
```

### Using KeyPath in Validation, KeyPath is coordinated with closures.

KeyPath transforms into closure automatically when type casting.

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
}
```

### Using KeyPath with [Swift Operators](https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations)

Given a list of User

```js
[
  {
    "gender": "female",
    "name": { "title": "Miss", "first": "Louane", "last": "Vidal" },
    "location": {
      "street": { "number": 2479, "name": "Place du 8 Février 1962" },
      "city": "Avignon",
      "state": "Vendée",
      "country": "France",
      "postcode": 78276,
      "coordinates": {
        "latitude": "2.0565",
        "longitude": "95.2422"
      }
    },
    "email": "louane.vidal@example.com",
    "dob": { "date": "1966-06-26T11:50:25.558Z", "age": 54 },
    "registered": { "date": "2016-08-11T06:51:52.086Z", "age": 4 },
    "phone": "02-62-35-18-98",
    "cell": "06-07-80-83-11",
    "id": { "name": "INSEE", "value": "2NNaN01776236 16" },
    "picture": {
      "large": "https://randomuser.me/api/portraits/women/88.jpg",
      "medium": "https://randomuser.me/api/portraits/med/women/88.jpg",
      "thumbnail": "https://randomuser.me/api/portraits/thumb/women/88.jpg"
    },
    "nat": "FR",
    "isAdmin": true
  },...
]
```
KeyPath makes code concise and expressive

```swift
typealias Rule = (User) -> Bool

let rule1: Rule = \.gender == "male"
let rule2: Rule = \.name.title.isEmpty
let rule3: Rule = \.name.first.count > 3
let rule4: Rule = \.name.last.count < 10
let rule5: Rule = \.location.postcode >= 70000
let rule6: Rule = \.location.postcode != 75000
let rule7: Rule = \.location.postcode <= 80000
let rule8: Rule = \.location.coordinates.latitude == 2.0565
let rule9: Rule = \.email.isEmail
let rule10: Rule = { $0.email.hasSuffix("@example.com") }
let rule11: Rule = \.picture.large.isEmpty.not
let rule12: Rule = \.isAdmin

let result = arr.filter(
    (rule1 && rule2 && rule3 && rule4 && rule5 && rule6) ||
    (rule7 && rule8 && rule9 && rule10 && rule11 && rule12)
).sorted(by: \.name.first)

XCTAssertNotNil(result.first)
```

### More fun with KeyPath and Closure

```swift
let closure1: (User) -> Bool = (\User.password.count).closure{ $0 >= 8 && $0 <= 20 }

let closure2: (User) -> String.Index? = (\User.name).closure{ $0.firstIndex(of: "T") }

let result1 = arr.map(\User.some + 10 * \User.another)

let result2 = arr.filter(\.name) { $0.count > 2 }

let result3 = arr.map(\.name) { $0.count }

arr.forEach(\.name) { print($0) }

```

[Read More](document.md)


## License

AwesomeKeyPath is available under the MIT license. See the LICENSE file for more info.

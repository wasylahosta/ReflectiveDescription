# ReflectiveDescription

ReflectiveDescription is a library that uses the reflection to print a description of an instance of any type.

# Example

```swift
class Person {
    
    let fullName: String
    let nickname: String?
    let age: Int
    let pets: [Pet]
    
    init(fullName: String, nickname: String?, age: Int, pets: [Pet]) {
        self.fullName = fullName
        self.nickname = nickname
        self.age = age
        self.pets = pets
    }
}

struct Pet {
    
    let name: String
    let species: Species
    
    enum Species {
        case cat
        case dog
    }
}

let aCat = Pet(name: "Jack", species: .cat)
let aDog = Pet(name: "Max", species: .dog)
let aPerson = Person(fullName: "John Doe", nickname: nil, age: 42, pets: [aCat, aDog])
print(reflectiveDescription(of: aPerson))
```
##### Console output
```
Person {
  fullName: (String) "John Doe"
  nickname: (String?) nil
  age: (Int) 42
  pets: Array<Pet> {
    Pet {
      name: (String) "Jack"
      species: (Species) cat
    }
    Pet {
      name: (String) "Max"
      species: (Species) dog
    }
  }
}
```

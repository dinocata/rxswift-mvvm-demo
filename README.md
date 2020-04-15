# RxSwift Clean Architecture demo
This project is based on https://github.com/sergdort/CleanArchitectureRxSwift with some significant differences:

- Project is split into 3 main target modules: <b>Application</b>, <b>Data</b> and <b>Domain</b>
- Application contains UI-specific implementation and dependency containers
- Data contains platform-specific data providers (networking and local persistence) and repository implementations
- Domain contains entities, use cases, use case implementations and repository definitions

It utilizes automatic dependency injection through <a href="https://github.com/krzysztofzablocki/Sourcery">Sourcery </a> annotations and <a href="https://github.com/Swinject/Swinject">Swinject</a>.

Routing is handled globally through a Coordinator, while view controllers are abstracted into Scenes.

This is an ongoing project, so some things (like tests, storage and local persistence examples) are on the TODO list.


<b>HOW TO BUILD THE PROJECT:</b>
- Install <a href="https://github.com/krzysztofzablocki/Sourcery">Sourcery </a> via <code>brew install sourcery</code>
- Inside the project's root directory run the following command: <code>sourcery --config .sourceryInit.yml</code>. This will generate annotated code and link the generated files into the project. You only need to run this command once, since the code will be automatically generated each time you build the project through a build phase run script.


<b>ANNOTATIONS</b>

There are 3 main Sourcery annotations which define how will your boiler plate code be generated:
- <code>// sourcery: injectable</code>

Registers a protocol or class into the instance container. Example:
```swift
// sourcery: injectable
protocol Service {}

class ServiceImpl: Service {
  // Some implementation
}
```
The above code will register <code>Service</code> into a global instance container through Swinject and resolve it as <code>ServiceImpl</code>, provided you have a defined implementation class. If a class is annotated, the class itself will be resolved.

Now comes the magic part. After a type is annotated with <code>injectable</code>, it will be automatically injected in any other <code>injectable</code> type when used as a dependency.

For example, the following code will inject <code>ServiceImpl</code> into <code>RepositoryImpl</code>:
```swift
// sourcery: injectable
protocol Repository {}

class RepositoryImpl: Repository {
  
  var service: Service!
}
```
Important note: All dependencies should be defined as force-unwrapped variables, because Sourcery is injecting the dependencies AFTER the instance is initialized.

You can also define a implementation class explicitly with annotation parameter:
```swift
// sourcery: injectable = Dog
protocol Animal {}

class Dog: Animal {
  // Some implementation
}

// sourcery: injectable = Owner
protocol Person {}

// Owner will have a pet Dog
class Owner: Person {
  var pet: Animal!
}
```

You can even explicitly choose which implementation to inject with, if you have multiple types conforming to the same protocol, for example:
```swift
// sourcery: injectable
class Dog: Animal {}

// sourcery: injectable
class Cat: Animal {}

class Owner: Person {
  // sourcery: inject = Cat
  var pet: Animal!
}
```
You can always manually resolve an instance, same as Sourcery does it under-the-hood. For example, <code>InstanceContainer.instance.resolve(Person.self)!</code> for the above example will return an instance of <code>Owner</code>, who has a pet <code>Cat</code>. But you should rarely, if ever need to do this.



- <code>// sourcery: singleton</code>

Registers a protocol or class into the instance container as a singleton when combined with <code>injectable</code>. In other words, it does exactly the same as <code>injectable</code>, but the instance is resolved from a singleton <code>AppContainer</code> instead. Example:
```swift
// sourcery: injectable, singleton
protocol Repository {}

class RepositoryImpl: Repository {
  // Some implementation
}
```

- <code>// sourcery: scene</code>

Defines a Scene for the annotated view controller.

All view controllers are mapped into an abstract Scene enum, which is code-generated. Scenes are used to perform coordinator transitions. You can always resolve a new view controller instance mapped to a Scene with <code>Scene.someScene.viewController</code> if you need to do something specific with a view controller other than navigating. For example, adding it as a child view controller to a tab view controller.

Important note: All view controllers should subclass either a MVVMController or CoordinatorVC in order for this annotation to work.

Example usage:
```swift
// sourcery: scene = dashboard, transition = present, navigation
class DashboardViewController: CoordinatorVC<DashboardViewModel> {
  // Some implementation
}
```
The above will register a <code>DashboardViewController</code> to a <code>ViewControllerContainer</code> and generate a new Scene enum case <code>dashboard</code> which can be used to perform navigation with a <code>coordinator</code>. Every view controller subclassing CoordinatorVC has a reference to a global coordinator. There are two optional parameters:
  
  - transition - defines transition type when navigating (can be root, push, present or modal)
  - navigation - wraps the view controller into a UINavigationController
  
You can now navigate to this view controller with:
```swift
self.coordinator.transition(to: .dashboard)
```
You can also explicitly define a transition type and a completion block:
```swift
self.coordinator.transition(to: .dashboard, type: .push) { print("Transition done!") }
```

If you need to pass some parameters to the view controller, you can use <code>parameter</code> annotation and Sourcery will automatically define these parameters as associated values in the enum case:
```swift
// sourcery: scene = dashboard, transition = present, navigation
class DashboardViewController: CoordinatorVC<DashboardViewModel> {
  // sourcery:begin: parameter
  var someParam: String!
  var anotherParam: Int!
  // sourcery:end
}

// When navigating:
self.coordinator.transition(to: .dashboard(someParam: "Hello World!", anotherParam: 5))
```

...and lastly:

This is <b>NOT</b> a library or a framework. It is an example iOS project written in RxSwift and following Clean Architecture patterns with minimal boiler plate. You are free to use the Sourcery .stencil templates found in the Templates/ directory inside the root folder and modify them however you like. The annotation feature is completely custom and architecture-independent. You only need <a href="https://github.com/krzysztofzablocki/Sourcery">Sourcery </a> and <a href="https://github.com/Swinject/Swinject">Swinject</a> in your project for it to work. Rest is just an example usage.

# RxSwift Clean Architecture demo
This project is based on https://github.com/sergdort/CleanArchitectureRxSwift with some significant differences:

- Project is split into 3 main modules: <b>Application</b>, <b>Data</b> and <b>Domain</b>
- Application contains UI-specific implementation and dependency containers
- Data contains platform-specific data providers (networking and local persistence) and repository implementations
- Domain contains entities, use cases, use case implementations and repository definitions

It utilizes automatic dependency injection through <a href="https://github.com/krzysztofzablocki/Sourcery">Sourcery </a> annotations and <a href="https://github.com/Swinject/Swinject">Swinject</a>.

Routing is handled globally through a Coordinator, while view controllers are abstracted into Scenes.

This is an ongoing project, so some things (like test examples) are on the TODO list.

Documentation will be updated with more details in the future.

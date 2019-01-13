# mvvm-demo
A simple and clean demo project written in RxSwift for MVVM and coordinator pattern, which utilizes dependency injection using <a href="https://github.com/Swinject/Swinject">Swinject</a>.

<h3>TODO</h3>

-Split project structure into following modules (subject to change):

<b>Application</b><br>
-app delegate<br>
-DI<br>
-config (constants)<br>

<b>Presentation</b><br>
-UI<br>
-routing<br>

<b>Common</b><br>
-helpers<br>
-extensions (including custom Rx exts)<br>
-protocols<br>
-enums<br>
-base classes<br>
-custom views<br>

<b>Domain</b><br>
-API (network, endpoint definition, models)<br>
-api services<br>
-repositories<br>

<b>Persistence</b><br>
-Core Data (model extensions, core data stack, core data manager, migrations)<br>
-User Defaults & Keychain access<br>
<br>
<br>
-Add unit test examples

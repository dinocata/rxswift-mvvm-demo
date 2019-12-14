# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MVVM-Demo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MVVM-Demo
  pod 'SwiftLint'
  pod 'Sourcery'
  pod 'Swinject'
  pod 'RxSwift', '~> 5', :inhibit_warnings => true
  pod 'RxCocoa', '~> 5', :inhibit_warnings => true
  pod 'Moya/RxSwift', '~> 13.0', :inhibit_warnings => true
  pod 'RxDataSources', '~> 4.0', :inhibit_warnings => true
  pod 'KeychainAccess'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'TPKeyboardAvoiding'
  pod 'AlamofireNetworkActivityLogger', '~> 2.3'

  target 'MVVM-DemoTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest',     '~> 4.0'
  end
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          if target.name == 'RxSwift'
              target.build_configurations.each do |config|
                  if config.name == 'Debug'
                      config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                  end
              end
          end
      end
  end

end

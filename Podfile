# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'
inhibit_all_warnings!

def shared_test
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest',     '~> 4.0'
end

def rx_swift
    pod 'RxSwift', '~> 4.0'
end

def rx_cocoa
    pod 'RxCocoa', '~> 4.0'
end

target 'MVVM-Demo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MVVM-Demo
  rx_swift
  rx_cocoa

  pod 'SwiftLint'
  pod 'Sourcery'
  pod 'Swinject'

  pod 'Moya/RxSwift', '~> 13.0'
  pod 'RxDataSources', '~> 3.0'
  pod 'KeychainAccess'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'TPKeyboardAvoiding'
  pod 'AlamofireNetworkActivityLogger', '~> 2.3'

  target 'MVVM-DemoTests' do
    inherit! :search_paths
    # Pods for testing
    shared_test
  end
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
          end
      end
  end
end

target 'PersistencePlatform' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    rx_swift
    rx_cocoa
end

target 'PresentationPlatform' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    rx_swift
    rx_cocoa
end


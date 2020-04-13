# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'

# ignore all warnings from all pods
inhibit_all_warnings!

def default_pods
  pod 'SwiftLint'
  pod 'Sourcery'
  pod 'RxSwift', '~> 5'
end

target 'Application' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  default_pods
  
  pod 'Swinject'
  
  pod 'RxCocoa', '~> 5'
  pod 'SnapKit', '~> 5.0.0'
  
  pod 'MBProgressHUD', '~> 1.2.0'
end

target 'Data' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  default_pods
  
  pod 'Moya/RxSwift', '~> 14.0'
end

target 'Domain' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  default_pods
end

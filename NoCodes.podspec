Pod::Spec.new do |s|
  s.name         = 'NoCodes'
  s.swift_version = '5.5'
  s.version      = '0.0.4'
  s.summary      = 'qonversion.io'
  s.description  = <<-DESC
  Qonversion No-Codes SDK is a standalone software development kit designed to help you build and customize paywall screens without writing code. It allows seamless integration of pre-built subscription UI components, enabling a faster and more flexible way to design paywalls directly within your app. While it operates independently, the No-Codes SDK relies on the Qonversion SDK as a dependency to handle in-app purchases and subscription management.
  DESC
  s.homepage                  = 'https://github.com/qonversion/no-codes-ios'
  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Qonversion Inc.' => 'hi@qonversion.io' }
  s.source                    = { :git => 'https://github.com/qonversion/no-codes-ios.git', :tag => s.version.to_s }
  s.framework                 = 'StoreKit'
  s.platforms    = { :ios => "13.0" }
  s.ios.frameworks            = ['UIKit', 'WebKit']
  s.requires_arc              = true
  s.resource_bundles          = {'NoCodes' => ['Sources/PrivacyInfo.xcprivacy']}
  s.source_files              = 'Sources/NoCodes/**/*.{h,m,swift}'
  s.dependency "Qonversion", "5.13.3"
end

source 'https://github.com/CocoaPods/Specs.git'

project 'Qonversion'
use_frameworks!

target 'Sample' do
platform :ios, 13.0
pod 'Firebase/Auth', '8.9.0'
pod 'GoogleSignIn', '6.0.2'
pod 'NoCodes', :path => './'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts target.name
  end
end

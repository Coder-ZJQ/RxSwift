# https://github.com/CocoaPods/CocoaPods/issues/9159#issuecomment-530374178
pre_install do |installer|
    original_sand = installer.sandbox
    def original_sand.project_path
        return @root + 'RX.xcodeproj'
    end
end

use_frameworks!
workspace 'RxSwift.xcworkspace'
platform :ios, '9.0'

target 'Combinestagram-observables' do
  project 'Practices/01-observables-in-practice/Combinestagram-observables.xcodeproj'
  pod 'RxSwift'
  pod 'RxRelay'
end

target 'Combinestagram-filtering' do
  project 'Practices/02-filtering-operators-in-practice/Combinestagram-filtering.xcodeproj'
  pod 'RxSwift'
  pod 'RxRelay'
end

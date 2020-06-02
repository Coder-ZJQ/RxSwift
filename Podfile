# https://github.com/CocoaPods/CocoaPods/issues/9159#issuecomment-530374178
pre_install do |installer|
    original_sand = installer.sandbox
    def original_sand.project_path
        return @root + 'Rx.xcodeproj'
    end
end

use_frameworks!
workspace 'RxSwift.xcworkspace'
platform :ios, '9.0'

target '01.Combinestagram-observables' do
  project 'Practices/01-observables-in-practice/01.Combinestagram-observables.xcodeproj'
  pod 'RxSwift'
  pod 'RxRelay'
end

target '02.Combinestagram-filtering' do
  project 'Practices/02-filtering-operators-in-practice/02.Combinestagram-filtering.xcodeproj'
  pod 'RxSwift'
  pod 'RxRelay'
end

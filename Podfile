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

pod 'RxSwift'
pod 'RxRelay'

target '01.Combinestagram-observables' do
  project 'Practices/01-observables-in-practice/01.Combinestagram-observables.xcodeproj'
end

target '02.Combinestagram-filtering' do
  project 'Practices/02-filtering-operators-in-practice/02.Combinestagram-filtering.xcodeproj'
end

target '03.GitFeed-transforming' do
  project 'Practices/03-transformng-operators-in-practice/03.GitFeed-transforming.xcodeproj'
  pod 'RxCocoa'
  pod 'Kingfisher'
end

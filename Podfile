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

target '04.ourplanet-combining' do
  project 'Practices/04-combining-operators-in-practice/04.ourplanet-combining.xcodeproj'
  pod 'RxCocoa'
end

target '05.Wundercast-beginning-rxcocoa' do
  project 'Practices/05-beginning-rxcocoa/05.Wundercast-beginning-rxcocoa.xcodeproj'
  pod 'RxCocoa'
end

target '06.Wundercast-intermediate-rxcocoa' do
  project 'Practices/06-intermediate-rxcocoa/06.Wundercast-intermediate-rxcocoa.xcodeproj'
  pod 'RxCocoa'
end

target '07.Wundercast-error-handling' do
  project 'Practices/07-error-handling-in-practice/07.Wundercast-error-handling.xcodeproj'
  pod 'RxCocoa'
end

target '08.Schedulers' do
  platform :osx, '10.12'
  project 'Practices/08-intro-to-schedulers/08.Schedulers.xcodeproj'
  pod 'RxSwift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end

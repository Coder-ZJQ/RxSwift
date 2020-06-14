# https://github.com/CocoaPods/CocoaPods/issues/9159#issuecomment-530374178
pre_install do |installer|
    original_sand = installer.sandbox
    def original_sand.project_path
        return @root + 'Rx.xcodeproj'
    end
end

use_frameworks!
inhibit_all_warnings!
workspace 'RxSwift.xcworkspace'
platform :ios, '12.0'

target '00.Playgrounds-Support' do
  project 'Practices/00.Playgrounds-Support/00.Playgrounds-Support.xcodeproj'
  pod 'RxSwift', '4.4.1'
  pod 'RxCocoa', '4.4.1'
end

target '01.Combinestagram-observables' do
  project 'Practices/01-observables-in-practice/01.Combinestagram-observables.xcodeproj'
  pod 'RxSwift', '4.4.1'
  pod 'RxCocoa', '4.4.1'
end

target '02.Combinestagram-filtering' do
  project 'Practices/02-filtering-operators-in-practice/02.Combinestagram-filtering.xcodeproj'
  pod 'RxSwift', '4.4.1'
  pod 'RxCocoa', '4.4.1'
end

target '03.GitFeed-transforming' do
  project 'Practices/03-transformng-operators-in-practice/03.GitFeed-transforming.xcodeproj'
  pod 'Kingfisher'
end

target '04.ourplanet-combining' do
  project 'Practices/04-combining-operators-in-practice/04.ourplanet-combining.xcodeproj'
  pod 'RxSwift', '4.4.1'
  pod 'RxCocoa', '4.4.1'
end

target '05.Wundercast-beginning-rxcocoa' do
  project 'Practices/05-beginning-rxcocoa/05.Wundercast-beginning-rxcocoa.xcodeproj'
  pod 'RxSwift', '4.4.1'
  pod 'RxCocoa', '4.4.1'
end

target '06.Wundercast-intermediate-rxcocoa' do
  project 'Practices/06-intermediate-rxcocoa/06.Wundercast-intermediate-rxcocoa.xcodeproj'
  pod 'RxSwift', '4.4.1'
  pod 'RxCocoa', '4.4.1'
end

target '07.Wundercast-error-handling' do
  project 'Practices/07-error-handling-in-practice/07.Wundercast-error-handling.xcodeproj'
  pod 'RxSwift', '4.4.1'
  pod 'RxCocoa', '4.4.1'
end

target '08.Schedulers' do
  platform :osx, '10.14'
  project 'Practices/08-intro-to-schedulers/08.Schedulers.xcodeproj'
  pod 'RxSwift', '4.4.1'
end

target 'Testing' do
  project 'Practices/09.testing-with-rxtest/09.Testing.xcodeproj'
  pod 'RxSwift', '4.4.1'
  pod 'RxCocoa', '4.4.1'
  pod 'Hue'

  target 'TestingTests' do
    pod 'RxTest', '4.4.1'
    pod 'RxBlocking', '4.4.1'
  end
end

target 'iGif' do
  project 'Practices/10.creating-custom-reactive-extension/10.iGif-extension.xcodeproj'
  pod 'RxSwift', '4.4.1'
  pod 'SwiftyJSON'
  pod 'Gifu', :git => 'https://gitee.com/coder-zjq/Gifu.git'

  target 'iGifTests' do
    pod 'Nimble'
    pod 'RxNimble'
    pod 'RxBlocking', '4.4.1'
    pod 'OHHTTPStubs'
    pod 'OHHTTPStubs/Swift'
  end
  
end

abstract_target 'TweetieAbstract' do
  project 'Practices/11.Tweetie-mvvm-with-rxswift/11.Tweetie-mvvm.xcodeproj'
  pod 'Alamofire'
    pod 'RxSwift', '4.4.1'
    pod 'RxCocoa', '4.4.1'
    pod 'RealmSwift', '3.18.0'
    pod 'RxRealm', '0.7.6'
    pod 'Unbox', '3.0.0'
    pod 'Then', '2.2.1'
    pod 'Reachability', '3.2.0'
    pod 'RxRealmDataSources', '0.2.10'

  target 'Tweetie' do
    platform :ios, '12.0'
    pod 'RxDataSources', '3.1.0'
  end
  
  target 'MacTweetie' do
    platform :osx, '10.14'
  end
  
  target 'TweetieTests' do
    platform :ios, '12.0'
    pod 'RxTest', '4.4.1'
    pod 'RxBlocking', '4.4.1'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end

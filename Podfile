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

abstract_target 'BaseTarget' do
  platform :ios, '12.0'
  pod 'RxSwift', '6.2.0'
  pod 'RxCocoa', '6.2.0'
  
  target '00.Playgrounds-Support' do
    project 'Practices/00.playgrounds-support/00.Playgrounds-Support.xcodeproj'
  end

  target '01.Combinestagram-observables' do
    project 'Practices/01.observables-in-practice/01.Combinestagram-observables.xcodeproj'
  end

  target '02.Combinestagram-filtering' do
    project 'Practices/02.filtering-operators-in-practice/02.Combinestagram-filtering.xcodeproj'
  end

  target '03.GitFeed-transforming' do
    project 'Practices/03.transformng-operators-in-practice/03.GitFeed-transforming.xcodeproj'
    pod 'Kingfisher'
  end

  target '04.ourplanet-combining' do
    project 'Practices/04.combining-operators-in-practice/04.ourplanet-combining.xcodeproj'
  end

  target '05.Wundercast-beginning-rxcocoa' do
    project 'Practices/05.beginning-rxcocoa/05.Wundercast-beginning-rxcocoa.xcodeproj'
  end

  target '06.Wundercast-intermediate-rxcocoa' do
    project 'Practices/06.intermediate-rxcocoa/06.Wundercast-intermediate-rxcocoa.xcodeproj'
  end

  target '07.Wundercast-error-handling' do
    project 'Practices/07.error-handling-in-practice/07.Wundercast-error-handling.xcodeproj'
  end

#  target '08.Schedulers' do
#    platform :osx, '10.14'
#    project 'Practices/08.intro-to-schedulers/08.Schedulers.xcodeproj'
#  end
#
#  target '09.Testing' do
#    project 'Practices/09.testing-with-rxtest/09.Testing.xcodeproj'
#    pod 'Hue'
#
#    target 'TestingTests' do
#      pod 'RxTest', '6.2.0'
#      pod 'RxBlocking', '6.2.0'
#    end
#  end

#  target '10.iGif' do
#    project 'Practices/10.creating-custom-reactive-extension/10.iGif-extension.xcodeproj'
#    pod 'SwiftyJSON'
#    pod 'Gifu'
#
#    target 'iGifTests' do
#      pod 'Nimble'
#      pod 'RxNimble'
#      pod 'RxBlocking', '6.2.0'
#      pod 'OHHTTPStubs'
#      pod 'OHHTTPStubs/Swift'
#    end
#
#  end
#
#  target '12.QuickTodo-mvvm' do
#    project 'Practices/12.building-a-complete-rxswift-app/12.QuickTodo-mvvm.xcodeproj'
#    # core RxSwift
#    pod 'RxDataSources', '3.1.0'
#
#    # Community projects
#    pod 'Action', '~> 3.9'
#    pod 'NSObject+Rx', '~> 4.4'
#
#    # Realm database
#    pod 'RealmSwift', '3.18.0'
#    pod 'RxRealm', '0.7.6'
#  end

end

#abstract_target 'TweetieAbstract' do
#  project 'Practices/11.mvvm-with-rxswift/11.Tweetie-mvvm.xcodeproj'
#  pod 'Alamofire'
#  pod 'RxSwift', '6.2.0'
#  pod 'RxCocoa', '6.2.0'
#  pod 'RealmSwift', '3.18.0'
#  pod 'RxRealm', '0.7.6'
#  pod 'Unbox', '3.0.0'
#  pod 'Then', '2.2.1'
#  pod 'Reachability', '3.2.0'
#  pod 'RxRealmDataSources'
#
#  target '11.Tweetie' do
#    platform :ios, '12.0'
#    pod 'RxDataSources', '3.1.0'
#  end
#
#  target '11.MacTweetie' do
#    platform :osx, '10.14'
#  end
#
#  target 'TweetieTests' do
#    platform :ios, '12.0'
#    pod 'RxTest', '6.2.0'
#    pod 'RxBlocking', '6.2.0'
#  end
#end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end

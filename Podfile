# https://github.com/CocoaPods/CocoaPods/issues/9159#issuecomment-530374178
pre_install do |installer|
    original_sand = installer.sandbox
    def original_sand.project_path
        return @root + 'Rx.xcodeproj'
    end
    puts installer.sandbox.project_path
end

use_frameworks!
inhibit_all_warnings!
workspace 'RxSwift.xcworkspace'

abstract_target 'BaseTarget' do
  platform :ios, '12.0'
  pod 'RxSwift', '6.2.0'
  pod 'RxCocoa', '6.2.0'
  
  target '00_Playgrounds_Support' do
    project 'Practices/00.playgrounds-support/00_Playgrounds_Support.xcodeproj'
  end

  target '01_Combinestagram_observables' do
    project 'Practices/01.observables-in-practice/01_Combinestagram_observables.xcodeproj'
  end

  target '02_Combinestagram_filtering' do
    project 'Practices/02.filtering-operators-in-practice/02_Combinestagram_filtering.xcodeproj'
  end

  target '03_GitFeed_transforming' do
    project 'Practices/03.transformng-operators-in-practice/03_GitFeed_transforming.xcodeproj'
    pod 'Kingfisher'
  end

  target '04_ourplanet_combining' do
    project 'Practices/04.combining-operators-in-practice/04_ourplanet_combining.xcodeproj'
  end

  target '05_Wundercast_beginning_rxcocoa' do
    project 'Practices/05.beginning-rxcocoa/05_Wundercast_beginning_rxcocoa.xcodeproj'
  end

  target '06_Wundercast_intermediate_rxcocoa' do
    project 'Practices/06.intermediate-rxcocoa/06_Wundercast_intermediate_rxcocoa.xcodeproj'
  end

  target '07_Wundercast_error_handling' do
    project 'Practices/07.error-handling-in-practice/07_Wundercast_error_handling.xcodeproj'
  end

  
  target '08_Schedulers' do
    platform :osx, '10.14'
    project 'Practices/08.intro-to-schedulers/08_Schedulers.xcodeproj'
    pod 'RxSwift', '6.2.0'
    pod 'RxCocoa', '6.2.0'
  end
  
  target '09_Testing' do
    project 'Practices/09.testing-with-rxtest/09_Testing.xcodeproj'
    pod 'Hue'

    target 'TestingTests' do
      pod 'RxTest', '6.2.0'
      pod 'RxBlocking', '6.2.0'
    end
  end

  target '10_iGif_extension' do
    project 'Practices/10.creating-custom-reactive-extension/10_iGif_extension.xcodeproj'
    pod 'SwiftyJSON'
    pod 'Gifu'

    target 'iGifTests' do
      pod 'Nimble'
      pod 'RxNimble'
      pod 'RxBlocking', '6.2.0'
      pod 'OHHTTPStubs'
      pod 'OHHTTPStubs/Swift'
    end

  end

  target '12_QuickTodo_mvvm' do
    project 'Practices/12.building-a-complete-rxswift-app/12_QuickTodo_mvvm.xcodeproj'
    # core RxSwift
    pod 'RxDataSources'

    # Community projects
    pod 'Action'
    pod 'NSObject+Rx'

    # Realm database
    pod 'RealmSwift'
    pod 'RxRealm'
  end

end

#abstract_target 'TweetieAbstract' do
#  project 'Practices/11.mvvm-with-rxswift/11_Tweetie_mvvm.xcodeproj'
#  pod 'Alamofire', '4.9.1'
#
#  pod 'RxSwift', '5.1.1'
#  pod 'RxCocoa', '5.1.1'
#  pod 'RealmSwift', '5.1.0'
#  pod 'RxRealm', '3.0.0'
#  pod 'Unbox', '4.0.0'
#  pod 'Then', '2.7.0'
#  pod 'Reachability', '3.2.0'
#  pod 'RxRealmDataSources', '0.3.0'
#
#  target '11_Tweetie' do
#    platform :ios, '12.0'
#    pod 'RxDataSources', '4.0.1'
#  end
#
#  target '11_MacTweetie' do
#    platform :osx, '10.14'
#  end
#
#  target 'TweetieTests' do
#    platform :ios, '12.0'
#    pod 'RxTest', '5.1.1'
#    pod 'RxBlocking', '5.1.1'
#  end
#end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end

//
//  PHPhotoLibrary+Rx.swift
//  01.Combinestagram-observables
//
//  Created by ZJQ on 2020/6/2.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import Photos
import RxSwift

extension PHPhotoLibrary {
  static var authorized: Observable<Bool> {
    return Observable<Bool>.create { observer -> Disposable in
      DispatchQueue.main.async {
        if authorizationStatus() == .authorized {
          observer.onNext(true)
          observer.onCompleted()
        } else {
          observer.onNext(false)
          requestAuthorization { status in
            observer.onNext(status == .authorized)
            observer.onCompleted()
          }
        }
      }
      return Disposables.create()
    }
  }
}

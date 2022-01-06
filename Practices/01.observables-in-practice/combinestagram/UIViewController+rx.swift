//
//  UIViewController+rx.swift
//  Combinestagram
//
//  Created by ZJQ on 2021/12/28.
//  Copyright © 2021 Underplot ltd. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
  func alert(title: String?, message: String?) -> Completable {
    return Completable.create { [weak self] completable in
      let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
      vc.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        completable(.completed)
      }))
      self?.present(vc, animated: true)
      return Disposables.create {
        self?.dismiss(animated: true)
      }
    }
  }
}

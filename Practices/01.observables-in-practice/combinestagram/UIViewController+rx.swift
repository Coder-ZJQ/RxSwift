//
//  UIViewController+rx.swift
//  Combinestagram
//
//  Created by ZJQ on 2020/5/29.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
  func alert(title: String, text: String) -> Completable {
    return Completable.create { [weak self] complete -> Disposable in
      let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
        complete(.completed)
      }))
      self?.present(alert, animated: true, completion: nil)
      
      return Disposables.create {
        self?.dismiss(animated: true, completion: nil)
      }
    }
  }
}

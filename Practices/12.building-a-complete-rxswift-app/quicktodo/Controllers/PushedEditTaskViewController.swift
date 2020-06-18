//
//  PushedEditTaskViewController.swift
//  12.QuickTodo-mvvm
//
//  Created by ZJQ on 2020/6/18.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import UIKit

class PushedEditTaskViewController: UIViewController, BindableType {
  
  @IBOutlet var titleView: UITextView!
  
  var viewModel: PushedEditTaskViewModel!
  
  func bindViewModel() {
    titleView.text = viewModel.itemTitle
    
    titleView.rx.text.orEmpty
      .bind(to: viewModel.onUpdate.inputs.asObserver())
      .disposed(by: self.rx.disposeBag)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    titleView.becomeFirstResponder()
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

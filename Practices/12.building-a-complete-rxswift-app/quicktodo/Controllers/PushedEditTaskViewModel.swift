//
//  File.swift
//  12.QuickTodo-mvvm
//
//  Created by ZJQ on 2020/6/18.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation
import Action
import RxSwift

struct PushedEditTaskViewModel {
  
  let itemTitle: String
  let onUpdate: Action<String, Void>
  let disposeBag = DisposeBag()
  
  init(task: TaskItem, coordinator: SceneCoordinatorType, updateAction: Action<String, Void>) {
    itemTitle = task.title
    onUpdate = updateAction
  }
}

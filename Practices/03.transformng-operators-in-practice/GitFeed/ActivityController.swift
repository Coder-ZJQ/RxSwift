/*
 * Copyright (c) 2016-present Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

func cachedFileURL(_ fileName: String) -> URL {
  return FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first!.appendingPathComponent(fileName)
}

class ActivityController: UITableViewController {
  private let repo = "ReactiveX/RxSwift"

  private let events = BehaviorRelay<[Event]>(value: [])
  private let bag = DisposeBag()
  private let eventsFileURL = cachedFileURL("events.json")
  private let modifiedFileURL = cachedFileURL("modified.txt")
  private let lastModified = BehaviorRelay<String>(value: "")

  override func viewDidLoad() {
    super.viewDidLoad()
    title = repo

    self.refreshControl = UIRefreshControl()
    let refreshControl = self.refreshControl!

    refreshControl.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
    refreshControl.tintColor = UIColor.darkGray
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

    if let lastModifiedString = try? String(contentsOf: modifiedFileURL, encoding: .utf8) {
      lastModified.accept(lastModifiedString)
    }
    
    refresh()
  }

  @objc func refresh() {
    let decoder = JSONDecoder()
    if let data = try? Data(contentsOf: eventsFileURL), let persistedEvents = try? decoder.decode([Event].self, from: data) {
      events.accept(persistedEvents)
    }
    
    DispatchQueue.global(qos: .default).async { [weak self] in
      guard let self = self else { return }
      self.fetchEvents(repo: self.repo)
    }
  }

  
  func fetchEvents(repo: String) {
    /*
    let response = Observable.from([repo])
      .map { urlString -> URL in
        return URL(string: "https://api.github.com/repos/\(urlString)/events")!
      }
      .map { [weak self] url -> URLRequest in
        var request = URLRequest(url: url)
        if let modifiedHeader = self?.lastModified.value {
          request.addValue(modifiedHeader, forHTTPHeaderField: "Last-Modified")
        }
        return request
      }
      .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
        return URLSession.shared.rx.response(request: request)
      }
      .share(replay: 1)
    
    response
      .filter {
        // ~=: 判断范围操作符
        return 200..<300 ~= $0.response.statusCode
      }
      .map { couple -> [Event] in
        let decoder = JSONDecoder()
        let events = try? decoder.decode([Event].self, from: couple.data)
        return events ?? []
      }
      .filter { !$0.isEmpty }
      .subscribe(onNext: { [weak self] events in
        self?.processEvents(events)
      })
      .disposed(by: bag)
    
    response
      .filter { 200..<400 ~= $0.response.statusCode }
      .flatMap { couple -> Observable<String> in
        guard let value = couple.response.allHeaderFields["Last-Modified"] as? String else {
          return Observable.empty()
        }
        return Observable.just(value)
      }
      .subscribe(onNext: { [weak self] header in
        guard let self = self else { return }
        self.lastModified.accept(header)
        try?  header.write(to: self.modifiedFileURL, atomically: true, encoding: .utf8)
      })
      .disposed(by: bag)
    */
    
    let response =
    Observable
      .from(["https://api.github.com/search/repositories?q=language:swift&per_page=5"])
      .map { URL(string: $0)! }
      .flatMap { url -> Observable<Any> in
        return URLSession.shared.rx.json(request: URLRequest(url: url))
      }
      .flatMap { response -> Observable<String> in
        guard let response = response as? [String: Any],
          let items = response["items"] as? [[String: Any]] else {
          return Observable.empty()
        }
        return Observable.from(items.map { $0["full_name"] as! String })
      }
      .map { URL(string: "https://api.github.com/repos/\($0)/events?per_page=5")! }
      .map { [weak self] url -> URLRequest in
        var request = URLRequest(url: url)
        if let modifiedHeader = self?.lastModified.value {
          request.addValue(modifiedHeader, forHTTPHeaderField: "Last-Modified")
        }
        return request
      }
      .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
        return URLSession.shared.rx.response(request: request)
      }
      .share(replay: 1)
    
    
    response
      .filter {
        // ~=: 判断范围操作符
        return 200..<300 ~= $0.response.statusCode
      }
      .map { couple -> [Event] in
        let decoder = JSONDecoder()
        let events = try? decoder.decode([Event].self, from: couple.data)
        return events ?? []
      }
      .filter { !$0.isEmpty }
      .subscribe(onNext: { [weak self] events in
        self?.processEvents(events)
      })
      .disposed(by: bag)
    
    response
      .filter { 200..<400 ~= $0.response.statusCode }
      .flatMap { couple -> Observable<String> in
        guard let value = couple.response.allHeaderFields["Last-Modified"] as? String else {
          return Observable.empty()
        }
        return Observable.just(value)
      }
      .subscribe(onNext: { [weak self] header in
        guard let self = self else { return }
        self.lastModified.accept(header)
        try?  header.write(to: self.modifiedFileURL, atomically: true, encoding: .utf8)
      })
      .disposed(by: bag)
    
    
    
  }
  
  func processEvents(_ newEvents: [Event]) {
    var updatedEvents = newEvents + events.value
    if updatedEvents.count > 50 {
      updatedEvents = [Event](updatedEvents.prefix(upTo: 50))
    }
    events.accept(updatedEvents)
    DispatchQueue.main.async {
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
    
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(updatedEvents) {
      try? data.write(to: eventsFileURL, options: .atomicWrite)
    }
  }

  // MARK: - Table Data Source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.value.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let event = events.value[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
    cell.textLabel?.text = event.actor.name
    cell.detailTextLabel?.text = event.repo.name + ", " + event.action.replacingOccurrences(of: "Event", with: "").lowercased()
    cell.imageView?.kf.setImage(with: event.actor.avatar, placeholder: UIImage(named: "blank-avatar"))
    return cell
  }
}

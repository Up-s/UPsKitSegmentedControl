//
//  MainViewController.swift
//  UPsKitSegmentedControl
//
//  Created by Lee on 2020/12/12.
//

import UIKit

final class MainViewController: UIViewController {
  
  private let options: [UPsKitSegmentedModel] = [
    UPsKitSegmentedModel(title: "title0", content: "content content"),
    UPsKitSegmentedModel(title: "title1", content: "content content content content content content content content content content"),
    UPsKitSegmentedModel(title: "title2", content: "content content content content content content"),
    UPsKitSegmentedModel(title: "title3", content: "content contentcontent content content content content content content content content content content content content content content content"),
    UPsKitSegmentedModel(title: "title4", content: "content content content content"),
  ]
  
  private let upsKitSegmentedControl: UPsKitSegmentedControl = UPsKitSegmentedControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setAttribute()
    self.setConstraint()
  }
}



// MARK: - UPsSegmentedControlDataSource
extension MainViewController: UPsKitSegmentedControlDataSource {
  func numberOfItems(_ upsSegmentView: UPsKitSegmentedControl) -> Int {
    options.count
  }
  
  func upsSegmentView(_ upsSegmentView: UPsKitSegmentedControl, unitForItemAt row: Int) -> UPsKitSegmentedUnit {
    UPsKitSegmentedUnit(options[row])
  }
}



// MARK: - UPsSegmentedControlDelegate
extension MainViewController: UPsKitSegmentedControlDelegate {
  func inset(_ upsSegmentView: UPsKitSegmentedControl) -> UIEdgeInsets {
    UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
  }
  
  func cornerRadius(_ upsSegmentView: UPsKitSegmentedControl) -> CGFloat {
    4
  }
  
  func lineSpacing(_ upsSegmentView: UPsKitSegmentedControl) -> CGFloat {
    2
  }
  
  func upsSegmentView(_ upsSegmentView: UPsKitSegmentedControl, didTap row: Int) {
    print("\n---------------------- [ \(row) ] ----------------------")
  }
}



// MARK: - UI
extension MainViewController {
  private func setAttribute() {
    self.view.backgroundColor = UIColor.systemBackground
    
    self.upsKitSegmentedControl.backgroundColor = UIColor.systemGray5
    self.upsKitSegmentedControl.layer.cornerRadius = 4
    self.upsKitSegmentedControl.layer.masksToBounds = true
    self.upsKitSegmentedControl.dataSoucse = self
    self.upsKitSegmentedControl.delegate = self
  }
  
  private func setConstraint() {
    let guide = self.view.safeAreaLayoutGuide
    
    self.view.addSubview(self.upsKitSegmentedControl)
    self.upsKitSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.upsKitSegmentedControl.topAnchor.constraint(equalTo: guide.topAnchor, constant: 24),
      self.upsKitSegmentedControl.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 24),
      self.upsKitSegmentedControl.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -24)
    ])
  }
}

//
//  UPsKitSegmentedControl.swift
//  UPsKitSegmentedControl
//
//  Created by Lee on 2020/12/12.
//

import UIKit

protocol UPsKitSegmentedControlDataSource: class {
  func numberOfItems(_ upsSegmentView: UPsKitSegmentedControl) -> Int
  func upsSegmentView(_ upsSegmentView: UPsKitSegmentedControl, unitForItemAt row: Int) -> UPsKitSegmentedUnit
}

protocol UPsKitSegmentedControlDelegate: class {
  func cornerRadius(_ upsSegmentView: UPsKitSegmentedControl) -> CGFloat
  func inset(_ upsSegmentView: UPsKitSegmentedControl) -> UIEdgeInsets
  func lineSpacing(_ upsSegmentView: UPsKitSegmentedControl) -> CGFloat
  func upsSegmentView(_ upsSegmentView: UPsKitSegmentedControl, didTap row: Int)
}

final class UPsKitSegmentedControl: UIView {
  
  weak var dataSoucse: UPsKitSegmentedControlDataSource!
  weak var delegate: UPsKitSegmentedControlDelegate!
  
  private var isFirstTap: Bool = true
  
  private var units: [UPsKitSegmentedUnit] = [UPsKitSegmentedUnit]()
  private let backView: UIView = UIView()
  
  private var backTopConstraint: NSLayoutConstraint?
  private var backHeightConstraint: NSLayoutConstraint?
  
  init() {
    super.init(frame: CGRect.zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var isSet: Bool = true
  override func layoutSubviews() {
    super.layoutSubviews()
    
    guard self.isSet else { return }
    self.isSet = false
    self.setUnit()
  }
}



// MARK: - UPsSegmentUnitDelegate
extension UPsKitSegmentedControl: UPsKitSegmentedUnitDelegate {
  func didTap(_ upsSegmentUnit: UPsKitSegmentedUnit) {
    self.delegate.upsSegmentView(self, didTap: upsSegmentUnit.tag)
    
    switch self.isFirstTap {
    case true:
      self.isFirstTap = false
      self.setBackView(row: upsSegmentUnit.tag)
      
    case false:
      self.animateBackView(row: upsSegmentUnit.tag)
    }
    
    self.units.forEach {
      $0.isSelect = $0 == upsSegmentUnit
    }
  }
}



// MARK: - UI
extension UPsKitSegmentedControl {
  private func setUnit() {
    for row in 0..<self.dataSoucse.numberOfItems(self) {
      let tempUnit = self.dataSoucse.upsSegmentView(self, unitForItemAt: row)
      tempUnit.tag = row
      tempUnit.layer.cornerRadius = self.delegate.cornerRadius(self)
      tempUnit.layer.masksToBounds = true
      tempUnit.delegate = self
      self.units.append(tempUnit)
      self.addSubview(tempUnit)
      tempUnit.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let inset: UIEdgeInsets = self.delegate.inset(self)
    
    for (row, unit) in self.units.enumerated() {
      unit.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset.left).isActive = true
      unit.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset.right).isActive = true
      
      switch row {
      case 0:
        unit.topAnchor.constraint(equalTo: self.topAnchor, constant: inset.top).isActive = true
        
      case self.units.count - 1:
        unit.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset.bottom).isActive = true
        fallthrough
        
      default:
        let space: CGFloat = self.delegate.lineSpacing(self)
        unit.topAnchor.constraint(equalTo: self.units[row - 1].bottomAnchor, constant: space).isActive = true
      }
    }
  }
  
  private func setBackView(row: Int) {
    self.backView.backgroundColor = UIColor.systemBackground
    self.backView.layer.cornerRadius = self.delegate.cornerRadius(self)
    self.backView.layer.masksToBounds = true
    
    self.addSubview(self.backView)
    self.sendSubviewToBack(self.backView)
    self.backView.translatesAutoresizingMaskIntoConstraints = false
    let inset: UIEdgeInsets = self.delegate.inset(self)
    NSLayoutConstraint.activate([
      self.backView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset.left),
      self.backView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset.right)
    ])
    
    let position: CGFloat = units[row].frame.minY
    self.backTopConstraint = self.backView.topAnchor.constraint(equalTo: self.topAnchor, constant: position)
    self.backTopConstraint?.isActive = true
    
    let height: CGFloat = units[row].frame.height
    self.backHeightConstraint = self.backView.heightAnchor.constraint(equalToConstant: height)
    self.backHeightConstraint?.isActive = true
    
    self.layoutIfNeeded()
  }
  
  private func animateBackView(row: Int) {
    let position: CGFloat = units[row].frame.minY
    let height: CGFloat = units[row].frame.height
    
    UIView.animate(withDuration: 0.2) { [weak self] in
      guard let self = self else { return }
      self.backTopConstraint?.constant = position
      self.backHeightConstraint?.constant = height
      
      self.layoutIfNeeded()
    }
  }
}

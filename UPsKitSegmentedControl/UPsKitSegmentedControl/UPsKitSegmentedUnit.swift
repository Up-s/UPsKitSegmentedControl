//
//  UPsKitSegmentedUnit.swift
//  UPsKitSegmentedControl
//
//  Created by Lee on 2020/12/12.
//

import UIKit

protocol UPsKitSegmentedUnitDelegate: AnyObject {
  func didTap(_ upsSegmentUnit: UPsKitSegmentedUnit)
}

final class UPsKitSegmentedUnit: UIView {
  
  weak var delegate: UPsKitSegmentedUnitDelegate?
  
  var isSelect: Bool = false {
    didSet {
      let imageName: String = self.isSelect ? "smallcircle.fill.circle" : "circle"
      let tempImage = UIImage(systemName: imageName)?.withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
      self.selectImageView.image = tempImage
    }
  }
  
  private let selectImageView: UIImageView = UIImageView()
  private let titleLabel: UILabel = UILabel()
  private let contentLabel: UILabel = UILabel()
  private let button: UIButton = UIButton()
  
  let title: String
  let content: String
  
  init(title: String, content: String) {
    self.title = title
    self.content = content
    
    super.init(frame: CGRect.zero)
    
    self.setAttutibute()
    self.setConstraint()
  }
  
  init(_ model: UPsKitSegmentedModel) {
    self.title = model.title
    self.content = model.content
    
    super.init(frame: CGRect.zero)
    
    self.setAttutibute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}



// MARK: - Action
extension UPsKitSegmentedUnit {
  @objc private func didTap(_ sender: UIButton) {
    self.isSelect.toggle()
    self.delegate?.didTap(self)
  }
}



// MARK: - UI
extension UPsKitSegmentedUnit {
  private func setAttutibute() {
    self.selectImageView.image = UIImage(systemName: "circle")?.withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
    self.selectImageView.contentMode = UIView.ContentMode.scaleAspectFit
    
    self.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    self.titleLabel.text = title
    
    self.contentLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    self.contentLabel.text = content
    self.contentLabel.numberOfLines = 0
    
    self.button.addTarget(self, action: #selector(didTap(_:)), for: UIControl.Event.touchUpInside)
  }
  
  private func setConstraint() {
    [self.selectImageView, self.titleLabel, self.contentLabel, self.button].forEach {
      self.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let xInset: CGFloat = 8
    let yInset: CGFloat = 8
    let toPadding: CGFloat = 8
    
    NSLayoutConstraint.activate([
      self.selectImageView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
      self.selectImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xInset),
      self.selectImageView.widthAnchor.constraint(equalToConstant: 12),
      self.selectImageView.heightAnchor.constraint(equalToConstant: 12),
      
      self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: yInset),
      self.titleLabel.leadingAnchor.constraint(equalTo: self.selectImageView.trailingAnchor, constant: toPadding),
      self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -yInset),
      
      self.contentLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: toPadding),
      self.contentLabel.leadingAnchor.constraint(equalTo: self.selectImageView.trailingAnchor, constant: toPadding),
      self.contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -xInset),
      self.contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -yInset),
      
      self.button.topAnchor.constraint(equalTo: self.topAnchor),
      self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
}



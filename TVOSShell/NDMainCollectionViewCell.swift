//
//  NDMainCollectionViewCell.swift
//  TVOSShell
//
//  Created by Markim on 6/7/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit
import MarqueeLabel

class NDMainCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var titleLabel: MarqueeLabel!
  @IBOutlet weak var imageView: UIImageView!
  var newImageView: UIImageView!
  @IBOutlet weak var duration: UILabel!
  @IBOutlet weak var durationView: UIView!
  @IBOutlet weak var descriptionView: UIView!
  @IBOutlet weak var descriptionLabel: UITextView!
  
  //Unfocused constraints
  @IBOutlet weak var titleLabelBottomAnchorConstraint: NSLayoutConstraint!
  @IBOutlet weak var titleLabelLeftAnchorConstraint: NSLayoutConstraint!
  @IBOutlet weak var titleLabelTopAnchorConstraint: NSLayoutConstraint!
  
  //focused constraints
  var titleLabelCenterXAnchorFocusedConstraint: NSLayoutConstraint!
  
  //var descriptionLabel:UITextView!
  
  private var animationDuration:TimeInterval = 0.4
  
  weak var delegate: NDMainViewController?
  
  var currentRow: Int!
  
  
  override var canBecomeFocused: Bool {
    return true
  }
  
  private var focusedHeight: CGFloat = 554.0
  private var unfocusedHeight: CGFloat = 364.0
  
  private var unfocusedFrame:CGRect = CGRect(x: 0.0, y: 0.0, width: 567.0, height: 364.0)
  private var focusedFrame:CGRect = CGRect(x: 0.0, y: 0.0, width: 624.0, height: 570.0)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.titleLabel.holdScrolling = true

    
    
    
    titleLabelCenterXAnchorFocusedConstraint = titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0)
    titleLabelCenterXAnchorFocusedConstraint.isActive = false
    
    durationView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    descriptionLabel.textContainer.maximumNumberOfLines = 4
    
    //setDurationView()
  }
  
  func setDurationView() {
    let image = UIImage(view: durationView)
    newImageView = UIImageView(image: image)
    newImageView.frame = CGRect(x: durationView.frame.minX + durationView.frame.width / 2.5, y: durationView.frame.height / 4, width: durationView.frame.width / 2, height: durationView.frame.height / 2)
    newImageView.adjustsImageWhenAncestorFocused = true
    durationView.alpha = 0.0
    self.addSubview(newImageView)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    imageView.image = nil
    if newImageView != nil {
      newImageView.image = nil
    }
    durationView.alpha = 1.0
    //setDurationView()
  }
  
  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    createConstraints()
    
    
    //Adjust the height of the cell whenever it is focused/unfocused
    if self == context.nextFocusedView {
      
      self.titleLabel.alpha = 0.0
      self.titleLabel.holdScrolling = false
      self.titleLabel.type = .leftRight

      
      UIView.animate(withDuration: animationDuration, animations: {
        self.titleLabel.alpha = 1.0

        self.descriptionView.alpha = 1.0
      })
      self.setFocusedState()
      
    } else if self == context.previouslyFocusedView {
      
      self.titleLabel.alpha = 0.0
      self.titleLabel.shutdownLabel()
      self.titleLabel.holdScrolling = true
      
      UIView.animate(withDuration: animationDuration, animations: {
        self.titleLabel.alpha = 1.0
        self.descriptionView.alpha = 0.0
      })
      self.setUnFocusedState()
      titleLabel.motionEffects = []

      //remove the description view
      coordinator.addCoordinatedAnimations({
        self.descriptionView.alpha = 0.0
      }, completion: nil)
    }
    
  }
  
  private func createConstraints(){
    
    if titleLabelLeftAnchorConstraint == nil{
      
      titleLabelLeftAnchorConstraint = titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0)
      
      titleLabelBottomAnchorConstraint = titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -17.0)
    }
  }
  
  private func setFocusedState(){
    
  }
  
  private func setUnFocusedState(){
  }
  
}

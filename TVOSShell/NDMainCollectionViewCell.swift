//
//  NDMainCollectionViewCell.swift
//  TVOSShell
//
//  Created by Markim on 6/7/17.
//  Copyright © 2017 Markim. All rights reserved.
//

import UIKit

class NDMainCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
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
    
    
    titleLabelCenterXAnchorFocusedConstraint = titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0)
    titleLabelCenterXAnchorFocusedConstraint.isActive = false
    
    durationView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    descriptionLabel.textContainer.maximumNumberOfLines = 4
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    imageView.image = nil
  }
  
  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    createConstraints()
    
    //Adjust the height of the cell whenever it is focused/unfocused
    if self == context.nextFocusedView {
      
      self.titleLabel.alpha = 0.0
      
      
      //self.frame = CGRect(x: self.frame.origin.x - self.focusedFrame.width / 2, y: self.frame.origin.y, width: self.focusedFrame.width, height: self.focusedFrame.height)
      UIView.animate(withDuration: animationDuration, animations: {
        self.titleLabel.alpha = 1.0
        self.descriptionView.alpha = 1.0
      })
      self.setFocusedState()

      //Add the description view to this collection view cell
      /*if descriptionLabel != nil {
        createDescriptionLabel()
        coordinator.addCoordinatedAnimations({
          self.descriptionView.alpha = 1.0
        }, completion: nil)
        UIView.animate(withDuration: animationDuration, animations: {
        })
      } else {
       
        createDescriptionLabel()
        
        UIView.animate(withDuration: animationDuration, animations: {
          self.descriptionView.alpha = 1.0
        })
      }*/
      
    } else if self == context.previouslyFocusedView {
      //descriptionLabel.alpha = 0.0
      //self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.unfocusedFrame.width, height: self.unfocusedFrame.height
      self.titleLabel.alpha = 0.0
      
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
  
  /*private func createDescriptionLabel() {
    //Reveal the caption UILabel
    descriptionLabel = UITextView()
    descriptionView.alpha = 0.0
    descriptionLabel.text = "wgoiangwgioanwoginawohinwaolkfkufkufkycjlycyjyuldluuouldludludtlukxtxtxtl;ud7d;86d7;d6d;6hinawoihnoawnhaowh"
    descriptionView.addSubview(descriptionLabel)
    //self.addSubview(descriptionLabel)
    
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0).isActive = true
    descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0).isActive = true
    descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0).isActive = true
    descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
    descriptionLabel.textContainer.maximumNumberOfLines = 3
    descriptionLabel.textContainer.lineBreakMode = .byTruncatingTail
    descriptionLabel.addParallaxMotionEffects(tiltValue: 0.0, panValue: 5.0)
  }*/
  
  private func createConstraints(){
    
    if titleLabelLeftAnchorConstraint == nil{
      
      titleLabelLeftAnchorConstraint = titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0)
      
      titleLabelBottomAnchorConstraint = titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -17.0)
    }
  }
  
  private func setFocusedState(){
    //For the title label activate the titleLabelTopAnchorFocusedConstraint
    //                    activate the titleLabelCenterXAnchorFocusedConstraint
    //                    deactive the titleLabelLeftAnchorUnfocusedConstraint
    //                                 titleLabelRightAnchorUnfocusedConstraint
    //                                 titleLabelBottomAnchorUnfocusedConstraint
    //                                 titleLabelTopAnchorUnfocusedConstraint
    //titleLabelTopAnchorConstraint.isActive = true
   // titleLabelBottomAnchorConstraint.isActive = false
    //titleLabelCenterXAnchorFocusedConstraint.isActive = true
    //titleLabelLeftAnchorConstraint.isActive = false
    
  }
  
  private func setUnFocusedState(){
   // titleLabelCenterXAnchorFocusedConstraint.isActive = false
    //titleLabelLeftAnchorConstraint.isActive = true
    //titleLabelBottomAnchorConstraint.isActive = true
    //titleLabelLeftAnchorConstraint.isActive = true
    //self.layoutIfNeeded()
    //self.layoutSubviews()
  }
  
}

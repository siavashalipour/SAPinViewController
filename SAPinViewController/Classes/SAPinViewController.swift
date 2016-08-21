//
//  SAPinViewController.swift
//  PINManagement
//
//  Created by Siavash Abbasalipour on 19/08/2016.
//  Copyright © 2016 Siavash Abbasalipour. All rights reserved.
//

import UIKit
import SnapKit

public protocol SAPinViewControllerDelegate {
    func pinEntryWasCancelled()
    func pinEntryWasSuccessful()
    func pinWasIncorrect()
    func isPinValid(pin: String) -> Bool
}

public class SAPinViewController: UIViewController {
    
    public var circleBorderColor: UIColor! {
        didSet {
            if circleViews.count > 0 {
                for i in 0...3 {
                    circleViews[i].circleBorderColor = circleBorderColor
                }
            }
        }
    }
    
    public var font: UIFont! {
        didSet {
            if buttons.count > 0 {
                for i in 0...9 {
                    buttons[i].font = font
                }
            }
        }
    }
    
    public var showAlphabet: Bool! {
        didSet {
            if buttons.count > 0 {
                for i in 0...9 {
                    buttons[i].showAlphabet = showAlphabet
                }
            }
        }
    }
    
    public var buttonBorderColor: UIColor! {
        didSet {
            if buttons.count > 0 {
                for i in 0...9 {
                    buttons[i].buttonBorderColor = buttonBorderColor
                }
            }
        }
    }
    
    public var numberColor: UIColor! {
        didSet {
            if buttons.count > 0 {
                for i in 0...9 {
                    buttons[i].numberColor = numberColor
                }
            }
        }
    }
    
    public var alphabetColor: UIColor! {
        didSet {
            if buttons.count > 0 {
                for i in 0...9 {
                    buttons[i].alphabetColor = alphabetColor
                }
            }
        }
    }
    
    public var subtitleText: String! {
        didSet {
            if subtitleLabel != nil {
                subtitleLabel.text = subtitleText
                updateSubtitle()
                
            }
        }
    }
    
    public var titleText: String! {
        didSet {
            if titleLabel != nil {
                titleLabel.text = titleText
                updateTitle()
            }
        }
    }
    
    public var subtitleTextColor: UIColor! {
        didSet {
            if subtitleLabel != nil {
                subtitleLabel.textColor = subtitleTextColor
            }
        }
    }
    
    public var titleTextColor: UIColor! {
        didSet {
            if titleLabel != nil {
                titleLabel.textColor = titleTextColor
            }
        }
    }
    
    public var cancelButtonColor: UIColor! {
        didSet {
            if cancelButton != nil {
                let font = UIFont(name: SAPinConstant.DefaultFontName, size: 17)
                setAttributedTitleForButtonWithTitle(SAPinConstant.CancelString, font: font!, color: cancelButtonColor)
            }
        }
    }
    
    public var cancelButtonFont: UIFont! {
        didSet {
            if cancelButton != nil {
                let font = cancelButtonFont.fontWithSize(17)
                setAttributedTitleForButtonWithTitle(SAPinConstant.CancelString, font: font, color: cancelButtonColor ?? UIColor.whiteColor())
            }
        }
    }
    private var blurView: UIVisualEffectView!
    private var numPadView: UIView!
    private var buttons: [SAButtonView]! = []
    private var circleViews: [SACircleView]! = []
    private var dotContainerView: UIView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var cancelButton: UIButton!
    private var dotContainerWidth: CGFloat = 0
    private var tappedButtons: [Int] = []
    private var delegate: SAPinViewControllerDelegate?
    private var backgroundImage: UIImage!
    
    public init(withDelegate: SAPinViewControllerDelegate, backgroundImage: UIImage? = nil, backgroundColor: UIColor? = nil) {
        super.init(nibName: nil, bundle: nil)
        delegate = withDelegate
        if let safeImage = backgroundImage {
            self.backgroundImage = safeImage
        }
        if let safeBGColor = backgroundColor {
            self.view.backgroundColor = safeBGColor
        }
        self.setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public func setupUI() {
        dotContainerWidth = 3 * SAPinConstant.ButtonWidth + 2 * SAPinConstant.ButtonPadding
        
        numPadView = UIView()
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        if backgroundImage != nil {
            let imageView = UIImageView(image: backgroundImage)
            imageView.contentMode = .ScaleAspectFit
            view.addSubview(imageView)
            imageView.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(view)
            })
        }
        view.addSubview(blurView)
        view.bringSubviewToFront(blurView)
        blurView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        blurView.contentView.addSubview(numPadView)
        
        numPadView.snp_makeConstraints { (make) in
            make.width.equalTo(dotContainerWidth)
            make.height.equalTo(4 * SAPinConstant.ButtonWidth + 3 * SAPinConstant.ButtonPadding)
            make.centerX.equalTo(blurView.snp_centerX)
            make.centerY.equalTo(blurView.snp_centerY).offset(2*SAPinConstant.ButtonPadding)
        }
        // Add buttons
        addButtons()
        layoutButtons()
        
        // Add dots
        addCircles()
        layoutCircles()
        
        // Add subtitle
        addSubtitle()
        
        // Add title label
        addTitle()
        
        // Add Cancel Button
        addCancelButton()
    }
    
    private func addButtons() {
        for i in 0...9 {
            let btnView = SAButtonView(frame: CGRect(x: 0, y: 0, width: SAPinConstant.ButtonWidth, height: SAPinConstant.ButtonWidth))
            btnView.numberTag = i
            btnView.delegate = self
            buttons.append(btnView)
            numPadView.addSubview(btnView)
        }
    }
    private func layoutButtons() {
        for i in 0...9 {
            buttons[i].snp_makeConstraints(closure: { (make) in
                make.width.equalTo(SAPinConstant.ButtonWidth)
                make.height.equalTo(SAPinConstant.ButtonWidth)
            })
        }
        buttons[2].snp_makeConstraints { (make) in
            make.top.equalTo(numPadView.snp_top)
            make.centerX.equalTo(numPadView.snp_centerX)
        }
        buttons[5].snp_makeConstraints { (make) in
            make.top.equalTo(numPadView.snp_top).offset(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding)
            make.centerX.equalTo(numPadView.snp_centerX)
        }
        buttons[8].snp_makeConstraints { (make) in
            make.top.equalTo(numPadView.snp_top).offset(2*(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding))
            make.centerX.equalTo(numPadView.snp_centerX)
        }
        buttons[0].snp_makeConstraints { (make) in
            make.top.equalTo(numPadView.snp_top).offset(3*(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding))
            make.centerX.equalTo(numPadView.snp_centerX)
        }
        buttons[1].snp_makeConstraints { (make) in
            make.top.equalTo(numPadView.snp_top)
            make.left.equalTo(numPadView)
        }
        buttons[3].snp_makeConstraints { (make) in
            make.top.equalTo(numPadView.snp_top)
            make.right.equalTo(numPadView)
        }
        buttons[4].snp_makeConstraints { (make) in
            make.top.equalTo(numPadView.snp_top).offset(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding)
            make.left.equalTo(numPadView)
        }
        buttons[6].snp_makeConstraints { (make) in
            make.top.equalTo(numPadView.snp_top).offset(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding)
            make.right.equalTo(numPadView)
        }
        buttons[7].snp_makeConstraints { (make) in
            make.top.equalTo(numPadView.snp_top).offset(2*(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding))
            make.left.equalTo(numPadView)
        }
        buttons[9].snp_makeConstraints { (make) in
            make.top.equalTo(numPadView.snp_top).offset(2*(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding))
            make.right.equalTo(numPadView)
        }
    }
    private func addCircles() {
        dotContainerView = UIView()
        blurView.contentView.addSubview(dotContainerView)
        dotContainerView.snp_makeConstraints { (make) in
            make.top.equalTo(numPadView.snp_top).offset(-2*SAPinConstant.ButtonPadding)
            make.height.equalTo(20)
            make.width.equalTo(3*SAPinConstant.ButtonWidth + 2*SAPinConstant.ButtonPadding)
            make.centerX.equalTo(numPadView.snp_centerX)
        }
        
        for _ in 0...3 {
            let aBall = SACircleView(frame: CGRect(x: 0, y: 0, width: SAPinConstant.CircleWidth, height: SAPinConstant.CircleWidth))
            
            dotContainerView.addSubview(aBall)
            circleViews.append(aBall)
        }
    }
    private func layoutCircles() {
        for i in 0...3 {
            circleViews[i].snp_makeConstraints(closure: { (make) in
                make.width.equalTo(SAPinConstant.CircleWidth)
                make.height.equalTo(SAPinConstant.CircleWidth)
            })
        }
        let dotLeading = (dotContainerWidth - 3*SAPinConstant.ButtonPadding - 4*SAPinConstant.CircleWidth)/2.0
        circleViews[0].snp_makeConstraints { (make) in
            make.leading.equalTo(dotContainerView).offset(dotLeading)
            make.top.equalTo(dotContainerView)
        }
        circleViews[3].snp_makeConstraints { (make) in
            make.trailing.equalTo(dotContainerView).offset(-dotLeading)
            make.top.equalTo(dotContainerView)
        }
        circleViews[2].snp_makeConstraints { (make) in
            make.trailing.equalTo(circleViews[3]).offset(-1.45*SAPinConstant.ButtonPadding)
            make.top.equalTo(dotContainerView)
        }
        circleViews[1].snp_makeConstraints { (make) in
            make.leading.equalTo(circleViews[0]).offset(1.45*SAPinConstant.ButtonPadding)
            make.top.equalTo(dotContainerView)
        }
    }
    private func addSubtitle() {
        subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont(name: SAPinConstant.DefaultFontName, size: 13.0)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.textColor = UIColor.whiteColor()
        blurView.addSubview(subtitleLabel)
        updateSubtitle()
    }
    private func updateSubtitle() {
        subtitleLabel.text = subtitleText
        subtitleLabel.snp_remakeConstraints { (make) in
            make.width.equalTo(dotContainerWidth)
            make.bottom.equalTo(dotContainerView.snp_top).offset(-5)
            make.centerX.equalTo(blurView.snp_centerX)
        }
    }
    private func addTitle() {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont(name: SAPinConstant.DefaultFontName, size: 17.0)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        blurView.addSubview(titleLabel)
        updateTitle()
    }
    private func updateTitle() {
        titleLabel.text = titleText ?? "Enter Passcode"
        titleLabel.snp_remakeConstraints { (make) in
            make.width.equalTo(dotContainerWidth)
            if subtitleLabel.text == "" {
                make.bottom.equalTo(dotContainerView.snp_top).offset(-17)
            } else {
                make.bottom.equalTo(subtitleLabel.snp_top).offset(-5)
            }
            make.centerX.equalTo(blurView.snp_centerX)
        }
    }
    private func addCancelButton() {
        cancelButton = UIButton(type: .Custom)
        cancelButtonColor = titleLabel.textColor
        cancelButtonFont = titleLabel.font
        setAttributedTitleForButtonWithTitle(SAPinConstant.CancelString, font: cancelButtonFont, color: cancelButtonColor)
        cancelButton.addTarget(self, action: #selector(self.cancelDeleteTap), forControlEvents: .TouchUpInside)
        blurView.addSubview(cancelButton)
        cancelButton.snp_makeConstraints { (make) in
            make.trailing.equalTo(numPadView.snp_trailing)
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                // 3.5" special case 
                if UIScreen.mainScreen().bounds.height == 480 {
                    make.bottom.equalTo(numPadView)
                } else {
                    make.bottom.equalTo(numPadView).offset(SAPinConstant.ButtonWidth)
                }
            } else {
                make.bottom.equalTo(numPadView)
            }
            make.height.equalTo(44)
        }
    }
    func cancelDeleteTap() {
        if cancelButton.titleLabel?.text == SAPinConstant.DeleteString {
            if tappedButtons.count > 0 {
                circleViews[tappedButtons.count-1].animateTapEmpty()
                let _ = tappedButtons.removeLast()
            }
            if tappedButtons.count == 0 {
                setAttributedTitleForButtonWithTitle(SAPinConstant.CancelString, font: cancelButtonFont, color: cancelButtonColor)
            }
        } else {
            delegate?.pinEntryWasCancelled()
        }
    }
    private func setAttributedTitleForButtonWithTitle(title: String, font: UIFont, color: UIColor) {
        cancelButton.setAttributedTitle(NSAttributedString(string: title, attributes: [NSFontAttributeName:font,NSForegroundColorAttributeName:color]), forState: .Normal)
    }
    private func pinErrorAnimate() {
        for item in circleViews {
            UIView.animateWithDuration(0.1, animations: {
                item.backgroundColor = item.circleBorderColor.colorWithAlphaComponent(0.7)
                
                }, completion: { finished in
                    UIView.animateWithDuration(0.5, animations: {
                        item.backgroundColor = UIColor.clearColor()
                    })
            })
        }
        animateView()
    }
    func animateView() {
        setOptions()
        animate()
    }
    
    func setOptions() {
        for item in circleViews {
            item.force = 2.2
            item.duration = 1
            item.delay = 0
            item.damping = 0.7
            item.velocity = 0.7
            item.animation = "spring"
        }
    }
    
    func animate() {
        for item in circleViews {
            item.animateFrom = true
            item.animatePreset()
            item.setView{}
        }
    }
    
}

extension SAPinViewController: SAButtonViewDelegate {
    func buttonTappedWithTag(tag: Int) {
        if tappedButtons.count < 4 {
            circleViews[tappedButtons.count].animateTapFull()
            tappedButtons.append(tag)
            setAttributedTitleForButtonWithTitle(SAPinConstant.DeleteString, font: cancelButtonFont, color: cancelButtonColor)
            if tappedButtons.count == 4 {
                if delegate!.isPinValid("\(tappedButtons[0])\(tappedButtons[1])\(tappedButtons[2])\(tappedButtons[3])") {
                    delegate?.pinEntryWasSuccessful()
                } else {
                    delegate?.pinWasIncorrect()
                    pinErrorAnimate()
                    tappedButtons = []
                    setAttributedTitleForButtonWithTitle(SAPinConstant.CancelString, font: cancelButtonFont, color: cancelButtonColor)
                }
                
            }
        }
    }
}

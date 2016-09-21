//
//  SAPinViewController.swift
//  PINManagement
//
//  Created by Siavash Abbasalipour on 19/08/2016.
//  Copyright © 2016 Siavash Abbasalipour. All rights reserved.
//

import UIKit
import SnapKit

/// SAPinViewControllerDelegate
/// Any ViewController that would like to present `SAPinViewController` should implement
/// all these protocol methods
public protocol SAPinViewControllerDelegate {
    
    /// Gets called upon tapping on `Cancel` button 
    /// required and must be implemented
    func pinEntryWasCancelled()
    
    /// Gets called if the enterd PIN returned `true` passing it to `isPinValid(pin: String) -> Bool`
    /// required and must be implemented
    func pinEntryWasSuccessful()
    
    /// Gets called if the enterd PIN returned `false` passing it to `isPinValid(pin: String) -> Bool`
    /// required and must be implemented
    func pinWasIncorrect()
    
    /// Ask the implementer to see whether the PIN is valid or not
    /// required and must be implemented
    func isPinValid(_ pin: String) -> Bool
}

/// SAPinViewController
/// Use this class to instantiate a PIN screen
/// Set each one of its property for customisation
/// N.B: UNLY use the Designate initialaiser
open class SAPinViewController: UIViewController {
    
    ///  Set this to customise the border colour around the dots
    /// This will set the dots fill colour as well
    /// Default is white colour
    open var circleBorderColor: UIColor! {
        didSet {
            if circleViews.count > 0 {
                for i in 0...3 {
                    circleViews[i].circleBorderColor = circleBorderColor
                }
            }
        }
    }
    
    /// Set this to change the font of PIN numbers and alphabet
    /// Note that the maximum font size for numbers are 30.0 and for alphabets are 10.0
    open var font: UIFont! {
        didSet {
            if buttons.count > 0 {
                for i in 0...9 {
                    buttons[i].font = font
                }
            }
        }
    }
    
    /// Set this if you want to hide the alphabets - default is to show alphabet
    open var showAlphabet: Bool! {
        didSet {
            if buttons.count > 0 {
                for i in 0...9 {
                    buttons[i].showAlphabet = showAlphabet
                }
            }
        }
    }
    
    /// Set this to customise the border colour around the PIN numbers
    /// Default is white
    open var buttonBorderColor: UIColor! {
        didSet {
            if buttons.count > 0 {
                for i in 0...9 {
                    buttons[i].buttonBorderColor = buttonBorderColor
                }
            }
        }
    }
    
    /// Set this to customise the PIN numbers colour
    /// Default is white
    open var numberColor: UIColor! {
        didSet {
            if buttons.count > 0 {
                for i in 0...9 {
                    buttons[i].numberColor = numberColor
                }
            }
        }
    }
    
    /// Set this to customise the alphabet colour
    /// Default is white
    open var alphabetColor: UIColor! {
        didSet {
            if buttons.count > 0 {
                for i in 0...9 {
                    buttons[i].alphabetColor = alphabetColor
                }
            }
        }
    }
    
    /// Set this to add subtitle text for the `SAPinViewController`
    /// Default is empty String
    open var subtitleText: String! {
        didSet {
            if subtitleLabel != nil {
                subtitleLabel.text = subtitleText
                updateSubtitle()
                
            }
        }
    }
    
    /// Set this to add title text for the `SAPinViewController`
    /// Default is "Enter Passcode"
    open var titleText: String! {
        didSet {
            if titleLabel != nil {
                titleLabel.text = titleText
                updateTitle()
            }
        }
    }
    
    /// Set this to customise subtitle text colour for the `SAPinViewController`
    /// Default is white
    open var subtitleTextColor: UIColor! {
        didSet {
            if subtitleLabel != nil {
                subtitleLabel.textColor = subtitleTextColor
            }
        }
    }
    
    /// Set this to customise title text colour for the `SAPinViewController`
    /// Default is white
    open var titleTextColor: UIColor! {
        didSet {
            if titleLabel != nil {
                titleLabel.textColor = titleTextColor
            }
        }
    }
    
    /// Set this to customise `Cancel` button text colour
    /// Default is white
    open var cancelButtonColor: UIColor! {
        didSet {
            if cancelButton != nil {
                let font = UIFont(name: SAPinConstant.DefaultFontName, size: 17)
                setAttributedTitleForButtonWithTitle(SAPinConstant.CancelString, font: font!, color: cancelButtonColor)
            }
        }
    }
    
    /// Set this to customise `Cancel` button text font
    /// Maximum font size is 17.0
    open var cancelButtonFont: UIFont! {
        didSet {
            if cancelButton != nil {
                let font = cancelButtonFont.withSize(17)
                setAttributedTitleForButtonWithTitle(SAPinConstant.CancelString, font: font, color: cancelButtonColor ?? UIColor.white)
            }
        }
    }
    
    /// Set this to `true` to get rounded rect boarder style
    open var isRoundedRect: Bool! {
        didSet {
            if let safeIsRoundedRect = isRoundedRect {
                if buttons.count > 0 {
                    for i in 0...9 {
                        buttons[i].isRoundedRect = safeIsRoundedRect
                    }
                }
                if circleViews.count > 0  {
                    for i in 0...3 {
                        circleViews[i].isRoundedRect = safeIsRoundedRect
                    }
                }
            }
        }
    }
    
    fileprivate var blurView: UIVisualEffectView!
    fileprivate var numPadView: UIView!
    fileprivate var buttons: [SAButtonView]! = []
    fileprivate var circleViews: [SACircleView]! = []
    fileprivate var dotContainerView: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var subtitleLabel: UILabel!
    fileprivate var cancelButton: UIButton!
    fileprivate var dotContainerWidth: CGFloat = 0
    fileprivate var tappedButtons: [Int] = []
    fileprivate var delegate: SAPinViewControllerDelegate?
    fileprivate var backgroundImage: UIImage!
    fileprivate var logoImage: UIImage!
    
    /// Designate initialaiser
    ///
    /// - parameter withDelegate:          user should pass itself as `SAPinViewControllerDelegate`
    /// - parameter backgroundImage:       optional Image, by passing one, you will get a nice blur effect above that
    /// - parameter backgroundColor:       optional Color, by passing one, you will get a solid backgournd color and the blur effect would be ignored
    /// - parameter logoImage:             optional Image, by passing one, you will get a circled logo on top, please pass a square size image. not available for 3.5inch screen
    public init(withDelegate: SAPinViewControllerDelegate, backgroundImage: UIImage? = nil, backgroundColor: UIColor? = nil, logoImage: UIImage? = nil) {
        
        super.init(nibName: nil, bundle: nil)
        delegate = withDelegate
        if let safeImage = backgroundImage {
            if let safeBGColor = backgroundColor {
                self.view.backgroundColor = safeBGColor
            } else {
                self.backgroundImage = safeImage
            }
        }
        if let safeBGColor = backgroundColor {
            self.view.backgroundColor = safeBGColor
        }
        if let safeLogoImage = logoImage {
            if !self.isSmallScreen() {
                self.logoImage = safeLogoImage
            }
        }
        self.setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Initial UI setup
    func setupUI() {
        dotContainerWidth = 3 * SAPinConstant.ButtonWidth + 2 * SAPinConstant.ButtonPadding
        
        numPadView = UIView()
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        if backgroundImage != nil {
            let imageView = UIImageView(image: backgroundImage)
            imageView.contentMode = .scaleAspectFit
            view.addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
                make.edges.equalTo(view)
            })
        }
        view.addSubview(blurView)
        view.bringSubview(toFront: blurView)
        blurView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        blurView.contentView.addSubview(numPadView)
        
        numPadView.snp.makeConstraints { (make) in
            make.width.equalTo(dotContainerWidth)
            make.height.equalTo(4 * SAPinConstant.ButtonWidth + 3 * SAPinConstant.ButtonPadding)
            make.centerX.equalTo(blurView.snp.centerX)
            if logoImage != nil {
                make.centerY.equalTo(blurView.snp.centerY).offset(2*SAPinConstant.ButtonPadding + SAPinConstant.LogoImageWidth)
            } else {
                make.centerY.equalTo(blurView.snp.centerY).offset(2*SAPinConstant.ButtonPadding)
            }
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
        
        // Add logo
        if logoImage != nil {
            addLogo()
        }
        // Add Cancel Button
        addCancelButton()
    }
    // MARK: Private methods
    fileprivate func addButtons() {
        for i in 0...9 {
            let btnView = SAButtonView(frame: CGRect(x: 0, y: 0, width: SAPinConstant.ButtonWidth, height: SAPinConstant.ButtonWidth))
            btnView.numberTag = i
            btnView.delegate = self
            buttons.append(btnView)
            numPadView.addSubview(btnView)
        }
    }
    
    fileprivate func layoutButtons() {
        for i in 0...9 {
            buttons[i].snp.makeConstraints({ (make) in
                make.width.equalTo(SAPinConstant.ButtonWidth)
                make.height.equalTo(SAPinConstant.ButtonWidth)
            })
        }
        buttons[2].snp.makeConstraints { (make) in
            make.top.equalTo(numPadView.snp.top)
            make.centerX.equalTo(numPadView.snp.centerX)
        }
        buttons[5].snp.makeConstraints { (make) in
            make.top.equalTo(numPadView.snp.top).offset(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding)
            make.centerX.equalTo(numPadView.snp.centerX)
        }
        buttons[8].snp.makeConstraints { (make) in
            make.top.equalTo(numPadView.snp.top).offset(2*(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding))
            make.centerX.equalTo(numPadView.snp.centerX)
        }
        buttons[0].snp.makeConstraints { (make) in
            make.top.equalTo(numPadView.snp.top).offset(3*(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding))
            make.centerX.equalTo(numPadView.snp.centerX)
        }
        buttons[1].snp.makeConstraints { (make) in
            make.top.equalTo(numPadView.snp.top)
            make.left.equalTo(numPadView)
        }
        buttons[3].snp.makeConstraints { (make) in
            make.top.equalTo(numPadView.snp.top)
            make.right.equalTo(numPadView)
        }
        buttons[4].snp.makeConstraints { (make) in
            make.top.equalTo(numPadView.snp.top).offset(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding)
            make.left.equalTo(numPadView)
        }
        buttons[6].snp.makeConstraints { (make) in
            make.top.equalTo(numPadView.snp.top).offset(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding)
            make.right.equalTo(numPadView)
        }
        buttons[7].snp.makeConstraints { (make) in
            make.top.equalTo(numPadView.snp.top).offset(2*(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding))
            make.left.equalTo(numPadView)
        }
        buttons[9].snp.makeConstraints { (make) in
            make.top.equalTo(numPadView.snp.top).offset(2*(SAPinConstant.ButtonWidth + SAPinConstant.ButtonPadding))
            make.right.equalTo(numPadView)
        }
    }
    fileprivate func addCircles() {
        dotContainerView = UIView()
        blurView.contentView.addSubview(dotContainerView)
        dotContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(numPadView.snp.top).offset(-2*SAPinConstant.ButtonPadding)
            make.height.equalTo(20)
            make.width.equalTo(3*SAPinConstant.ButtonWidth + 2*SAPinConstant.ButtonPadding)
            make.centerX.equalTo(numPadView.snp.centerX)
        }
        
        for _ in 0...3 {
            let aBall = SACircleView(frame: CGRect(x: 0, y: 0, width: SAPinConstant.CircleWidth, height: SAPinConstant.CircleWidth))
            
            dotContainerView.addSubview(aBall)
            circleViews.append(aBall)
        }
    }
    fileprivate func layoutCircles() {
        for i in 0...3 {
            circleViews[i].snp.makeConstraints({ (make) in
                make.width.equalTo(SAPinConstant.CircleWidth)
                make.height.equalTo(SAPinConstant.CircleWidth)
            })
        }
        let dotLeading = (dotContainerWidth - 3*SAPinConstant.ButtonPadding - 4*SAPinConstant.CircleWidth)/2.0
        circleViews[0].snp.makeConstraints { (make) in
            make.leading.equalTo(dotContainerView).offset(dotLeading)
            make.top.equalTo(dotContainerView)
        }
        circleViews[3].snp.makeConstraints { (make) in
            make.trailing.equalTo(dotContainerView).offset(-dotLeading)
            make.top.equalTo(dotContainerView)
        }
        circleViews[2].snp.makeConstraints { (make) in
            make.trailing.equalTo(circleViews[3]).offset(-1.45*SAPinConstant.ButtonPadding)
            make.top.equalTo(dotContainerView)
        }
        circleViews[1].snp.makeConstraints { (make) in
            make.leading.equalTo(circleViews[0]).offset(1.45*SAPinConstant.ButtonPadding)
            make.top.equalTo(dotContainerView)
        }
    }
    fileprivate func addSubtitle() {
        subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont(name: SAPinConstant.DefaultFontName, size: 13.0)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.white
        blurView.addSubview(subtitleLabel)
        updateSubtitle()
    }
    fileprivate func updateSubtitle() {
        subtitleLabel.text = subtitleText
        subtitleLabel.snp.remakeConstraints { (make) in
            make.width.equalTo(dotContainerWidth)
            make.bottom.equalTo(dotContainerView.snp.top).offset(-5)
            make.centerX.equalTo(blurView.snp.centerX)
        }
    }
    fileprivate func addTitle() {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont(name: SAPinConstant.DefaultFontName, size: 17.0)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        blurView.addSubview(titleLabel)
        updateTitle()
    }
    fileprivate func updateTitle() {
        titleLabel.text = titleText ?? "Enter Passcode"
        titleLabel.snp.remakeConstraints { (make) in
            make.width.equalTo(dotContainerWidth)
            if subtitleLabel.text == "" {
                make.bottom.equalTo(dotContainerView.snp.top).offset(-17)
            } else {
                make.bottom.equalTo(subtitleLabel.snp.top).offset(-5)
            }
            make.centerX.equalTo(blurView.snp.centerX)
        }
    }
    fileprivate func addLogo() {
        let logoImageView = UIImageView(image: logoImage)
        blurView.addSubview(logoImageView)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.cornerRadius = SAPinConstant.LogoImageWidth/2.0
        logoImageView.clipsToBounds = true
        logoImageView.snp.makeConstraints { (make) in
            make.width.equalTo(SAPinConstant.LogoImageWidth)
            make.height.equalTo(SAPinConstant.LogoImageWidth)
            make.centerX.equalTo(blurView.snp.centerX)
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
    }
    fileprivate func addCancelButton() {
        cancelButton = UIButton(type: .custom)
        cancelButtonColor = titleLabel.textColor
        cancelButtonFont = titleLabel.font
        setAttributedTitleForButtonWithTitle(SAPinConstant.CancelString, font: cancelButtonFont, color: cancelButtonColor)
        cancelButton.addTarget(self, action: #selector(self.cancelDeleteTap), for: .touchUpInside)
        blurView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(numPadView.snp.trailing)
            if UIDevice.current.userInterfaceIdiom == .phone {
                // 3.5" special case 
                if isSmallScreen() {
                    make.bottom.equalTo(numPadView)
                } else {
                    if logoImage != nil {
                        make.bottom.equalTo(numPadView).offset(SAPinConstant.ButtonWidth - SAPinConstant.LogoImageWidth)
                    } else {
                        make.bottom.equalTo(numPadView).offset(SAPinConstant.ButtonWidth)
                    }
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
    fileprivate func isSmallScreen() -> Bool {
        return UIScreen.main.bounds.height == 480
    }
    fileprivate func setAttributedTitleForButtonWithTitle(_ title: String, font: UIFont, color: UIColor) {
        cancelButton.setAttributedTitle(NSAttributedString(string: title, attributes: [NSFontAttributeName:font,NSForegroundColorAttributeName:color]), for: UIControlState())
    }
    fileprivate func pinErrorAnimate() {
        for item in circleViews {
            UIView.animate(withDuration: 0.1, animations: {
                item.backgroundColor = item.circleBorderColor.withAlphaComponent(0.7)
                
                }, completion: { finished in
                    UIView.animate(withDuration: 0.5, animations: {
                        item.backgroundColor = UIColor.clear
                    })
            })
        }
        animateView()
    }
    fileprivate func animateView() {
        setOptions()
        animate()
    }
    
    fileprivate func setOptions() {
        for item in circleViews {
            item.force = 2.2
            item.duration = 1
            item.delay = 0
            item.damping = 0.7
            item.velocity = 0.7
            item.animation = "spring"
        }
    }
    
    fileprivate func animate() {
        for item in circleViews {
            item.animateFrom = true
            item.animatePreset()
            item.setView{}
        }
    }
    
}

extension SAPinViewController: SAButtonViewDelegate {
    func buttonTappedWithTag(_ tag: Int) {
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

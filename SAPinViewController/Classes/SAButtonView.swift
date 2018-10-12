//
//  SAButtonView.swift
//  PINManagement
//
//  Created by Siavash on 21/08/2016.
//  Copyright © 2016 Siavash Abbasalipour. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol SAButtonViewDelegate {
    
    func buttonTappedWithTag(_ tag: Int)
}

class SAButtonView: UIView {
    
    var delegate: SAButtonViewDelegate?
    
    var font: UIFont! {
        didSet {
            numberLabel.font = font.withSize(SAPinConstant.MaxNumberFontSize)
            alphabetLabel.font = font.withSize(SAPinConstant.MaxAlphabetFontSize)
        }
    }
    
    var showAlphabet: Bool! {
        didSet {
            if !showAlphabet {
                alphabetLabel.text = ""
                layoutButtonNumber()
            }
        }
    }
    
    var buttonBorderColor: UIColor! {
        didSet {
            layer.borderColor = buttonBorderColor.withAlphaComponent(0.8).cgColor
        }
    }
    
    var numberColor: UIColor! {
        didSet {
            numberLabel.textColor = numberColor
        }
    }
    
    var alphabetColor: UIColor! {
        didSet {
            alphabetLabel.textColor = alphabetColor
        }
    }
    
    var numberTag: Int = 0 {
        didSet {
            numberLabel.text = "\(numberTag)"
            layoutButtonNumber()
            if showAlphabet && showAlphabet == true {
                switch numberTag {
                case 0,1:
                    alphabetLabel.text = ""
                case 2:
                    alphabetLabel.text = "ABC"
                case 3:
                    alphabetLabel.text = "DEF"
                case 4:
                    alphabetLabel.text = "GHI"
                case 5:
                    alphabetLabel.text = "JKL"
                case 6:
                    alphabetLabel.text = "MNO"
                case 7:
                    alphabetLabel.text = "PQRS"
                case 8:
                    alphabetLabel.text = "TUV"
                case 9:
                    alphabetLabel.text = "WXYZ"
                default:
                    assert(false, "number tag should be between 0-9")
                }
            }
        }
    }
    
    var isRoundedRect: Bool! {
        didSet {
            layer.cornerRadius = (isRoundedRect == true) ? frame.size.width/4.0 : frame.size.width/2.0
        }
    }
    
    fileprivate var numberLabel: UILabel!
    fileprivate var alphabetLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Default values
        font = UIFont(name: SAPinConstant.DefaultFontName, size: SAPinConstant.MaxNumberFontSize)
        buttonBorderColor = UIColor.white
        showAlphabet = true
        numberColor = UIColor.white
        alphabetColor = UIColor.white
        
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    fileprivate func layoutButtonNumber() {
        numberLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            if numberTag == 0 || !showAlphabet {
                make.height.equalTo(frame.size.height)
            } else {
                make.height.equalTo(0.8 * frame.size.height)
            }
        }
    }
    fileprivate func layoutAlphabet() {
        alphabetLabel.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self).offset(-11)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
    }
    fileprivate func setupSubViews() {
        layer.cornerRadius = frame.size.width/2.0
        layer.borderWidth = 1
        layer.borderColor = buttonBorderColor.withAlphaComponent(0.8).cgColor
        numberLabel = UILabel()
        addSubview(numberLabel)
        numberLabel.textColor = numberColor
        numberLabel.textAlignment = .center
        numberLabel.font = font.withSize(SAPinConstant.MaxNumberFontSize)
        numberLabel.text = "9"
        
        alphabetLabel = UILabel()
        addSubview(alphabetLabel)
        alphabetLabel.textColor = alphabetColor
        alphabetLabel.textAlignment = .center
        alphabetLabel.font = font.withSize(SAPinConstant.MaxAlphabetFontSize)
        alphabetLabel.text = "WXYZ"
        numberTag = 0
        layoutAlphabet()
        layoutButtonNumber()
        
        let btn = UIButton()
        addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        btn.addTarget(self, action: #selector(self.btnDown), for: .touchDown)
        btn.addTarget(self, action: #selector(self.btnTap), for: .touchUpInside)
        btn.addTarget(self, action: #selector(self.btnCancel), for: .touchCancel)
        btn.addTarget(self, action: #selector(self.btnCancel), for: .touchDragExit)
        btn.addTarget(self, action: #selector(self.btnDown), for: .touchDragEnter)
    }
    
    func btnDown() {
        UIView.animate(withDuration: 0.17, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundColor = self.buttonBorderColor.withAlphaComponent(0.4)
        })
    }
    
    func btnCancel() {
        UIView.animate(withDuration: 0.17, delay: 0, options: .curveEaseIn, animations: {
            UIView.animate(withDuration: 0.17, delay: 0.1, options: .curveEaseOut, animations: {
                self.backgroundColor = UIColor.clear
            })
        })
    }
    
    func btnTap() {
        delegate?.buttonTappedWithTag(numberTag)
        UIView.animate(withDuration: 0.17, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundColor = self.buttonBorderColor.withAlphaComponent(0.4)
        }) { (isFinish) in
            if isFinish {
                UIView.animate(withDuration: 0.17, delay: 0.1, options: .curveEaseOut, animations: {
                    self.backgroundColor = UIColor.clear
                }, completion: nil)
            }
        }
    }
    
}

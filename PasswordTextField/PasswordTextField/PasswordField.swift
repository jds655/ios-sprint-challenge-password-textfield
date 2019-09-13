//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum passwordStrength {
    case weak
    case medium
    case strong
}

@IBDesignable
class PasswordField: UIControl {
    
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    private (set) var strength: passwordStrength = .weak
    private var secureEntry: Bool = true
    
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldMargin: CGFloat = 6.0
    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
    
    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let bgColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
    
    // States of the password strength indicators
    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)
    
    private var titleLabel: UILabel = UILabel()
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    private var strengthDescriptionLabel: UILabel = UILabel()
    
    func setup() {
        // Lay out your subviews here
        backgroundColor = bgColor
        
        //Setup Title Label
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: standardMargin).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: standardMargin).isActive = true
        titleLabel.font = labelFont
        titleLabel.textColor = labelTextColor
        titleLabel.text = "Please enter password:"
        
        //Setup Text Field
        addSubview(textField)
        textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: textFieldMargin).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textFieldMargin).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: textFieldMargin).isActive = true
        textField.heightAnchor.constraint(equalToConstant: textFieldContainerHeight)
        textField.layer.borderColor = textFieldBorderColor.cgColor
        textField.isSecureTextEntry = secureEntry
        textField.placeholder = "Enter Password Here"
        
        //Setup Show/Hide button
        textField.addSubview(showHideButton)
        showHideButton.topAnchor.constraint(equalTo: textField.topAnchor, constant: 0).isActive = true
        showHideButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 0).isActive = true
        showHideButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 0).isActive = true
        showHideButton.adjustsImageWhenHighlighted = true
        showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        showHideButton.setImage(UIImage(named: "eyes-open"), for: .selected)
        
        //Setup WeakView
        addSubview(weakView)
        weakView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin).isActive = true
        weakView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func determineStrength(with password: String) -> passwordStrength {
        let length = password.count
        switch length {
        case 0...9:
            return .weak
        case 10...19:
            return .medium
        default:
            return .strong
        }
    }
    
}

extension PasswordField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        // TODO: send new text to the determine strength method
        let _ = determineStrength(with: newText)
        return true
    }
}

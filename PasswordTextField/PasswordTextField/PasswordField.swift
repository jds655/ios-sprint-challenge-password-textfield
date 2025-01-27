//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum PasswordStrength: String {
    case weak = "Too Weak"
    case medium = "Could Be Stronger"
    case strong = "Strong Password"
}

protocol PasswordFieldDelegate {
    func passwordSucceeded ()
    func passwordFailed()
}

@IBDesignable
class PasswordField: UIControl {
    
    var delegate: PasswordFieldDelegate?
    var bgColor: UIColor? {
        didSet{
            backgroundColor = bgColor
            setNeedsDisplay()
        }
    }
    
    // Private API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    private (set) var strength: PasswordStrength = .weak
    private var secureEntry: Bool = true
    
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 40.0
    private let textFieldMargin: CGFloat = 6.0
    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
    
    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let textFieldBackgroundColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
    
    // States of the password strength indicators
    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)
    private let CornerRadius: CGFloat = 5
    
    private var titleLabel: UILabel = UILabel()
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    private var strengthDescriptionLabel: UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        // Lay out your subviews here
        layer.cornerRadius = CornerRadius
        
        //Setup Title Label
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: standardMargin).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: standardMargin).isActive = true
        titleLabel.font = labelFont
        titleLabel.textColor = labelTextColor
        titleLabel.text = "Please enter password:"
        
        //Setup Show/Hide button
        addSubview(showHideButton)
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        showHideButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: standardMargin).isActive = true
        //showHideButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 0).isActive = true
        showHideButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardMargin).isActive = true
        showHideButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        showHideButton.heightAnchor.constraint(equalTo: showHideButton.widthAnchor).isActive = true
        //showHideButton.bottomAnchor.constraint(equalTo: strengthDescriptionLabel.topAnchor, constant: -standardMargin).isActive = true
        showHideButton.adjustsImageWhenHighlighted = true
        showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        showHideButton.setImage(UIImage(named: "eyes-open"), for: .highlighted)
        showHideButton.addTarget(self, action: #selector(changeHideShow), for: .touchUpInside)
        
        //Setup Text Field
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: textFieldMargin).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textFieldMargin).isActive = true
        textField.trailingAnchor.constraint(equalTo: showHideButton.leadingAnchor, constant: -textFieldMargin).isActive = true
        textField.heightAnchor.constraint(equalToConstant: textFieldContainerHeight).isActive = true
        textField.layer.borderColor = textFieldBorderColor.cgColor
        textField.layer.borderWidth = 2
        textField.isSecureTextEntry = secureEntry
        textField.backgroundColor = textFieldBackgroundColor
        textField.placeholder = "Enter Password Here"
        textField.layer.cornerRadius = 5
        textField.delegate = self
        
        //Setup WeakView
        addSubview(weakView)
        weakView.translatesAutoresizingMaskIntoConstraints = false
        weakView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin).isActive = true
        weakView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin).isActive = true
        //weakView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -standardMargin).isActive = true
        weakView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        weakView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        weakView.backgroundColor = weakColor
        weakView.layer.cornerRadius = CornerRadius
        weakView.performFlare()
        
        //Setup MediumView
        addSubview(mediumView)
        mediumView.translatesAutoresizingMaskIntoConstraints = false
        mediumView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin).isActive = true
        mediumView.leadingAnchor.constraint(equalTo: weakView.trailingAnchor, constant: standardMargin).isActive = true
        //mediumView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -standardMargin).isActive = true
        mediumView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        mediumView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        mediumView.layer.cornerRadius = CornerRadius
        mediumView.backgroundColor = unusedColor
        
        //Setup StrongView
        addSubview(strongView)
        strongView.translatesAutoresizingMaskIntoConstraints = false
        strongView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin).isActive = true
        strongView.leadingAnchor.constraint(equalTo: mediumView.trailingAnchor, constant: standardMargin).isActive = true
        //strongView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -standardMargin).isActive = true
        strongView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        strongView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        strongView.layer.cornerRadius = CornerRadius
        strongView.backgroundColor = unusedColor
        
        //Setup Strength Description Label
        addSubview(strengthDescriptionLabel)
        strengthDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        strengthDescriptionLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin).isActive = true
        strengthDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -standardMargin).isActive = true
        strengthDescriptionLabel.leadingAnchor.constraint(equalTo: strongView.trailingAnchor, constant: standardMargin).isActive = true
        strengthDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardMargin).isActive = true
        //strengthDescriptionLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor).isActive = true
        strengthDescriptionLabel.font = labelFont
        strengthDescriptionLabel.textColor = labelTextColor
        strengthDescriptionLabel.text = self.strength.rawValue
        
        bottomAnchor.constraint(equalTo: strengthDescriptionLabel.bottomAnchor, constant: standardMargin)
    }
    
    @objc private func changeHideShow() {
        secureEntry = !secureEntry
        if secureEntry {
            showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        } else {
            showHideButton.setImage(UIImage(named: "eyes-open"), for: .normal)
        }
        textField.togglePasswordVisibility()
    }
    
    private func updateStrength (with strength: PasswordStrength) {
        if self.strength != strength {
            strengthDescriptionLabel.text = strength.rawValue
            switch strength {
            case .weak:
                weakView.backgroundColor = weakColor
                mediumView.backgroundColor = unusedColor
                strongView.backgroundColor = unusedColor
                weakView.performFlare()
            case .medium:
                weakView.backgroundColor = weakColor
                mediumView.backgroundColor = mediumColor
                strongView.backgroundColor = unusedColor
                mediumView.performFlare()
            case .strong:
                weakView.backgroundColor = weakColor
                mediumView.backgroundColor = mediumColor
                strongView.backgroundColor = strongColor
                strongView.performFlare()
            }
            self.strength = strength
        }
    }
    
    private func countSpecialChars(within: String) -> Int {
        let specChars: String = "!@#$%^&*()-_=+`~;:<>?/.,\\|[]{}1234567890"
        var specCount: Int = 0
        for char in specChars {
            if within.contains(char) { specCount += 1}
        }
        //print (specCount)
        return specCount
    }
    
    private func determineStrength(with password: String) {
        let length = password.count
        let specCount = countSpecialChars(within: password)
        var result: PasswordStrength
        switch length + (specCount * 2){
        case 0...9:
            result = .weak
        case 10...19:
            result = .medium
        default:
            result = .strong
        }
        updateStrength(with: result)
    }
}

extension PasswordField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        // TODO: send new text to the determine strength method
        //print (newText)
        determineStrength(with: newText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch self.strength {
        case .strong:
            if let delegate = delegate {
                delegate.passwordSucceeded()
            }
            return true
        default:
            if let delegate = delegate {
                delegate.passwordFailed()
            }
            return false
        }
    }
}

extension UIView {
    // "Flare view" animation sequence
    func performFlare() {
        func flare()   { transform = CGAffineTransform(scaleX: 1.6, y: 1.6) }
        func unflare() { transform = .identity }
        
        UIView.animate(withDuration: 0.3,
                       animations: { flare() },
                       completion: { _ in UIView.animate(withDuration: 0.1) { unflare() }})
    }
}

extension UITextField {
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry
        
        if let existingText = text, isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            deleteBackward()
            
            if let _/*textRange*/ = textRange(from: beginningOfDocument, to: endOfDocument) {
                //replace(textRange, withText: existingText)
                text = existingText
            }
        }
        
        /* Reset the selected text range since the cursor can end up in the wrong
         position after a toggle because the text might vary in width */
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}

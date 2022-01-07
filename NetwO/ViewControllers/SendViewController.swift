//
//  SendViewController.swift
//  NetwO
//
//  Created by Alain Grange on 09/05/2021.
//

import UIKit

@objc protocol SendViewControllerDelegate {
    @objc optional func sendValues(sendViewController: SendViewController, list: [Int])
}

class SendViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var sfValues = [String]()
    let resetSF = 12
    let resetNbFrame = 5
    let resetADR = false
    var yContent: CGFloat = 0.0
    
    let backgroundButton = UIButton()
    let contentView = UIView()
    let sfTextField = UITextField()
    let sfPickerView = UIPickerView()
    let nbFramesTextField = UITextField()
    let adrSwitch = UISwitch()
    
    var delegate: SendViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sf values
        sfValues.append("7")
        sfValues.append("8")
        sfValues.append("9")
        sfValues.append("10")
        sfValues.append("11")
        sfValues.append("12")
        
        // background button
        backgroundButton.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        backgroundButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        backgroundButton.backgroundColor = .black
        backgroundButton.alpha = 0.0
        self.view.addSubview(backgroundButton)
        
        // content view
        contentView.frame = CGRect(x: 20.0, y: 0.0, width: self.view.frame.size.width - 40.0, height: 0.0)
        contentView.autoresizingMask = .flexibleWidth
        contentView.backgroundColor = ColorGreyMedium
        contentView.alpha = 0.0
        self.view.addSubview(contentView)
        
        var yPosition: CGFloat = 20.0
        
        // title label
        let titleLabel = UILabel(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 30.0))
        titleLabel.autoresizingMask = .flexibleWidth
        titleLabel.textAlignment = .center
        titleLabel.textColor = ColorTextGreyLight
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.text = NSLocalizedString("receive", comment: "")
        contentView.addSubview(titleLabel)
        
        yPosition += titleLabel.frame.size.height + 20.0
        
        // sf label
        let sfTitleLabel = UILabel(frame: CGRect(x: 0.0, y: yPosition, width: contentView.frame.size.width / 2.0, height: 40.0))
        sfTitleLabel.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth]
        sfTitleLabel.textAlignment = .right
        sfTitleLabel.textColor = ColorTextGreyLight
        sfTitleLabel.font = UIFont.systemFont(ofSize: 16.0)
        sfTitleLabel.text = "SF"
        contentView.addSubview(sfTitleLabel)
        
        // sf textfield
        sfTextField.frame = CGRect(x: contentView.frame.size.width / 2.0, y: yPosition, width: contentView.frame.size.width / 2.0, height: 40.0)
        sfTextField.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth]
        sfTextField.backgroundColor = .clear
        sfTextField.returnKeyType = .done
        sfTextField.keyboardType = .numberPad
        sfTextField.font = UIFont.systemFont(ofSize: 16.0)
        sfTextField.textAlignment = .center
        sfTextField.textColor = .white
        sfTextField.text = "12"
        contentView.addSubview(sfTextField)
        
        let sfBottomLine = CALayer()
        sfBottomLine.frame = CGRect(x: 15.0, y: sfTextField.frame.height - 1, width: sfTextField.frame.size.width - 30.0, height: 1.0)
        sfBottomLine.backgroundColor = UIColor.white.cgColor
        sfBottomLine.backgroundColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        sfTextField.borderStyle = .none
        sfTextField.layer.addSublayer(sfBottomLine)
        
        // sf pickerview
        sfPickerView.dataSource = self
        sfPickerView.delegate = self
        sfTextField.inputView = sfPickerView
        
        let sfTextFieldToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        var sfBarItems = [UIBarButtonItem]()
        sfBarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        sfBarItems.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction)))
        sfTextFieldToolbar.items = sfBarItems
        sfTextField.inputAccessoryView = sfTextFieldToolbar
        
        yPosition += sfTitleLabel.frame.size.height + 20.0
        
        // nb frames label
        let nbFramesLabel = UILabel(frame: CGRect(x: 0.0, y: yPosition, width: contentView.frame.size.width / 2.0, height: 40.0))
        nbFramesLabel.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth]
        nbFramesLabel.textAlignment = .right
        nbFramesLabel.textColor = ColorTextGreyLight
        nbFramesLabel.font = UIFont.systemFont(ofSize: 16.0)
        nbFramesLabel.text = NSLocalizedString("numberOfFrame", comment: "")
        contentView.addSubview(nbFramesLabel)
        
        // nb frame textfield
        nbFramesTextField.frame = CGRect(x: contentView.frame.size.width / 2.0, y: yPosition, width: contentView.frame.size.width / 2.0, height: 40.0)
        nbFramesTextField.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth]
        nbFramesTextField.delegate = self
        nbFramesTextField.backgroundColor = .clear
        nbFramesTextField.returnKeyType = .done
        nbFramesTextField.keyboardType = .numberPad
        nbFramesTextField.font = UIFont.systemFont(ofSize: 16.0)
        nbFramesTextField.textAlignment = .center
        nbFramesTextField.textColor = .white
        nbFramesTextField.text = "5"
        contentView.addSubview(nbFramesTextField)
        
        let nbFramesBottomLine = CALayer()
        nbFramesBottomLine.frame = CGRect(x: 15.0, y: nbFramesTextField.frame.height - 1, width: nbFramesTextField.frame.size.width - 30.0, height: 1.0)
        nbFramesBottomLine.backgroundColor = UIColor.white.cgColor
        nbFramesBottomLine.backgroundColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        nbFramesTextField.borderStyle = .none
        nbFramesTextField.layer.addSublayer(nbFramesBottomLine)
        
        let nbFramesTextFieldToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        var nbFramesBarItems = [UIBarButtonItem]()
        nbFramesBarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        nbFramesBarItems.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction)))
        nbFramesTextFieldToolbar.items = nbFramesBarItems
        nbFramesTextField.inputAccessoryView = nbFramesTextFieldToolbar
        
        yPosition += nbFramesLabel.frame.size.height + 20.0
        
        // adr label
        let adrLabel = UILabel(frame: CGRect(x: 0.0, y: yPosition, width: contentView.frame.size.width / 2.0, height: 40.0))
        adrLabel.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth]
        adrLabel.textAlignment = .right
        adrLabel.textColor = ColorTextGreyLight
        adrLabel.font = UIFont.systemFont(ofSize: 16.0)
        adrLabel.text = "ADR"
        contentView.addSubview(adrLabel)
        
        // adr switch
        adrSwitch.frame = CGRect(x: adrLabel.frame.origin.x + adrLabel.frame.size.width + 20.0, y: yPosition, width: adrSwitch.frame.size.width, height: adrSwitch.frame.size.height)
        adrSwitch.tintColor = ColorGreyLight
        contentView.addSubview(adrSwitch)
        
        yPosition += adrLabel.frame.size.height + 20.0
        
        // send button
        let sendButton = UIButton(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 40.0))
        sendButton.autoresizingMask = .flexibleWidth
        sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        sendButton.backgroundColor = ColorGreyLight
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.setTitle(NSLocalizedString("send", comment: ""), for: .normal)
        contentView.addSubview(sendButton)
        
        yPosition += sendButton.frame.size.height + 20.0
        
        // reset button
        let resetButton = UIButton(frame: CGRect(x: 20.0, y: yPosition, width: contentView.frame.size.width - 40.0, height: 40.0))
        resetButton.autoresizingMask = .flexibleWidth
        resetButton.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        resetButton.backgroundColor = ColorGreyLight
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.setTitle(NSLocalizedString("reset", comment: ""), for: .normal)
        contentView.addSubview(resetButton)
        
        yPosition += resetButton.frame.size.height + 20.0
        
        // content view size
        contentView.frame = CGRect(x: contentView.frame.origin.x, y: ((self.view.frame.size.height - yPosition) / 2.0), width: self.view.frame.size.width - 40.0, height: yPosition)
        contentView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        
        self.yContent = contentView.frame.origin.y
        
        // set default values
        resetAction()
        
        // keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {

            self.backgroundButton.alpha = 0.5
            self.contentView.alpha = 1.0

        }, completion: { (finished: Bool) in

        })
        
    }
    
    // MARK: - Actions
    
    @objc func dismissAction() {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {

            self.backgroundButton.alpha = 0.0
            self.contentView.alpha = 0.0

        }, completion: { (finished: Bool) in
            self.dismiss(animated: false, completion: nil)
        })
        
    }
    
    @objc func doneAction() {
        sfTextField.resignFirstResponder()
        nbFramesTextField.resignFirstResponder()
    }
    
    @objc func sendAction() {
        
        var sfValue = resetSF
        if let value = Int(sfTextField.text ?? "0") {
            sfValue = value
        }
        
        var nbFrames = resetNbFrame
        if let value = Int(nbFramesTextField.text ?? "0") {
            nbFrames = value
        }
        if nbFrames >= 1 && nbFrames < 100 {
            
            let adrValue = adrSwitch.isOn ? 1 : 0
            
            var list = [Int]()
            list.append(sfValue)
            list.append(nbFrames)
            list.append(adrValue)
            
            self.delegate?.sendValues?(sendViewController: self, list: list)
            
            dismissAction()
            
        } else {
            Utils.showAlert(view: self.view, message: NSLocalizedString("wrongNbrTrame", comment: ""))
        }
        
    }
    
    @objc func resetAction() {
        
        sfPickerView.selectRow(5, inComponent: 0, animated: false)
        sfTextField.text = "\(resetSF)"
        nbFramesTextField.text = "\(resetNbFrame)"
        adrSwitch.isOn = resetADR
        
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nbFramesTextField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIPickerView DataSource and Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sfValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sfTextField.text = "\(sfValues[row])"
    }
    
    // MARK: - Keyboard Management
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo
        let animationDuration: TimeInterval = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let animationCurve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!

        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue)), .beginFromCurrentState], animations: {
            
            self.contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: self.yContent - 50.0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
            
        }, completion: { (finished: Bool) in })
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        let userInfo = notification.userInfo
        let animationDuration: TimeInterval = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let animationCurve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue)), .beginFromCurrentState], animations: {
            
            self.contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: self.yContent, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
            
        }, completion: { (finished: Bool) in })
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
}

//
//  ReportViewController.swift
//  NetwO
//
//  Created by Alain Grange on 11/05/2021.
//

import UIKit

@objc protocol ReportViewControllerDelegate {
    @objc optional func selectReport(reportViewController: ReportViewController, action: String)
}

class ReportViewController: UIViewController {
    
    let backgroundButton = UIButton()
    let contentView = UIView()
    
    var delegate: ReportViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background button
        backgroundButton.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        backgroundButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
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
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16.0)
        titleLabel.textColor = ColorTextGreyLight
        titleLabel.text = NSLocalizedString("reportchoose", comment: "")
        contentView.addSubview(titleLabel)
        
        yPosition += titleLabel.frame.size.height + 20.0
        
        // buttons view
        let buttonsView = UIView(frame: CGRect(x: (contentView.frame.size.width - 240.0) / 2.0, y: yPosition, width: 240.0, height: 40.0))
        buttonsView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        contentView.addSubview(buttonsView)
        
        // json button
        let jsonButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 115.0, height: 40.0))
        jsonButton.addTarget(self, action: #selector(jsonAction), for: .touchUpInside)
        jsonButton.backgroundColor = ColorGreyLight
        jsonButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        jsonButton.setTitleColor(.white, for: .normal)
        jsonButton.setTitle(NSLocalizedString("reportjson", comment: ""), for: .normal)
        buttonsView.addSubview(jsonButton)
        
        // csv button
        let csvButton = UIButton(frame: CGRect(x: 125.0, y: 0.0, width: 115.0, height: 40.0))
        csvButton.addTarget(self, action: #selector(csvAction), for: .touchUpInside)
        csvButton.backgroundColor = ColorGreyLight
        csvButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        csvButton.setTitleColor(.white, for: .normal)
        csvButton.setTitle(NSLocalizedString("reportcsv", comment: ""), for: .normal)
        buttonsView.addSubview(csvButton)
        
        yPosition += buttonsView.frame.size.height + 20.0
        
        // content view size
        contentView.frame = CGRect(x: contentView.frame.origin.x, y: ((self.view.frame.size.height - yPosition) / 2.0), width: self.view.frame.size.width - 40.0, height: yPosition)
        contentView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        
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
    
    @objc func closeAction() {
        dismissAction(action: nil)
    }
    
    @objc func dismissAction(action: String?) {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {

            self.backgroundButton.alpha = 0.0
            self.contentView.alpha = 0.0

        }, completion: { (finished: Bool) in
            
            self.dismiss(animated: false) {
                
                if let actionString = action, actionString.count > 0 {
                    self.delegate?.selectReport?(reportViewController: self, action: actionString)
                }
                
            }
            
        })
        
    }
    
    @objc func jsonAction() {
        dismissAction(action: "json")
    }
    
    @objc func csvAction() {
        dismissAction(action: "csv")
    }
    
}
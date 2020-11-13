//
//  NodePicker.swift
//  
//
//  Created by Joe Bakalor on 3/6/20.
//

import Foundation
import UIKit

public protocol NodePickerDelegate {
    func selectedOperation(operation: Operation)
}

open class NodePicker: UIView {
    
    private let hideShowButton      = UIButton()
    private let nodeTable           = UITableView()
    private let buttonBackground    = CAShapeLayer()
    private var onButtonClick: (()->Void)?
    public var delegate: NodePickerDelegate?
    
    public convenience init() {
        self.init(frame: CGRect.zero)
        self.initView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }

    open func initView() {
        self.layer.addSublayer(buttonBackground)
        self.addSubview(nodeTable)
        self.addSubview(hideShowButton)
        nodeTable.dataSource = self
        nodeTable.delegate = self
        
        //hideShowButton.backgroundColor = UIColor.blue
        hideShowButton.setTitle("⏏︎", for: .normal)
        hideShowButton.addTarget(self, action: #selector(click), for: .touchDown)
    }
    
    public func onClick(_ handler: (()-> Void)?){
        self.onButtonClick = handler
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        hideShowButton.frame =
            CGRect(
                x: 0,
                y: 0,
                width: self.bounds.width,
                height: self.bounds.height*0.1)
            //.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))
        
        let buttonBackgroundPath =
            UIBezierPath(
                roundedRect: hideShowButton.frame,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: 5, height: 5))
        
        buttonBackground.fillColor = UIColor.systemBlue.cgColor
        buttonBackground.path = buttonBackgroundPath.cgPath
        
        nodeTable.frame =
            CGRect(
                x: 0,
                y: self.bounds.height*0.1,
                width: self.bounds.width,
                height: self.bounds.height*0.9)
    }
    
    @objc
    func click(){
        onButtonClick?()
    }

}

extension NodePicker: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Operation.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.systemBlue
        cell.textLabel?.text = "\(Operation.allCases[indexPath.row].rawValue)"
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let op = Operation.allCases[indexPath.row]
        delegate?.selectedOperation(operation: op)
    }
}

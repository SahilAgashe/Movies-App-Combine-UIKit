//
//  BarcodeScanController.swift
//  Movies App
//
//  Created by SAHIL AMRUT AGASHE on 15/06/24.
//

import UIKit

class BarcodeScanController: UIViewController {
    
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .black
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 20 ,width: 90, height: 35)
    }
    
    @objc func cancelButtonAction() {
        dismiss(animated: true)
    }
    
}

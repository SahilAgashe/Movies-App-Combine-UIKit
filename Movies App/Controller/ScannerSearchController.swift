//
//  ScannerSearchController.swift
//  Movies App
//
//  Created by SAHIL AMRUT AGASHE on 14/06/24.
//

import UIKit

class ScannerSearchController: UIViewController {
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        searchTextField.placeholder = "Search here..."
        searchTextField.backgroundColor = .white
        
        let barcodeImg = UIImage(named: "barcode")
        let barcodeImageView = UIImageView(image: barcodeImg)
        barcodeImageView.contentMode = .scaleAspectFit
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(barcodeAction))
        barcodeImageView.addGestureRecognizer(tap)
        barcodeImageView.isUserInteractionEnabled = true
        
        searchTextField.rightView = barcodeImageView
        searchTextField.rightViewMode = .always
        return searchTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Go Scanner"
        view.backgroundColor = .white
        
        view.addSubview(searchTextField)
        searchTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 10, paddingRight: 10, height: 40)
    }
    
    @objc func barcodeAction() {
        let barcodeScanVC = BarcodeScanController()
        barcodeScanVC.modalPresentationStyle = .fullScreen
        present(barcodeScanVC, animated: true)
    }
}

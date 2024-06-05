//
//  String+Extension.swift
//  Movies App
//
//  Created by SAHIL AMRUT AGASHE on 05/06/24.
//

import Foundation

extension String {
    
    var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
}


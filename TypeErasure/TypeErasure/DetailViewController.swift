//
//  DetailViewController.swift
//  TypeErasure
//
//  Created by Siavash on 4/09/2016.
//  Copyright © 2016 MobileDen. All rights reserved.
//

import Foundation
import UIKit

final class DetailViewController: UIViewController {
    
    var delegate: AnyCellReloadable<Transaction>?
    @IBAction func btnTap(_ sender: UIButton) {
        let aTransaction = Transaction(name: "transaction", color: UIColor.purple())
        delegate?.shouldShowLoading(true, for: aTransaction)
    }
}

final class DetailViewController2: UIViewController {
    
    var delegate: AnyCellReloadable<Meal>?
    @IBAction func btnTap(_ sender: UIButton) {
        let aMeal = Meal(name: "meal", color: UIColor.red())
        delegate?.shouldShowLoading(true, for: aMeal)
    }
}

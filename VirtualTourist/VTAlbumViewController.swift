//
//  AlbumViewController.swift
//  VirtualTourist
//
//  Created by Jacob Marttinen on 4/9/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import UIKit

// MARK: - VTAlbumViewController: UIViewController

class VTAlbumViewController: UIViewController {
    
    // MARK: Properties
    
    var id : String!
    
    // MARK: Outlets
    
    @IBOutlet weak var idLabel: UILabel!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        idLabel.text = id
    }
}

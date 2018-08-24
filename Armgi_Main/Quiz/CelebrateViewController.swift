//
//  CelebrateViewController.swift
//  Armgi_Main
//
//  Created by Tars on 8/11/18.
//  Copyright © 2018 sspog. All rights reserved.
//

import UIKit

class CelebrateViewController: UIViewController {

    var delegate:BasicQuizViewController?
    var delegate2:FlipQuizViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back(_ sender: Any) {
        delegate?.pop = true
        delegate2?.pop = true
        self.dismiss(animated: true, completion: nil)
    }

}

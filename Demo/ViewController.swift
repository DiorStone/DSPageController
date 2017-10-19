//
//  ViewController.swift
//  Demo
//
//  Created by DaiLingchi on 2017/10/18.
//  Copyright © 2017年 DiorStone. All rights reserved.
//

import UIKit
import DSPageController

class ViewController: PageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfViewController(_ viewController: PageContentViewController) -> Int {
        return 2
    }

    override func contentViewController(_ viewController: PageContentViewController, viewControllerAt index: Int) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor =  (index % 2 == 0) ? .red : .yellow
        return viewController
    }
}


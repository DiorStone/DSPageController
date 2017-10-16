//
//  ViewController.swift
//  Demo
//
//  Created by DaiLingchi on 2017/10/13.
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


}

extension ViewController  {
    
    func numberOfViewControllers(_ pageViewController: PageViewController) -> Int {
        return 2
    }
    
    func pageViewController(_ pageViewController: PageViewController, viewControllerAtIndex index: Int) -> UIViewController {
        let vc = UIViewController()
        print("create view")
        vc.view.backgroundColor = index%2 == 0 ? UIColor.red : UIColor.yellow
        return vc
    }
}


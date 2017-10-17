//
//  ViewController.swift
//  Demo
//
//  Created by DaiLingchi on 2017/10/13.
//  Copyright © 2017年 DiorStone. All rights reserved.
//

import UIKit

import DSPageController

class ViewController: PageContentViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: PageContentViewControllerDataSource  {
    func contentViewController(_ viewController: PageContentViewController, viewControllerAt index: Int) -> UIViewController {
        let vc = UIViewController()
        print("create view")
        vc.view.backgroundColor = index%2 == 0 ? UIColor.red : UIColor.yellow
        return vc
    }
    
    
    func numberOfViewController(_ viewController: PageContentViewController) -> Int {
        return 2
    }
}


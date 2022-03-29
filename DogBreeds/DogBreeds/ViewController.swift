//
//  ViewController.swift
//  DogBreeds
//
//  Created by mac on 2022-02-06.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dogName: UILabel!
    
    var dogList = [Dog]()
    
    @IBAction func reloadData(_ sender: Any) {
            
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DogAPIHelper.fetch{
                    dogList in
                    self.dogName.text = dogList[0].name
        
    }


}

}

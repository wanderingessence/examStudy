/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    
    @IBOutlet weak var goToSiteButton: UIButton! //button to go to the next page
    
    @IBAction func buttonToSiteAction(_ sender: Any) {
        
        //this is the button that sends the user to the login window
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("the app is ready") //debugger message to notify the user the app is ready
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

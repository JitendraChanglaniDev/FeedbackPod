//
//  FeedbackSetting.swift
//  FeedbackDemo
//
//  Created by Jitendra Changlani on 24/10/17.
//  Copyright © 2017 Jitendra Changlani. All rights reserved.
//

import UIKit
public class FeedbackSetting {
    
    
    //MARK:- Initialize AdminSettingsViewController
    public init(controller: UIViewController) {
        let controller = FeedbackVC(nibName: "FeedbackVC", bundle: nil)
        controller.setUpTheController(parentVC: controller)
    }
}

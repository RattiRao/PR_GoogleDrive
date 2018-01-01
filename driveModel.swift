//
//  driveModel.swift
//  DrAppraisal
//
//  Created by Rati on 29/09/17.
//  Copyright © 2017 Vikash Kumar Sahu. All rights reserved.
//

import UIKit

class driveModel: NSObject {

    var fileName : String!
    var id : String!
    
    init(strFileName : String, strId : String)
    {
        fileName = strFileName
        id = strId
    }
}

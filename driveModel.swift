

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

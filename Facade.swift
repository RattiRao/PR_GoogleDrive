//
//  Facade.swift
//  DrAppraisal
//
//  Created by Rati on 29/09/17.
//  Copyright © 2017 Vikash Kumar Sahu. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

class Facade: NSObject {
    
    static let shareInstance : Facade = Facade()
    typealias completionBlock = (_ arrData : Array<driveModel>?, _ success : Bool) -> Void
    
    
    func loadDrive(completion : @escaping completionBlock)
    {
        let query : GTLRDriveQuery_FilesList = GTLRDriveQuery_FilesList.query()
        let driveService : GTLRDriveService = GTLRDriveService.init()
        var arrData : Array<driveModel> = Array()
        
        if (GIDSignIn.sharedInstance().currentUser != nil)
        {
            driveService.authorizer = GIDSignIn.sharedInstance().currentUser.authentication.fetcherAuthorizer()
            
            query.q = "mimeType = 'text/plain'"
            query.pageSize = 100
            query.fields = "files(id,name,mimeType,modifiedTime),nextPageToken"
            
            driveService.executeQuery(query) { (serviceTick, files, error) in
                
                if error == nil
                {
                    let driveFileList : GTLRDrive_FileList = files as! GTLRDrive_FileList
                    
                    for file in driveFileList.files!
                    {
                        let model : driveModel = driveModel.init(strFileName: file.name!, strId: file.identifier!)
                        
                        arrData.append(model)
                    }
                    
                    completion(arrData, true)
                }
                else
                {
                    completion(nil, false)
                }
            }
        }
        else
        {
            completion(nil, false)
        }
        
    }
}

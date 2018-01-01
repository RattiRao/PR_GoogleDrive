//
//  GoogleDriveListController.swift
//  DrAppraisal
//
//  Created by Rati on 29/09/17.
//  Copyright © 2017 Vikash Kumar Sahu. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

@objc protocol DriveListDelegate
{
    @objc optional func getData(fileName : String , data : Data) -> Void
}

class GoogleDriveListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblView: UITableView!
    var arrData : Array<driveModel> = []
    var delegate : DriveListDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getDriveList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //Mark Methods
    func getDriveList()
    {
        MBProgressHUD.showHUDMessage(message: "", PPview: self.view)
        Facade.shareInstance.loadDrive { (arrData, success) in
            
            MBProgressHUD.hideHUD()
            
            if success
            {
                self.arrData = arrData!
                self.tblView.reloadData()
            }
        }
    }
    
    //MARK Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = self.tblView.dequeueReusableCell(withIdentifier: "ID", for: indexPath)
        
        cell.textLabel?.text = self.arrData[indexPath.row].fileName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let query : GTLRQuery = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: self.arrData[indexPath.row].id)
        
        let driveService : GTLRDriveService = GTLRDriveService.init()
        
        MBProgressHUD.showHUDMessage(message: "", PPview: self.view)
        
        driveService.executeQuery(query) { (serviceTicket, fileData, error) in
            
            MBProgressHUD.hideHUD()
            
            if error == nil
            {
                let data : Data = (fileData as! GTLRDataObject).data
                
                self.delegate.getData!(fileName: self.arrData[indexPath.row].fileName, data: data)
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

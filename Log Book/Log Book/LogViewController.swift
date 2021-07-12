//
//  LogViewController.swift
//  Log Book
//
//  Created by Татьяна Тищенко  on 16.06.2021.
//

import Foundation
import UIKit
import MessageUI

class LogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var LogTable: UITableView!
    
    var geoDataArray : [GeoData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LogTable.reloadData()
        
    }
    
    @IBAction func SendLogButton(_ sender: Any) {
        
        let pdfPageFrame = LogTable.bounds
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else {
            print("fail UIGraphicsGetCurrentContext")
            return
        }
        LogTable.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        
        let path = NSTemporaryDirectory() + "pdftest_s.pdf"
        pdfData.write(toFile: path, atomically: true)
        print(path)
        
        if MFMailComposeViewController.canSendMail() {
           let mail = MFMailComposeViewController()
           //mail.setToRecipients(["tanya.tishchenko@gmail.com"])
           mail.setToRecipients(["ttishchenko.study@gmail.com"])
            //mail.setToRecipients(emailAddress)
           mail.setSubject("LogBook")
           mail.setMessageBody("Welcome to Tutorials Point!", isHTML: true)
           mail.mailComposeDelegate = self
           //add attachment
           if let data = NSData(contentsOfFile: path) {
                mail.addAttachmentData(data as Data, mimeType: "application/pdf" , fileName: "boatlog.pdf")
            // можно добавить дату и время в название
           }
           present(mail, animated: true)
           }
        else {
           print("Email cannot be sent")
        }
        
    }
    
    //ориентация экрана
//    override func viewWillAppear(_ animated: Bool) {
//      AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
//    }
//
//    override func viewWillDisappear(_ animated : Bool) {
//      super.viewWillDisappear(animated)
//      AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geoDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Log", for: indexPath) as! LogTableViewCell
        let georow : GeoData = geoDataArray[indexPath.row]
        
        cell1.DateLabel?.text = String(describing: georow.dt)
        cell1.CourseLabel?.text = String(georow.course)
        cell1.SpeedLabel?.text = String(georow.speed)
        cell1.WindLabel?.text = ""
        cell1.PosLabel?.text = String(georow.latitude) + ", " +  String(georow.longitude)
        
        return cell1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

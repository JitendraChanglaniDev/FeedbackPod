//
//  FeedbackVC.swift
//  FeedbackDemo
//
//  Created by Jitendra Changlani on 04/10/17.
//  Copyright © 2017 Jitendra Changlani. All rights reserved.
//

import UIKit
import ReachabilitySwift
import MBProgressHUD

public class FeedbackVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {



    //MARK:- Class variables

    var feedbackPlaceHolderText: String!
    var selectSourceText: String!
    var cameraText: String!
    var galleryText: String!

    private var SelectedImageIndex = 0
    private var imagePickerController: UIImagePickerController!

    private var arrayOfImagePath = [String]()
    private var myPopImageSlider = ImageSliderSwift()
    private let reachability: Reachability = Reachability()!
    var appName: String = ""
    var userName = ""
    var userFirstName = ""
    var userLastName = ""
    var submitButtonColor: UIColor = .blue
    var appID = "42"
    var appKey = "3f11a227-e31b-4bc6-beda-bd9e8a4257f5"

    private let sliderMarginColor = UIColor(red: 127.0 / 255.0, green: 127.0 / 255.0, blue: 127.0 / 255.0, alpha: 1.0)
    private let sliderBgColor = UIColor(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)
    private let urlString = "https://api.logcamp.net/LoggerRating"

    // place holder label for text view which will be used for feedback
    var placeholderLabel: UILabel!

    // MARK:- IBOutlets
    // feedback text view outlet
    @IBOutlet weak private var txtviewFeedback: UITextView!
    @IBOutlet weak private var lblHowHappyYouAre: UILabel!
    @IBOutlet weak private var lblFeedbackOrComment: UILabel!
    @IBOutlet weak private var lblPhotos: UILabel!
    @IBOutlet weak private var btnSubmit: UIButton!
    @IBOutlet weak private var viewRating: RatingControl!
    @IBOutlet weak private var scrollImg: UIScrollView!

    // MARK:- Life cycle methods
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.commanInit()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FeedbackVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK:- Initial setup methods
    /**
     - This method helps to setup child controller.
     - If we update the below constraints we can set the Feedback as a popup.
     */
    func setUpTheController(parentVC: UIViewController) {
        parentVC.addChildViewController(self)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        parentVC.view.addSubview(self.view)

        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                self.view.leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor, constant: 0),
                self.view.trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor, constant: 0),
                self.view.topAnchor.constraint(equalTo: parentVC.view.topAnchor, constant: 0),
                self.view.bottomAnchor.constraint(equalTo: parentVC.view.bottomAnchor, constant: 0)
            ])
        } else {
            // Fallback on earlier versions

        }
        self.didMove(toParentViewController: parentVC)
    }


    /**
     - This method will set all the default values for the view controller.
     - If localised values are not passed to view controller then it will set default for English.
     */
    func commanInit() {

        // Assign values to UI
        self.lblPhotos.text = self.getLocalizedString(key: "keyPhotos", value: "Photos")
        self.lblHowHappyYouAre.text = self.getLocalizedString(key: "keyHowInfoLabel", value: "How happy you are with this app ?")
        self.lblFeedbackOrComment.text = self.getLocalizedString(key: "keyFeedbackOrComment", value: "Your feedback/comment")
        self.feedbackPlaceHolderText = self.getLocalizedString(key: "keyPlaceHolder", value: "Write something here")
        self.cameraText = self.getLocalizedString(key: "keyCameraText", value: "Camera")

        self.btnSubmit.setTitle(self.getLocalizedString(key: "keySubmit", value: "Submit"), for: .normal)
        self.setThePlaceHolderForTextView(placeholderText: self.feedbackPlaceHolderText)
        self.btnSubmit.backgroundColor = submitButtonColor

        // Update variables
        self.appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String ?? ""

        self.updateImageScrollView()

    }

    /**
     - As there option to set the placeholder for textView so custom
       floating label is set for that.
     */
    func setThePlaceHolderForTextView(placeholderText: String) {
        self.txtviewFeedback.delegate = self
        self.placeholderLabel = UILabel()
        self.placeholderLabel.text = placeholderText
        self.placeholderLabel.font = UIFont.italicSystemFont(ofSize: (self.txtviewFeedback.font?.pointSize)!)
        self.placeholderLabel.sizeToFit()
        self.txtviewFeedback.addSubview(self.placeholderLabel)
        self.placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.txtviewFeedback.font?.pointSize)! / 2)
        self.placeholderLabel.textColor = UIColor.lightGray
        self.placeholderLabel.isHidden = !self.txtviewFeedback.text.isEmpty
    }

    /**
     - This method gets called as the controller is loaded.
     - It gets called from viewdidLoad()
     */
    func setUpImageScrollView() {
//        CLSNSLogv("Start %@ %@ ", getVaList([NSStringFromClass(object_getClass(self)), #function]))
        let ContaintView: [UIView] = self.scrollImg.subviews
        for xView in ContaintView {
            xView.removeFromSuperview()
        }

        // - Here we provide ability to user to preview the selected images.
        // - By clicking on image it can viewed.
        var xPostion: CGFloat = 0
        let imgWidth: CGFloat = (UIScreen.main.bounds.size.width / 3) - 25
        for iCounter in 0 ..< self.arrayOfImagePath.count {
            let imgView = UIImageView(frame: CGRect(x: xPostion, y: 0, width: imgWidth, height: imgWidth))
            let layer = imgView.layer
            layer.masksToBounds = true
            layer.cornerRadius = 4.0
            var DirectoryPath = self.getDocumentDirectoryFilePath()
            DirectoryPath = DirectoryPath + self.arrayOfImagePath[iCounter]
            imgView.image = UIImage(contentsOfFile: DirectoryPath)
            imgView.tag = iCounter
            let btnForImage = UIButton(frame: imgView.frame)
            btnForImage.addTarget(self, action: #selector(self.actionOnPreviewImageButton(_:)), for: .touchUpInside)
            btnForImage.tag = iCounter
            self.scrollImg.addSubview(imgView)
            self.scrollImg.addSubview(btnForImage)
            xPostion = xPostion + imgWidth + 15
        }

        //- we need to manage that if images added to scroll view are less than 3
        //- Then we need to allow user to add images upto 3 images.
        if self.arrayOfImagePath.count < 3 {
            print(self.scrollImg.frame.height)
            let imgView = UIImageView(frame: CGRect(x: xPostion, y: 0, width: imgWidth, height: imgWidth))
            imgView.image = UIImage(named: "img_addPhoto.png")
            imgView.tag = self.arrayOfImagePath.count
            let btnForImage = UIButton(frame: imgView.frame)
            btnForImage.addTarget(self, action: #selector(self.addImageButtonClicked(_:)), for: .touchUpInside)
            btnForImage.tag = self.arrayOfImagePath.count
            self.scrollImg.addSubview(imgView)
            self.scrollImg.addSubview(btnForImage)
        }
        self.initializePopImageSlider(self.arrayOfImagePath)
//        CLSNSLogv("End %@ %@ ", getVaList([NSStringFromClass(object_getClass(self)), #function]))
    }

    //- This is inital method to setup the scroll view.
    func updateImageScrollView() {
        self.setUpImageScrollView()
    }


    // MARK:- Text view delegate methods
    public func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    // MARK:- Helper methods
    /**
     - This method helps to apply localized data to the labels and buttons.
     - If there is no localization then English values will be displayed.
     */
    func getLocalizedString(key: String, value: String) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: Bundle.main, value: value, comment: "")
    }

    /**
     - This is generic method to display the alert.
     - It is used to display the alert with ok button only.
     */
    func displayAlertWithTitle(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: self.getLocalizedString(key: "keyOkButtonLabel", value: "OK"), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    /**
     - This method reads the local ip address of the device and returns the same.
     */
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    // This method returns the type of platform e.g :- X_86
    func platform() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let size = Int(_SYS_NAMELEN) // is 32, but posix AND its init is 256....
        
        let s = withUnsafeMutablePointer(to: &systemInfo.machine) {p in
            
            p.withMemoryRebound(to: CChar.self, capacity: size, {p2 in
                return String(cString: p2)
            })
            
        }
        return s
    }
    // - This method returns the model indentifier
    func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }

    /**
     - This method is to manage the source type selected.
     - It can be either camera or gallery.
     */
    func presentSouceType(_ SourceType: Int, Sender: UIButton) {
//        CLSNSLogv("Start %@ %@ SourceType = %d", getVaList([NSStringFromClass(object_getClass(self)), #function, SourceType]))
        print(SourceType)
        self.SelectedImageIndex = Sender.tag
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) && SourceType == 1 {
            self.presentUIImagePickerController(UIImagePickerControllerSourceType.camera)
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) && SourceType == 2 {
            self.presentUIImagePickerController(UIImagePickerControllerSourceType.photoLibrary)
        } else if SourceType != 0 {
            self.displayAlertWithTitle(title: self.appName, message: self.getLocalizedString(key: "keySourceNotAvailable", value: "Source type not available"))
        }
//        CLSNSLogv("End %@ %@ ", getVaList([NSStringFromClass(object_getClass(self)), #function]))
    }

    
    // MARK:- API Call methods
    /**
     - Send data to the log camp server.
     - This is multipart API call
     */
    func callMultipartRequestAPI(_ urlString: String, withImagePaths imagePaths: [String], andParameters parameters: [String: AnyObject], timeout: Int) {

        // get the default document Directory path
//        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        let documentsDir = paths[0]

        // create blank zip file
//        let zipPath = documentsDir.appending("/test333.zip")

//        let fileManagerr = FileManager.default
//        let successe = fileManagerr.fileExists(atPath: zipPath) as Bool

        // create the request string
        var requestString = ""
        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonRequest = self.parseData(jsonData: jsonData!)
            requestString = jsonRequest
        } catch let error as NSError {
            print(error)
        }
        
        let file = "logger" //this is the file. we will write to and read from it
        
        let text = requestString //just a text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                
                let zipFilePath = try Zip.quickZipFiles([fileURL], fileName: "archive") // Zip

                // now create NSDATA with boundry for images if added
                let compressed = try? Data.init(contentsOf: zipFilePath)
                debugPrint(compressed ?? "sdfsdfasdfdf")
                let boundry = "------12345"
                let contentType = String(format: "multipart/form-data; boundary=%@", boundry)
                
                
                if let url = URL(string: urlString) {
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
                    request.timeoutInterval = TimeInterval(60.0)
                    
                    var body = Data()
                    body.append(String(format: "--%@\r\n", boundry).data(using: .utf8)!)
                    body.append(String(format: "Content-Disposition: form-data; name=\"loggerRating\"; filename=\"%@\"\r\n\r\n", "logger").data(using: .utf8)!)
                    body.append(compressed!)
                    body.append(String(format: "\r\n").data(using: .utf8)!)
                    
                    
                    for imagePath in imagePaths {
                        let fileManagerr = FileManager.default
                        if fileManagerr.fileExists(atPath: imagePath) {
                            let image = UIImage(contentsOfFile: imagePath)
                            let imageData = UIImageJPEGRepresentation(image!, 1)
                            
                            body.append(String(format: "--%@\r\n", boundry).data(using: .utf8)!)
                            body.append(String(format: "Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", (imagePath as NSString).lastPathComponent).data(using: .utf8)!)
                            body.append(String(format: "Content-Type: image/jpeg\r\n\r\n").data(using: .utf8)!)
                            body.append(imageData!)
                            body.append(String(format: "\r\n").data(using: .utf8)!)
                            
                        }
                    }
                    
                    
                    body.append(String(format: "--%@--\r\n", boundry).data(using: .utf8)!)
                    request.httpBody = body
                    
                    
                    // Make an asynchronous call so as not to hold up other processes.
                    NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: { (response, dataObject, error) in
                        if let apiError = error {
                            debugPrint(apiError)
                        } else {
                            debugPrint(dataObject ?? "no data")
                            self.checkResponse(response: dataObject!)
                        }
                    })
                    
                }
            }
            catch {/* error handling here */
                debugPrint("In catch")
            }
        }

        
//        // insert data into the zip file which was blank
//        let zipdata = UFZipFile.init(fileName: zipPath, mode: ZipFileModeCreate)
//        let stream1 = zipdata?.writeInZip(withName: "logger", fileDate: Date.init(timeIntervalSinceNow: -86400.0), compressionLevel: ZipCompressionLevelDefault)
//        stream1?.write(requestString.data(using: .utf8))
//        stream1?.finishedWriting()
//        zipdata?.close()



    }

    func checkResponse(response: Data) {
        // a. We have to parse response to check if it is proper
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSDictionary
            // Response parse time
            debugPrint(jsonObject!)
            let responseDict = jsonObject?.value(forKey: "response")as? NSDictionary
            if responseDict?.value(forKey: "code") as? String == "200" {
                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: self.getLocalizedString(key: "keyThankYou", value: "Thank you"), message: self.getLocalizedString(key: "keyFeedbackSubmitted", value: "Your feedback submitted successfully"), preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "Ok", style: .default, handler: { (Action) in
                    self.viewRating.rating = 0
                    self.txtviewFeedback.textColor = UIColor.lightGray
                    //self.txtview_feedback.text = self.notesPlaceHolder
                    self.RemoveSaveImageFromDirectory()
                    self.arrayOfImagePath.removeAll()
                    self.updateImageScrollView()
                    _ = self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(OkAction)
                self.present(alert, animated: true, completion: nil)
            }

        }
        catch let JSONError as NSError {
            debugPrint(JSONError)
        }
    }

    func parseData(jsonData: Data) -> String {
        let str = String(data: jsonData, encoding: .utf8)
        return str!
    }


    //MARK:- ImagePicker delegate methods
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
//        CLSNSLogv("Start %@ %@ ", getVaList([NSStringFromClass(object_getClass(self)), #function]))
        let img: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        var imagePath = self.getDocumentDirectoryFilePath()
        if self.arrayOfImagePath.count > self.SelectedImageIndex {
            var existingImgPath = self.arrayOfImagePath[self.SelectedImageIndex]
            existingImgPath = "\(imagePath)\(existingImgPath)"
            if FileManager.default.fileExists(atPath: existingImgPath) {
                do {
                    try FileManager.default.removeItem(atPath: existingImgPath)
                } catch { }
            }
        }

        // - Store image with unique name
        let newImage = RBResizeImage(img, targetSize: CGSize(width: 640, height: 640))
        let imageName = "/Feedback_\(Date()).png"
        imagePath = imagePath + imageName
        let imageData = UIImagePNGRepresentation(newImage)
        if FileManager.default.createFile(atPath: imagePath, contents: imageData, attributes: nil) {
            if self.arrayOfImagePath.count > self.SelectedImageIndex {
                self.arrayOfImagePath.remove(at: self.SelectedImageIndex)
                self.arrayOfImagePath.insert(imageName, at: self.SelectedImageIndex)
            } else {
                self.arrayOfImagePath.insert(imageName, at: self.SelectedImageIndex)
            }
        }
        picker.dismiss(animated: true, completion: nil)
        self.updateImageScrollView()
//        CLSNSLogv("End %@ %@ ", getVaList([NSStringFromClass(object_getClass(self)), #function]))
    }

    // - Delegate method called when cancel button clicked.
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func presentUIImagePickerController(_ sourcetype: UIImagePickerControllerSourceType) {
        if self.imagePickerController == nil {
            self.imagePickerController = UIImagePickerController()
        }
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = sourcetype
        self.imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }

    //MARK:- Document Directory operations
    // - This method returns the path of document application directory
    func getDocumentDirectoryFilePath() -> String {
        let folderPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        print(folderPath)
        return (folderPath as String)
    }

    // - This method is used to delete the temprory images saved in document directory.
    func RemoveSaveImageFromDirectory() {
        for imagePath in self.arrayOfImagePath {
            let existingImgPath = "\(self.getDocumentDirectoryFilePath())\(imagePath)"
            if FileManager.default.fileExists(atPath: existingImgPath) {
                do {
                    try FileManager.default.removeItem(atPath: existingImgPath)
                } catch { }
            }
        }
    }


    //MARK:- Preview Image Set up
    // - This method is used to get the preview of image selected from scroll view

    func initializePopImageSlider(_ imagesArray: [String]) {
        let height = self.view.bounds.size.height - 200
        let width = self.view.bounds.size.width - 20

        self.myPopImageSlider = ImageSliderSwift.sharedInstance.initWithFrame(frame: CGRect(x: 0, y: 0, width: width, height: height), parentView: self.view)
        self.myPopImageSlider.setMarginColor(marginColor: self.sliderMarginColor)
        self.myPopImageSlider.setScrollViewBackgroundColor(bgColor: self.sliderBgColor)
        self.myPopImageSlider.addImagesToView(imagesArray: imagesArray as NSArray)
    }


    // MARK:- Action methods
    // - Here we will validate and send the data to the Logcamp
    @IBAction func actionOnSubmitButton(_ sender: UIButton) {

        //validate and send user feedback with rating on kahuna logcamp
        self.txtviewFeedback.resignFirstResponder()

        if self.viewRating.rating <= 0 && self.txtviewFeedback.text .characters.count <= 0 {
            // - Display alert if feedback data is missing.
            self.displayAlertWithTitle(title: self.getLocalizedString(key: "keyUserFeedback", value: "User Feedback"), message: self.getLocalizedString(key: "keyMessage", value: "Please rate us or write something in feedback"))
        } else {
            // - Check Internet and send data to the server.
            if reachability.isReachable {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud?.labelText = self.getLocalizedString(key: "keyProcessing", value: "Loading..")
                print("UserRating = \(self.viewRating.rating)")

                let DirectoryPath = self.getDocumentDirectoryFilePath()
                var ImageFullDirectoryPath = [String]()
                for path in self.arrayOfImagePath {
                    let fullPath = DirectoryPath + "\(path)"
                    ImageFullDirectoryPath.append(fullPath)
                }

                var appVersion: String = ""
                if ((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) != nil) {
                    appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
                }
                
                var timeZone: String {
                    return TimeZone.current.localizedName(for: TimeZone.current.isDaylightSavingTime() ?
                        .daylightSaving :
                        .standard,
                                                          locale: .current) ?? "" }
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let result = formatter.string(from: date)
                
                let summeryString = String(format: self.getLocalizedString(key: "keyAppFeedBack", value: "%@ App Feedback"), self.appName)
                let dictOfMetaData = [
                    "appId": self.appID,
                    "appKey": self.appKey,
                    "appVersion": appVersion,
                    "device": modelIdentifier(),
                    "deviceId": UIDevice.current.identifierForVendor!.uuidString,
                    "deviceModel": self.platform(),
                    "ipAddress": self.getWiFiAddress(),
                    "osVersion": UIDevice.current.systemVersion,
                    "package":  Bundle.main.bundleIdentifier!,
                    "platform": "iOS",
                    "timeZone": timeZone,
                    "versionCode": Bundle.main.infoDictionary?["CFBundleVersion"] as? String

                ]

                let dictOfUserInfo = [
                    "userId": self.userName,
                    "userName": self.userFirstName
                ]

                let dictOfApprating = [
                    "comment": self.txtviewFeedback.text,
                    "dateTime": result,
                    "rating": String(format: "%d", self.viewRating.rating),
                    "summary": summeryString,
                    "userInfo": dictOfUserInfo
                ] as [String: Any]

                let dictOfParams = [
                    "metaData": dictOfMetaData,
                    "appRating": dictOfApprating
                ]
                debugPrint(dictOfParams)
                self.callMultipartRequestAPI(self.urlString, withImagePaths: ImageFullDirectoryPath, andParameters: dictOfParams as [String: AnyObject], timeout: 100)
            } else {
                self.displayAlertWithTitle(title: self.getLocalizedString(key: "keyNetworkError", value: "Network Error"), message: self.getLocalizedString(key: "keyNoInternet", value: "Application requires network access either through WiFi or Mobile network."))
            }
        }
    }
    
    
    

    func actionOnPreviewImageButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: self.getLocalizedString(key: "keySelectSource", value: "Select Source"), message: "", preferredStyle: .actionSheet)
        let DeleteAction = UIAlertAction(title: self.getLocalizedString(key: "keyDelete", value: "Delete"), style: .destructive) { (Delete) in
            if self.arrayOfImagePath.count > sender.tag {
                let imageName = self.arrayOfImagePath[sender.tag]
                var imagePath = self.getDocumentDirectoryFilePath()
                imagePath = imagePath + imageName
                if FileManager.default.fileExists(atPath: imagePath) {
                    do {
                        try FileManager.default.removeItem(atPath: imagePath)
                    } catch { }
                }
                self.arrayOfImagePath.remove(at: sender.tag)
                self.updateImageScrollView()
            }
        }
        let PreViewAction = UIAlertAction(title: self.getLocalizedString(key: "keyPreview", value: "Preview"), style: .default) { (Preview) in
            if self.arrayOfImagePath.count > sender.tag {
                self.myPopImageSlider.setImageIndex(indexValue: sender.tag)
                self.myPopImageSlider.showView()
            }
        }
        let cameraAction = UIAlertAction(title: self.getLocalizedString(key: "keyCameraText", value: "Camera"), style: .default) { (Camera) in
            self.presentSouceType(1, Sender: sender)
        }
        let galleryAction = UIAlertAction(title: self.getLocalizedString(key: "keyGallery", value: "Gallery"), style: .default) { (Gallery) in
            self.presentSouceType(2, Sender: sender)
        }
        let cancelAction = UIAlertAction(title: self.getLocalizedString(key: "keyCancelButtonlabel", value: "Cancel"), style: .cancel, handler: nil)
        alertController.addAction(DeleteAction)
        alertController.addAction(PreViewAction)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        self.present(alertController, animated: true, completion: nil)
    }


    // - Method to select the image from gallery or camera
    func addImageButtonClicked(_ sender: UIButton) {
        let alertController = UIAlertController(title: self.getLocalizedString(key: "keySelectSource", value: "Select source"), message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: self.getLocalizedString(key: "keyCameraText", value: "Camera"), style: .default) { (Camera) in
            self.presentSouceType(1, Sender: sender)
        }
        let galleryAction = UIAlertAction(title: self.getLocalizedString(key: "keyGallery", value: "Gallery"), style: .default) { (Gallery) in
            self.presentSouceType(2, Sender: sender)
        }
        let cancelAction = UIAlertAction(title: self.getLocalizedString(key: "keyCancelButtonlabel", value: "Cancel"), style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

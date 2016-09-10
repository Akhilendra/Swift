//
//  ViewController.swift
//  Travelling
//
//  Created by Muskan on 8/6/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import UIKit
//import MapKit
import GoogleMaps
//import CoreLocation
import GooglePlaces
import TextFieldEffects
//import GooglePlacesAutocomplete

class ViewController: UIViewController , CLLocationManagerDelegate , GMSMapViewDelegate , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate , LocateOnTheMap , UITextFieldDelegate , GooglePlacesAutocompleteDelegate {

    //@IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var btn_sidebar: UIBarButtonItem!
    @IBOutlet weak var mapView: GMSMapView!

    //@IBOutlet weak var txtFromLocation: UITextField!
    //@IBOutlet weak var txtToLocation: UITextField!
    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient?
    
    var txtFieldBool: Bool!
    var txtFromLocation: MadokaTextField!
    var txtToLocation: MadokaTextField!
    var txtLocation: MadokaTextField!
    
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    
    let kCellHeight:CGFloat = 60.0
    var sampleTableView:UITableView!
    
    var markers = [GMSMarker]()
    
    let shareData = ShareData.sharedInstance
    var NumberofRows: Int!
    var display_nameArray = [String]()
    var companyArray = [String]()
    var minimumArray = [String]()
    var cost_per_distanceArray = [String]()
    var base_fareArray = [String]()
    var cancellation_feeArray = [String]()
    var cost_per_minuteArray = [String]()
    var surge_multiplierArray = [String]()
    var ride_estimate_minArray = [String]()
    var ride_estimate_maxArray = [String]()
    var etaArray = [String]()
    
    let autoshareData = AutoShareData.sharedInstance
    var autoNumberofRows: Int!
    var autodisplay_nameArray = [String]()
    var autocompanyArray = [String]()
    var autominimumArray = [String]()
    var autocost_per_distanceArray = [String]()
    var autobase_fareArray = [String]()
    var autocancellation_feeArray = [String]()
    var autocost_per_minuteArray = [String]()
    var autosurge_multiplierArray = [String]()
    var autoride_estimate_minArray = [String]()
    var autoride_estimate_maxArray = [String]()
    var autoetaArray = [String]()

    
    // initiate menu
    var foldMenu = MenuFoldViewController(nibName: "MenuFoldViewController", bundle: nil)
    
    var AutofoldMenu = MenuFoldViewController(nibName: "AutoMenuFoldViewController", bundle: nil)
    
    
    var isOpenMenu: Bool = false
    var cabImages = [1:"auto-ride",2:"bike-ride",3:"bike-rent-red",4:"cab-ride",5:"car-pool-1",6:"car-rent",7:"day-hyre",8:"driver",9:"luxury-red",10:"oustation-red",11:"outstation",12:"rent-red",13:"self-drive",14:"shuttle"]
    var cabImagesClicked = [1:"auto-red",2:"bike-red",3:"bike-rent-white",4:"cab-ride-red",5:"car-pool_red",6:"car-rent_red",7:"day-hyre-red",8:"driver-red",9:"luxury-white",10:"outstation-white",11:"outstation-red",12:"rent-white",13:"self-drive_red",14:"shuttle-red"]
    
    var cabOptions = ["","CAB","AUTO","BIKE TAXI","CAB POOL","RENT A CAR","RIDE SHARE","DAY HIRE","DRIVER","SHUTTLE"]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.sharedClient()
        getCurrentPlace()
        
        btn_sidebar.target = self.revealViewController()
        //btn_sidebar.action = Selector("revealToggle:")
        btn_sidebar.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        if (CLLocationManager.locationServicesEnabled())
        {
            //locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            //mapView.showsUserLocation = true
        }
        
        //data_request_sendContacts()
        
        
        //bottom table view
        self.sampleTableView = UITableView(frame:CGRectMake(0,self.view.frame.size.height-95,self.view.frame.size.width, 95), style:.Grouped)
        sampleTableView.tableFooterView = UIView()
        sampleTableView.backgroundColor = UIColor.grayColor()
        sampleTableView.dataSource = self
        sampleTableView.delegate = self
        sampleTableView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        sampleTableView.layer.zPosition = 10
        self.view.addSubview(sampleTableView)
        //bottom table view end
        
        //add search textField
        let textFieldFrame = CGRectMake(20, 80, 335, 40)
        txtFromLocation = MadokaTextField(frame: textFieldFrame)
        txtFromLocation.textColor = UIColor.blackColor()
        txtFromLocation.placeholder = "From Location"
        txtFromLocation.placeholderColor = UIColor.lightGrayColor()
        txtFromLocation.borderColor = .redColor()
        txtFromLocation.font = UIFont.systemFontOfSize(14)
        //txtFromLocation.textColor = UIColor.whiteColor()
        //txtFromLocation.isFirstResponder()
        txtFromLocation.becomeFirstResponder()
        self.view.addSubview(txtFromLocation)
        
        let textFieldFrame2 = CGRectMake(20, 120, 335, 40)
        txtToLocation = MadokaTextField(frame: textFieldFrame2)
        txtToLocation.textColor = UIColor.blackColor()
        txtToLocation.placeholder = "To Location"
        txtToLocation.placeholderColor = UIColor.lightGrayColor()
        txtToLocation.borderColor = .redColor()
        txtToLocation.font = UIFont.systemFontOfSize(14)
        //txtToLocation.textColor = UIColor.whiteColor()
        self.view.addSubview(txtToLocation)
        
        txtFromLocation.addTarget(self, action: #selector(ViewController.searchWithAddress(_:)), forControlEvents: UIControlEvents.TouchDown)
        txtToLocation.addTarget(self, action: #selector(ViewController.searchWithAddress(_:)), forControlEvents: UIControlEvents.TouchDown)
        //txtLocation.addTarget(self, action: #selector(ViewController.textFieldEditing(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        //initFoldMenu() // init the fold menu
        if locationManager.location != nil {
            data_request_getProducts("cab")
            data_request_getProductsAuto("auto")
//            data_request_getProducts("baxi")
            
            
        } else {
            let alert = UIAlertController(title: "No Internet Access", message: "Please make sure internet is available", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {
                action -> () in
                //Perfrom Actions
                print("Cancel")
            }
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }

        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        //google analytics start
        
//        let name = "mapView"
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: name)
//        
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])

        //google analytics end
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        
    }
    
//<<<<<<< HEAD
//=======

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
//>>>>>>> b0e4dc3d48f06cbe107d8f2a31945e5f3141a280
    //txtFromLocation textfield action
    func searchWithAddress(textField: UITextField) {
//        let searchController = UISearchController(searchResultsController: searchResultController)
//        searchController.searchBar.delegate = self
//        self.presentViewController(searchController, animated: true, completion: nil)
//        txtFieldBool = true
        let gpaViewController = GooglePlacesAutocomplete(
            apiKey: "AIzaSyBII0JjlDs-AZ7nQVuHfOBKuhNr3gnlQvs",
            //placeType: .Address
            placeType: .All
        )
        gpaViewController.placeDelegate = self // Conforms to GooglePlacesAutocompleteDelegate
        presentViewController(gpaViewController, animated: false, completion: nil)
        
        if textField == txtFromLocation {
            txtFieldBool = true
        } else {
            txtFieldBool = false
        }
    }
    
    //txtFromLocation textfield action
//    func searchToAddress(textField: UITextField) {
//        let searchController = UISearchController(searchResultsController: searchResultController)
//        searchController.searchBar.delegate = self
//        self.presentViewController(searchController, animated: true, completion: nil)
//        txtFieldBool = false
//    }
    
//    func addSearchView(textField: UITextField) {
////        let myFrame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
////        let baseView : UIView = UIView(frame: myFrame)
////        baseView.backgroundColor = UIColor.whiteColor()
////        self.view.addSubview(baseView)
//        
//        //add search textField
//        let textFieldFrame = CGRectMake(20, 80, 335, 40)
//        txtLocation = MadokaTextField(frame: textFieldFrame)
//        txtLocation.textColor = UIColor.blackColor()
//        txtLocation.placeholder = "Enter Location"
//        txtLocation.placeholderColor = UIColor.lightGrayColor()
//        txtLocation.borderColor = .redColor()
//        //txtLocation.isFirstResponder()
//        txtLocation.becomeFirstResponder()
//        //baseView.addSubview(txtLocation)
//        self.view.addSubview(txtLocation)
//        
//        txtLocation.addTarget(self, action: #selector(ViewController.textFieldEditing(_:)), forControlEvents: UIControlEvents.EditingChanged)
//        
//        let searchController = UISearchController(searchResultsController: searchResultController)
//        searchController.searchBar.delegate = self
//        self.presentViewController(searchController, animated: true, completion: nil)
//        txtFieldBool = true
//        
//        
//    }
    
    func textFieldEditing(textField: UITextField) {
        //if textField == txtLocation {
            let placeClient = GMSPlacesClient()
            placeClient.autocompleteQuery(textField.text!, bounds: nil, filter: nil) { (results, error: NSError?) -> Void in
                
                self.resultsArray.removeAll()
                if results == nil {
                    return
                }
                
                for result in results! {
                    if let result = result as? GMSAutocompletePrediction {
                        self.resultsArray.append(result.attributedFullText.string)
                    }
                }
                
                self.searchResultController.reloadDataWithArray(self.resultsArray)
                
            }

        //}
    }
    
    //googlePlacesAutocomplete
    func placeSelected(place: Place) {
        print(place.description)
        var title: String!
        var lat: Double!
        var lon: Double!
        place.getDetails { details in
            print(details)
            lat = details.latitude
            lon = details.longitude
            title = details.name
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 10)
            self.mapView.camera = camera
            
            marker.title = "Address: \(title)"
            //self.mapView.clear()
            if self.txtFieldBool == true {
                for pin: GMSMarker in self.markers {
                    if pin.userData as! String == "from" {
                        pin.map = nil
                    }
                }
                marker.icon = UIImage(named: "navigation-red_50")
                marker.userData = "from"
                self.markers.append(marker)
                self.txtFromLocation.text = marker.title
            } else {
                for pin: GMSMarker in self.markers {
                    if pin.userData as! String == "to" {
                        pin.map = nil
                    }
                }
                //marker.map = nil
                marker.icon = UIImage(named: "navigation-green_50")
                marker.userData = "to"
                self.markers.append(marker)
                self.txtToLocation.text = marker.title
            }
            marker.map = self.mapView
            
            //save in nsuserdefults
            //let array = ["horse", "cow", "camel"]
            
            let defaults = NSUserDefaults.standardUserDefaults()
            var placesTitleArray = defaults.objectForKey(TravellingConstants.NSUserDefaults.placeTitleArray) as? [String] ?? [String]()
            var placesLatArray = defaults.objectForKey(TravellingConstants.NSUserDefaults.placeLatArray) as? [Double] ?? [Double]()
            var placesLonArray = defaults.objectForKey(TravellingConstants.NSUserDefaults.placeLonArray) as? [Double] ?? [Double]()
            placesTitleArray.append(title)
            placesLatArray.append(lat)
            placesLonArray.append(lon)
            defaults.setObject(placesTitleArray, forKey: TravellingConstants.NSUserDefaults.placeTitleArray)
            defaults.setObject(placesLatArray, forKey: TravellingConstants.NSUserDefaults.placeLatArray)
            defaults.setObject(placesLonArray, forKey: TravellingConstants.NSUserDefaults.placeLonArray)
            
            //print(placesTitleArray)
            //save in nsuserdefults end
        } 
    }
    
    func historyPlaceSelected(title: String , lat: Double , lon: Double) {
        print("historyPlaceselected called.")
        let position = CLLocationCoordinate2DMake(lat, lon)
        let marker = GMSMarker(position: position)
        
        let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 10)
        self.mapView.camera = camera
        
        marker.title = "Address: \(title)"
        //self.mapView.clear()
        if self.txtFieldBool == true {
            for pin: GMSMarker in self.markers {
                if pin.userData as! String == "from" {
                    pin.map = nil
                }
            }
            marker.icon = UIImage(named: "navigation-red_50")
            marker.userData = "from"
            self.markers.append(marker)
            self.txtFromLocation.text = marker.title
        } else {
            for pin: GMSMarker in self.markers {
                if pin.userData as! String == "to" {
                    pin.map = nil
                }
            }
            //marker.map = nil
            marker.icon = UIImage(named: "navigation-green_50")
            marker.userData = "to"
            self.markers.append(marker)
            self.txtToLocation.text = marker.title
        }
        marker.map = self.mapView
    }


    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
//        var storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var controller = storyboard.instantiateViewControllerWithIdentifier("mainPage") as! ViewController
//        controller.xyz = "ABC"
//        self.presentViewController(controller, animated: true, completion: nil)
    } //googlePlacesAutocomplete end
    
    //Locate map with longitude and latiude after search location on UISearchBar
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 10)
            self.mapView.camera = camera
            
            marker.title = "Address: \(title)"
            //self.mapView.clear()
            if self.txtFieldBool == true {
                for pin: GMSMarker in self.markers {
                    if pin.userData as! String == "from" {
                        pin.map = nil
                    }
                }
                marker.icon = UIImage(named: "navigation-red_50")
                marker.userData = "from"
                self.markers.append(marker)
                self.txtFromLocation.text = marker.title
            } else {
                for pin: GMSMarker in self.markers {
                    if pin.userData as! String == "to" {
                        pin.map = nil
                    }
                }
                //marker.map = nil
                marker.icon = UIImage(named: "navigation-green_50")
                marker.userData = "to"
                self.markers.append(marker)
                self.txtToLocation.text = marker.title
            }
            marker.map = self.mapView
        }
    }
    
    /**
     Searchbar when text change
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error: NSError?) -> Void in
            
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            
            for result in results! {
                if let result = result as? GMSAutocompletePrediction {
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            
            self.searchResultController.reloadDataWithArray(self.resultsArray)
            
        }
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation:CLLocation = locations[0] as CLLocation
//        
//        manager.stopUpdatingLocation()
//        
//        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
//        //let span = MKCoordinateSpanMake(0.06,0.06)
//        //let region = MKCoordinateRegion(center: coordinations, span: span)
//        
//        //mapView.setRegion(region, animated: true)
//        
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        //lat = locValue.latitude
//        //long = locValue.longitude
//        print("===========================================")
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        
//    }
    
    // MARK: GMSMapViewDelegate
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    // Google places start
    func getCurrentPlace() {
        print("Getting current place from google....")
        placesClient?.currentPlaceWithCallback({
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            //self.nameLabel.text = "No current place"
            self.txtFromLocation.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    print("place name \(place.name)")
                    print(place.formattedAddress!.componentsSeparatedByString(", ").joinWithSeparator("\n"))
                    //self.nameLabel.text = place.name
                    self.txtFromLocation.text = place.formattedAddress!.componentsSeparatedByString(", ")
                        .joinWithSeparator("\n")
                }
            }
        })
    }  //google places end
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.sampleTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        tableView.tableHeaderView = nil
        //tableView.contentInset = UIEdgeInsetsMake(-1.0, 0.0, 0.0, 0.0)
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //tableView.sectionHeaderHeight = 0
        tableView.backgroundColor = UIColor.clearColor()
        //tableView.backgroundColor = UIColor.grayColor()
        tableView.scrollEnabled = false
        //tableView.tableHeaderView = nil
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return kCellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellIdentifierPortrait = "CellPortrait";
        let CellIdentifierLandscape = "CellLandscape";
        let indentifier = self.view.frame.width > self.view.frame.height ? CellIdentifierLandscape : CellIdentifierPortrait
        var cell = tableView.dequeueReusableCellWithIdentifier(indentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: indentifier)
            cell?.selectionStyle = .None
            //cell?.backgroundColor = UIColor.redColor()
            cell?.backgroundColor = UIColor(red: 239/255, green: 64/255, blue: 42/255, alpha: 1.0)
            let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRectMake(0, 0, tableView.frame.size.width, kCellHeight))
            if indexPath.row == 0{
                horizontalScrollView.miniAppearPxOfLastItem = 6
                horizontalScrollView.uniformItemSize = CGSizeMake(45, 55)
                //this must be called after changing any size or margin property of this class to get acurrate margin
                horizontalScrollView.setItemsMarginOnce()
                for i in 1...9{
                    let myView = UIView(frame: CGRectZero)
                    myView.backgroundColor = UIColor.clearColor()
                    
                    let btnFrame = CGRectMake(0, 0, 45, 45)
                    let button = UIButton(frame: btnFrame)
                    button.backgroundColor = UIColor.clearColor()
                    button.tag = i
                    let image = cabImages[i]
                    button.setBackgroundImage(UIImage(named: image!), forState: UIControlState.Normal)
                    if button.tag == 1 {
                    button.addTarget(self, action: #selector(openMenu), forControlEvents: UIControlEvents.TouchUpInside)
                    } else if button.tag == 2 {
                        button.addTarget(self, action: #selector(AutoopenMenu), forControlEvents: UIControlEvents.TouchUpInside)
                    }
                    
                    myView.addSubview(button)
                    
                    let labelFrame = CGRectMake(0, 46, 45, 10)
                    let label = UILabel(frame: labelFrame)
                    label.text = cabOptions[i]
                    label.textColor = UIColor.whiteColor()
                    label.font = label.font.fontWithSize(7)
                    label.textAlignment = NSTextAlignment.Center
                    label.backgroundColor = UIColor.clearColor()
                    //horizontalScrollView.addItem(button)
                    //horizontalScrollView.addItem(label)
                    myView.addSubview(label)
                    horizontalScrollView.addItem(myView)
                }
            }
            cell?.contentView.addSubview(horizontalScrollView)
            horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: kCellHeight))
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: cell!.contentView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        }
        return cell!
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            if status == .AuthorizedWhenInUse {
                locationManager.startUpdatingLocation()
                mapView.myLocationEnabled = true
                mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("updating the location of user=====================")
            //mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 10)
            self.mapView.camera = camera
            self.mapView.settings.myLocationButton = true
            
            marker.title = "Address: \(title)"
            marker.icon = UIImage(named: "navigation-red_50")
            marker.appearAnimation = kGMSMarkerAnimationPop
            self.txtFromLocation.text = marker.title
            
            marker.map = self.mapView
            //self.myMarkers.append(marker)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let labelHeight = self.txtFromLocation.intrinsicContentSize().height
        self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0,bottom: labelHeight, right: 0)
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                //self.addressLabel.unlock()
                let lines = address.lines! as [String]
                self.txtFromLocation.text = lines.joinWithSeparator("\n")
                UIView.animateWithDuration(0.25) {
                    //self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
//    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
//        addressLabel.lock()
//    }

//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//        let location = locations.last! as CLLocation
//        
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        
//        self.mapView.setRegion(region, animated: true)
//    }
    
//    @IBAction func btnLogoutAction(sender: AnyObject) {
//        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginVC") as UIViewController
//        self.presentViewController(viewController, animated: true, completion: nil)
//    }
    
//    @IBAction func openMenu(sender: AnyObject) {
//        initMenuAction()
//    }
    
    func openMenu(sender: UIButton) {
        
        if display_nameArray.count != 0 {
            initFoldMenu()
            initMenuAction()
    }

  
        
        for i in 1...8{
            var myArray = [UIButton]()
            let myButton = self.view.viewWithTag(i) as! UIButton
            myArray.append(myButton)
            for item in myArray {
                if item.tag != sender.tag {
                    let image = cabImages[i]
                    item.setBackgroundImage(UIImage(named: image!), forState: UIControlState.Normal)
                    
                }
                
            }
        }
        if isOpenMenu == true {
            let image = cabImagesClicked[sender.tag]
            sender.setBackgroundImage(UIImage(named: image!), forState: UIControlState.Normal)
        } else {
            let image = cabImages[sender.tag]
            sender.setBackgroundImage(UIImage(named: image!), forState: UIControlState.Normal)
        }
        
        //initMenuAction()
    }
    
    func initFoldMenu() {
        
        foldMenu.view.frame = CGRectMake(
            0, // x position menu
            self.view.frame.size.height, // y position menu
            self.view.frame.size.width, // size width menu
            self.view.frame.size.height / 2 // height of menu
        )
        
        foldMenu.view.tag = 100 // optional
        self.view.addSubview(foldMenu.view) // add menu to this view
        
    }
    
    func initMenuAction() {
        if isOpenMenu == false { // its mean menu is hide
            
            UIView.animateWithDuration(0.5,delay: 0.0,options: .TransitionNone,animations: { () -> Void in
                    self.foldMenu.view.frame = CGRectMake(
                        0, // x position
                        self.view.frame.size.height / 2 - 60, // y position
                        self.view.frame.size.width, // width menu
                        self.view.frame.size.height / 2 + 20 // height menu
                    )
                    
                }, completion: { (finished: Bool) -> Void in
            })
            
            // set is open menu to true
            isOpenMenu = true
            
        } // hide menu after show
        else {
            UIView.animateWithDuration(
                0.5,delay: 0.0,options: .TransitionNone,animations: { () -> Void in
                    self.foldMenu.view.frame = CGRectMake(
                        0, // x position
                        self.view.frame.size.height, // y position
                        self.view.frame.size.width, // width menu
                        self.view.frame.size.height / 2 // height menu
                    )
                    
                }, completion: { (finished: Bool) -> Void in
            })
            // set isopen menu to false
            isOpenMenu = false
        }
    }
    
    func AutoopenMenu(sender: UIButton) {
        
        //        if display_nameArray.count != 0 {
        initAutoFoldMenu()
        initAutoMenuAction()
        //    }
        
        
        
        for i in 1...8{
            var myArray = [UIButton]()
            let myButton = self.view.viewWithTag(i) as! UIButton
            myArray.append(myButton)
            for item in myArray {
                if item.tag != sender.tag {
                    let image = cabImages[i]
                    item.setBackgroundImage(UIImage(named: image!), forState: UIControlState.Normal)
                    
                }
                
            }
        }
        if isOpenMenu == true {
            let image = cabImagesClicked[sender.tag]
            sender.setBackgroundImage(UIImage(named: image!), forState: UIControlState.Normal)
        } else {
            let image = cabImages[sender.tag]
            sender.setBackgroundImage(UIImage(named: image!), forState: UIControlState.Normal)
        }
        
        //initMenuAction()
    }
    
    
    func initAutoFoldMenu() {
        
        AutofoldMenu.view.frame = CGRectMake(
            0, // x position menu
            self.view.frame.size.height, // y position menu
            self.view.frame.size.width, // size width menu
            self.view.frame.size.height / 2 // height of menu
        )
        
        AutofoldMenu.view.tag = 100 // optional
        self.view.addSubview(foldMenu.view) // add menu to this view
        
    }
    
    func initAutoMenuAction() {
        if isOpenMenu == false { // its mean menu is hide
            
            UIView.animateWithDuration(0.5,delay: 0.0,options: .TransitionNone,animations: { () -> Void in
                self.AutofoldMenu.view.frame = CGRectMake(
                    0, // x position
                    self.view.frame.size.height / 2 - 60, // y position
                    self.view.frame.size.width, // width menu
                    self.view.frame.size.height / 2 + 20 // height menu
                )
                
                }, completion: { (finished: Bool) -> Void in
            })
            
            // set is open menu to true
            isOpenMenu = true
            
        } // hide menu after show
        else {
            UIView.animateWithDuration(
                0.5,delay: 0.0,options: .TransitionNone,animations: { () -> Void in
                    self.AutofoldMenu.view.frame = CGRectMake(
                        0, // x position
                        self.view.frame.size.height, // y position
                        self.view.frame.size.width, // width menu
                        self.view.frame.size.height / 2 // height menu
                    )
                    
                }, completion: { (finished: Bool) -> Void in
            })
            // set isopen menu to false
            isOpenMenu = false
        }
    }

    
    
    
    
    
    func data_request_sendContacts() {
        let url:NSURL = NSURL(string:TravellingConstants.urls.contact)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        
        //let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        //let paramString = "name=\(txtFirstName.text!)&email=\(txtEmail.text!)&mobile=\(txtMobile.text!)&password=\(txtPassword.text!)&did=sfmhfmsm&onesignal_id=2&fbid=dgdm"
        //print(paramString)
        
        //Params: contact,customer_id. Contacts are to be sent in form of a JSON Array. Each JSON Object of the array must have cname,cmobile,cemail values.
        //let contacts = [{"cname" : "rahul","cemail" : "null","cmobile" : "null"},{"cname" : "raju","cemail" : "work.raju22@gmail.com","cmobile" : "+917746991697"}]
        let paramString = "customer_id=5783e1e807f3fb49fa000028&contact=hdgh"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error in sending contacts \(error?.localizedDescription)")
                return
            }
            
            if let HTTPResponse = response as? NSHTTPURLResponse {
                let statusCode = HTTPResponse.statusCode
                print("send contacts status code \(statusCode)")
                //self.activityIndicator.stopAnimating()
                
                if statusCode == 200 {
                    let readableJSON = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    print(readableJSON)
                    
                    if readableJSON["error"] == true {
                        let errorMsg = readableJSON["error_msg"].string as String! ?? String("Something went wrong.Please try again.")
                        print("Error occurred \(errorMsg)")
                        dispatch_async(dispatch_get_main_queue(), {
                            //self.activityIndicator.stopAnimating()
                            //show alert message
                            //self.showAlert("Something went wrong.Please try again.")
                            self.showAlert(errorMsg)
                            return
                        })
                    } else {
                        let otp = readableJSON["otp"].string as String!
                        print(readableJSON["otp"].string as String!)
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setValue(otp, forKey: "otp")
                        defaults.synchronize()
                        
                        if error != true {
                            dispatch_async(dispatch_get_main_queue(), {
                                //self.activityIndicator.stopAnimating()
                                //self.performSegueWithIdentifier("showOtpVerify", sender: self)
                                return
                            })
                        }
                    }
                }//end of for loop
            }
        }
        task.resume()
    }
    
    
    func data_request_getProducts(category:String) {
        let url:NSURL = NSURL(string:TravellingConstants.urls.products + "/\(category)/products")!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        
        //        Params: lat,long,cat (cab / auto)
        let paramString = "lat=\(locationManager.location!.coordinate.latitude)&long=\(locationManager.location!.coordinate.longitude)"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error in getting products \(error?.localizedDescription)")
                return
            }
            
            if let HTTPResponse = response as? NSHTTPURLResponse {
                let statusCode = HTTPResponse.statusCode
                print("products status code \(statusCode)")
                //self.activityIndicator.stopAnimating()
                
                if statusCode == 200 {
                    let readableJSON = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    self.NumberofRows = readableJSON[].count
                    print("num of rows \(self.NumberofRows)")
                    print(readableJSON)
                    
                    if readableJSON["error"] == true {
                        let errorMsg = readableJSON["error_msg"].string as String! ?? String("Something went wrong.Please try again.")
                        print("Error occurred \(errorMsg)")
                        dispatch_async(dispatch_get_main_queue(), {
                            //self.activityIndicator.stopAnimating()
                            //show alert message
                            //self.showAlert("Something went wrong.Please try again.")
                            self.showAlert(errorMsg)
                            return
                        })
                        
                    } else {
                        let numRows = self.NumberofRows - 1
                        for i in 0...numRows {
                            let display_name = readableJSON[i]["display_name"].string as String! ?? String("NA")
                            let company = readableJSON[i]["company"].string as String! ?? String("NA")
                            let minimum = readableJSON[i]["minimum"].string as String! ?? String("NA")
                            let cost_per_distance = String(readableJSON[i]["cost_per_distance"]) as String! ?? String("NA")
                            let base_fare = String(readableJSON[i]["base_fare"]) as String! ?? String("NA")
                            let cancellation_fee = readableJSON[i]["cancellation_fee"].string as String! ?? String("NA")
                            let cost_per_minute = String(readableJSON[i]["cost_per_minute"]) as String! ?? String("NA")
                            let surge_multiplier = readableJSON[i]["surge_multiplier"].string as String! ?? String("NA")
                            let ride_estimate_min = readableJSON[i]["ride_estimate_min"].string as String! ?? String("NA")
                            let ride_estimate_max = readableJSON[i]["ride_estimate_max"].string as String! ?? String("NA")
                            //let eta = readableJSON[i]["eta"].string as String! ?? String("NA")
                            let eta = String(readableJSON[i]["eta"]) as String! ?? String("NA")
                            
                            if display_name != "NA" {
                                self.display_nameArray.append(display_name)
                            }
                            if company != "" {
                                self.companyArray.append(company)
                            }
                            self.minimumArray.append(minimum)
                            if cost_per_minute != "null" {
                                self.cost_per_distanceArray.append(cost_per_distance)}
                            if base_fare != "null" {
                                self.base_fareArray.append("\(base_fare)")
                            }
                            self.cancellation_feeArray.append(cancellation_fee)
                            if cost_per_minute != "NA" {
                                self.cost_per_minuteArray.append(cost_per_minute)
                            }
                            self.surge_multiplierArray.append(surge_multiplier)
                            self.ride_estimate_minArray.append(ride_estimate_min)
                            self.ride_estimate_maxArray.append(ride_estimate_max)
                            if eta != "null" {
                                //Converting to minutes from seconds only for uber
                                if company == "uber"{
                                    let etaMin = Int(eta)! / 60
                                    
                                    self.etaArray.append("\(etaMin)")
                                }
                                else  {
                                    self.etaArray.append(eta)
                                }
                            }
                            //print(readableJSON[0]["display_name"].string as String!)
                            //                        let defaults = NSUserDefaults.standardUserDefaults()
                            //                        defaults.setValue(otp, forKey: "otp")
                            //                        defaults.synchronize()
                        }
                        
                        //print("display name array: \(self.display_nameArray) ETA Array: \(self.etaArray)")
                        
                        if error != true {
                            dispatch_async(dispatch_get_main_queue(), {
                                //self.activityIndicator.stopAnimating()
                                //self.performSegueWithIdentifier("showOtpVerify", sender: self)
                                
                                self.shareData.display_nameArray = self.display_nameArray
                                self.shareData.companyArray = self.companyArray
                                self.shareData.minimumArray = self.minimumArray
                                self.shareData.cost_per_distanceArray = self.cost_per_distanceArray
                                self.shareData.base_fareArray = self.base_fareArray
                                self.shareData.cancellation_feeArray = self.cancellation_feeArray
                                self.shareData.cost_per_minuteArray = self.cost_per_minuteArray
                                self.shareData.surge_multiplierArray = self.surge_multiplierArray
                                self.shareData.ride_estimate_minArray = self.ride_estimate_minArray
                                self.shareData.ride_estimate_maxArray = self.ride_estimate_maxArray
                                self.shareData.etaArray = self.etaArray
                                
                                return
                            })
                        }
                    }
                }//end of for loop
            }
        }
        task.resume()
    }
    
    func data_request_getProductsAuto(category:String) {
        let url:NSURL = NSURL(string:TravellingConstants.urls.products + "/\(category)/products")!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        
        //        Params: lat,long,cat (cab / auto)
        let paramString = "lat=\(locationManager.location!.coordinate.latitude)&long=\(locationManager.location!.coordinate.longitude)"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error in getting products \(error?.localizedDescription)")
                return
            }
            
            if let HTTPResponse = response as? NSHTTPURLResponse {
                let statusCode = HTTPResponse.statusCode
                print("products status code \(statusCode)")
                //self.activityIndicator.stopAnimating()
                
                if statusCode == 200 {
                    let readableJSON = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    self.NumberofRows = readableJSON[].count
                    print("num of rows \(self.NumberofRows)")
                    print(readableJSON)
                    
                    if readableJSON["error"] == true {
                        let errorMsg = readableJSON["error_msg"].string as String! ?? String("Something went wrong.Please try again.")
                        print("Error occurred \(errorMsg)")
                        dispatch_async(dispatch_get_main_queue(), {
                            //self.activityIndicator.stopAnimating()
                            //show alert message
                            //self.showAlert("Something went wrong.Please try again.")
                            self.showAlert(errorMsg)
                            return
                        })
                        
                    } else {
                        let numRows = self.NumberofRows - 1
                        for i in 0...numRows {
                            let display_name = readableJSON[i]["display_name"].string as String! ?? String("NA")
                            let company = readableJSON[i]["company"].string as String! ?? String("NA")
                            let minimum = readableJSON[i]["minimum"].string as String! ?? String("NA")
                            let cost_per_distance = String(readableJSON[i]["cost_per_distance"]) as String! ?? String("NA")
                            let base_fare = String(readableJSON[i]["base_fare"]) as String! ?? String("NA")
                            let cancellation_fee = readableJSON[i]["cancellation_fee"].string as String! ?? String("NA")
                            let cost_per_minute = String(readableJSON[i]["cost_per_minute"]) as String! ?? String("NA")
                            let surge_multiplier = readableJSON[i]["surge_multiplier"].string as String! ?? String("NA")
                            let ride_estimate_min = readableJSON[i]["ride_estimate_min"].string as String! ?? String("NA")
                            let ride_estimate_max = readableJSON[i]["ride_estimate_max"].string as String! ?? String("NA")
                            //let eta = readableJSON[i]["eta"].string as String! ?? String("NA")
                            let eta = String(readableJSON[i]["eta"]) as String! ?? String("NA")
                            
                            if display_name != "NA" {
                                self.autodisplay_nameArray.append(display_name)
                            }
                            if company != "" {
                                self.autocompanyArray.append(company)
                            }
                            self.autominimumArray.append(minimum)
                            if cost_per_minute != "null" {
                                self.autocost_per_distanceArray.append(cost_per_distance)}
                            if base_fare != "null" {
                                self.autobase_fareArray.append("\(base_fare)")
                            }
                            self.autocancellation_feeArray.append(cancellation_fee)
                            if cost_per_minute != "NA" {
                                self.autocost_per_minuteArray.append(cost_per_minute)
                            }
                            self.autosurge_multiplierArray.append(surge_multiplier)
                            self.autoride_estimate_minArray.append(ride_estimate_min)
                            self.autoride_estimate_maxArray.append(ride_estimate_max)
                            if eta != "null" {
                                //Converting to minutes from seconds only for uber
                                if company == "uber"{
                                    let etaMin = Int(eta)! / 60
                                    
                                    self.autoetaArray.append("\(etaMin)")
                                }
                                else  {
                                    self.autoetaArray.append(eta)
                                }
                            }
                            //print(readableJSON[0]["display_name"].string as String!)
                            //                        let defaults = NSUserDefaults.standardUserDefaults()
                            //                        defaults.setValue(otp, forKey: "otp")
                            //                        defaults.synchronize()
                        }
                        
                        //print("display name array: \(self.display_nameArray) ETA Array: \(self.etaArray)")
                        
                        if error != true {
                            dispatch_async(dispatch_get_main_queue(), {
                                //self.activityIndicator.stopAnimating()
                                //self.performSegueWithIdentifier("showOtpVerify", sender: self)
                                
                                self.autoshareData.display_nameArray = self.autodisplay_nameArray
                                self.autoshareData.companyArray = self.autocompanyArray
                                self.autoshareData.minimumArray = self.autominimumArray
                                self.autoshareData.cost_per_distanceArray = self.autocost_per_distanceArray
                                self.autoshareData.base_fareArray = self.autobase_fareArray
                                self.autoshareData.cancellation_feeArray = self.autocancellation_feeArray
                                self.autoshareData.cost_per_minuteArray = self.autocost_per_minuteArray
                                self.autoshareData.surge_multiplierArray = self.autosurge_multiplierArray
                                self.autoshareData.ride_estimate_minArray = self.autoride_estimate_minArray
                                self.autoshareData.ride_estimate_maxArray = self.autoride_estimate_maxArray
                                self.autoshareData.etaArray = self.autoetaArray
                                
                                return
                            })
                        }
                    }
                }//end of for loop
            }
        }
        task.resume()
    }

    
    
    
    
    func data_request_sendLocation(location:CLLocation) {
        let url:NSURL = NSURL(string:TravellingConstants.urls.locations)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let systemVersion = UIDevice.currentDevice().systemVersion
        let battery = UIDevice.currentDevice().batteryLevel
        
        //Params: did,imei,lat,long,os,bat
        let paramString = "did=\(deviceId)&imei=adadn&lat=\(location.coordinate.latitude)&long=\(location.coordinate.longitude)&os=\(systemVersion)&bat=\(battery)"
        print(paramString)
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error in sending location \(error?.localizedDescription)")
                return
            }
            
            if let HTTPResponse = response as? NSHTTPURLResponse {
                let statusCode = HTTPResponse.statusCode
                print("locations status code \(statusCode)")
                //self.activityIndicator.stopAnimating()
                
                if statusCode == 200 {
                    let readableJSON = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    print(readableJSON)
                    
                    if readableJSON["error"] == true {
                        let errorMsg = readableJSON["error_msg"].string as String! ?? String("Something went wrong.Please try again.")
                        print("Error occurred \(errorMsg)")
                        dispatch_async(dispatch_get_main_queue(), {
                            //self.activityIndicator.stopAnimating()
                            //show alert message
                            //self.showAlert("Something went wrong.Please try again.")
                            self.showAlert(errorMsg)
                            return
                        })
                        
                    } else {
                        //                        let otp = readableJSON["otp"].string as String!
                        //                        print(readableJSON["otp"].string as String!)
                        //                        let defaults = NSUserDefaults.standardUserDefaults()
                        //                        defaults.setValue(otp, forKey: "otp")
                        //                        defaults.synchronize()
                        
                        if error != true {
                            dispatch_async(dispatch_get_main_queue(), {
                                //self.activityIndicator.stopAnimating()
                                //self.performSegueWithIdentifier("showOtpVerify", sender: self)
                                return
                            })
                        }
                    }
                }//end of for loop
            }
        }
        task.resume()
    }

    
    func showAlert(yourMsg: String) {
        //show alert message
        let alert = UIAlertController(title: "", message: "\(yourMsg)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        //end alert
        // Delay the dismissal by 5 seconds
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
    }


}







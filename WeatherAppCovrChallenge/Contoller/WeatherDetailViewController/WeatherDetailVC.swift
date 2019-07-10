//
//  WeatherDetailVC.swift
//  WeatherAppCovrChallenge
//
//  Created by Mehmet Can Seyhan on 2019-07-09.
//  Copyright © 2019 Mehmet Can Seyhan. All rights reserved.
//

import UIKit
import Alamofire
import Disk

class WeatherDetailVC: BaseVC {

    //IBOutlets
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblTemperature: UILabel!
    @IBOutlet var lblWind: UILabel!
    @IBOutlet var lblSummary: UILabel!
    @IBOutlet var lblHumidity: UILabel!
    @IBOutlet var imgViewIcon: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    //Variables
    var cityId:Int = 0
    var cityName:String = ""
    var weatherDetailModel: WeatherDetailModel?
    var listViewDetailDelegate:ListViewDetailDelegate!
    
    //Constant
    let BASE_CACHE_PATH:String = ""
    
    //Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblName.text = cityName
         preConditions()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRefreshClicked(_ sender: UIButton) {
        preConditions()
    }
    
    func preConditions() {
        if cityId != 0 {
            checkInternetConnectionAndGetData()
        } else {
            getLocalData()
        }
    }
    
    func checkInternetConnectionAndGetData() {
        if Reachability.isConnectedToNetwork() {
            getDataFromServer(url: (Services.BASE_URL + cityId.description + "&appid=" + Services.API_KEY))
        } else {
            if existLocalData() {
                self.getLocalData()
            } else {
                self.navigationController?.popViewController(animated: true)
                self.listViewDetailDelegate.createAlert(message: "Please check your internet connection", title: "Warning")
            }
        }
    }
    
    func setData() {
        if let mainModel = weatherDetailModel?.main {
            self.lblTemperature.text = (mainModel.temp?.description ?? "") + "°"
            self.lblHumidity.text = (mainModel.humidity?.description ?? "") + "%"
        }
        if let weatherModel = weatherDetailModel?.weather {
            self.lblSummary.text = weatherModel[0].description ?? ""
            self.imgViewIcon.image = weatherModel[0].iconImage
        }
        if let windModel = weatherDetailModel?.wind {
            self.lblWind.text = (windModel.speed?.description ?? "") + "%"
        }
    }
    
    func existLocalData() -> Bool{
        return Disk.exists(BASE_CACHE_PATH + "/" + self.cityId.description, in: .caches)
    }
    
    func saveLocalData() {
        do {
         try Disk.save(self.weatherDetailModel, to: .caches, as: BASE_CACHE_PATH + "" + self.cityId.description)
            self.setData()
            self.activityIndicator.stopAnimating()
        } catch {
            //print(error.localizedDescription)
        }
    }
    
    func getLocalData() {
        do {
          self.weatherDetailModel =  try Disk.retrieve(BASE_CACHE_PATH + "" + self.cityId.description, from: .caches, as: WeatherDetailModel.self)
            setData()
        } catch {
            self.listViewDetailDelegate.createAlert(message: error.localizedDescription, title: "Warning")
            //print(error.localizedDescription)
        }
         self.activityIndicator.stopAnimating()
    }
    
    func getDataFromServer(url:String) {
        Alamofire.request(url).responseJSON { (dataResponse) in
            self.activityIndicator.stopAnimating()
            if dataResponse.result.isSuccess {
                do {
                    self.weatherDetailModel = try JSONDecoder().decode(WeatherDetailModel.self, from: dataResponse.data!)
                    self.setData()
                    self.saveLocalData()
                } catch {
                    //print(error.localizedDescription)
                    self.listViewDetailDelegate.createAlert(message: error.localizedDescription, title: "Warning")
                }
            } else {
                self.listViewDetailDelegate.createAlert(message: "Request isn't successful", title: "Warning")
            }
        }
    }
}

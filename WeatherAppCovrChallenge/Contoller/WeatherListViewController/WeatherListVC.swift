//
//  ViewController.swift
//  WeatherAppCovrChallenge
//
//  Created by Mehmet Can Seyhan on 2019-07-09.
//  Copyright © 2019 Mehmet Can Seyhan. All rights reserved.
//

import UIKit
import SCLAlertView

class WeatherListVC: UIViewController, UITableViewDelegate, UITableViewDataSource,ListViewDetailDelegate {
   
   //IBOutlets
    @IBOutlet var weatherTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    //Variables
    var limit:Int = 20
    var totalEntries:Int = 0
    var weatherListModel: [WeatherListModel] = []
    var paginationWeatherListModel: [WeatherListModel] = []
    var cityId:Int = 0
    var cityName:String = ""
    var isNewItemLoad:Bool = true
    
    //Constants
    let TO_DETAIL_SEGUE_IDENTIFIER:String = "fromWeatherListVCToDetailVC"
    let WEATHER_LIST_CELL_IDENTIFIER:String = "weatherListCellIdentifier"
    let HEIGHT_FOR_ROW_AT:CGFloat = 65
    
    //Mark: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getLocalJSONData()
        self.title = "City List"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paginationWeatherListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WEATHER_LIST_CELL_IDENTIFIER) as! WeatherListCell
        cell.configureCell(weatherListModel: paginationWeatherListModel[indexPath.row])
        crateBorderLine(indexPathRow: indexPath.row, weatherListCell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HEIGHT_FOR_ROW_AT
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == paginationWeatherListModel.count - 5 && paginationWeatherListModel.count != weatherListModel.count && isNewItemLoad == true {
            self.activityIndicator.startAnimating()
            loadNewItems(itemCount: paginationWeatherListModel.count)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.weatherTableView.deselectRow(at: indexPath, animated: true)
        self.cityId = weatherListModel[indexPath.row].id ?? 0
        self.cityName = weatherListModel[indexPath.row].name ?? ""
        performSegue(withIdentifier: TO_DETAIL_SEGUE_IDENTIFIER, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc:WeatherDetailVC = segue.destination as! WeatherDetailVC
        vc.cityId = self.cityId
        vc.cityName = self.cityName
        vc.listViewDetailDelegate = self
    }
    
    func crateBorderLine(indexPathRow:Int, weatherListCell: WeatherListCell) {
        weatherListCell.layer.borderWidth = 4
        if indexPathRow % 2 == 0 {
            weatherListCell.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            weatherListCell.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    func createAlert(message: String, title: String) {
      SCLAlertView().showWarning(message, subTitle: title)
    }
    
    func getLocalJSONData() {
        guard let path = Bundle.main.path(forResource: "city.list", ofType: "json") else {
            self.activityIndicator.stopAnimating()
            return
        }
        let url = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: url)
        do {
            self.weatherListModel = try JSONDecoder().decode([WeatherListModel].self, from: data!)
            if weatherListModel.count != 0 {
                self.totalEntries = weatherListModel.count
                self.loadNewItems(itemCount: 0)
            }
        } catch {
            self.activityIndicator.stopAnimating()
            self.createAlert(message: error.localizedDescription, title: "Warning")
        }
    }
    
    func loadNewItems(itemCount: Int) {
        var endItem:Int = 0
            if itemCount + limit < totalEntries {
                endItem = itemCount + limit
            } else {
                 isNewItemLoad = false
                 endItem = totalEntries
            }
        for i in itemCount..<endItem {
            paginationWeatherListModel.append(weatherListModel[i])
        }
        self.weatherTableView.reloadData()
        self.activityIndicator.stopAnimating()
    }
}


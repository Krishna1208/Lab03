//
//  ViewController.swift
//  Lab03
//
//  Created by Krishna Desai on 2022-07-31.
//

import UIKit

import CoreLocation

class ViewController: UIViewController,UITextFieldDelegate {

    
    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet var conLabel: UILabel!
    
    @IBAction func onLocationTapped(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    @IBAction func onSearchTapped(_ sender: UIButton) {
        loadWeather(search: searchText.text)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadImg()
               searchText.delegate = self
               locationManager.delegate=self
    }
    private func loadImg(){
            let config = UIImage.SymbolConfiguration(paletteColors:[.systemRed,.systemBlue,.systemYellow])
            imgWeather.preferredSymbolConfiguration=config
            imgWeather.image=UIImage(systemName: "sun.max.circle")
        }
    func textFieldReturn(_ textField: UITextField) -> Bool {
            textField.endEditing(true)
            print(textField.text ?? "")
            loadWeather(search: searchText.text)
            return true
        }
    
    
    private func loadWeather(search : String?){
            guard let search = search else{
                return
            }
    //        Step 1: Get URL
            guard let url = getURl(query: search) else {
                print("Could not get URL")
                return
            }
    //        Step 2: Create URLSession
            let session =  URLSession.shared
    //        Step 3: Create task for session
            let dataTask = session.dataTask(with: url) { data, response, error in
                //network call finished
                print("Network Call complete")
                
                guard error == nil else{
                    print("Received Error")
                    return
                }
                guard let data = data else {
                    print("No data found")
                    return
                }
                if let weatherData = self.parseJson(data: data) {
                    print(weatherData.location.name)
                    print(weatherData.current.temp_c)
                    print(weatherData.current.condition)
                    DispatchQueue.main.async {[self] in
                        self.locLabel.text = weatherData.location.name
                        self.tempLabel.text="\(weatherData.current.temp_c)C"
                        self.conLabel.text="\(weatherData.current.condition.text)"
                        var config = UIImage.SymbolConfiguration(paletteColors: [.systemCyan,.systemYellow,.systemTeal])
                        self.imgWeather.preferredSymbolConfiguration = config
                            if(weatherData.current.condition.code==1000)
                            {
                                config=UIImage.SymbolConfiguration(paletteColors: [.systemYellow])
                                self.imgWeather.image=UIImage(systemName:"sun.max.fill")
                            }
                            if(weatherData.current.condition.code==1003)
                            {
                                config=UIImage.SymbolConfiguration(paletteColors: [.systemTeal])
                                self.imgWeather.image=UIImage(systemName:"cloud.fill")
                            }
                            if(weatherData.current.condition.code==1003)
                            {
                                config=UIImage.SymbolConfiguration(paletteColors: [.systemTeal])
                                self.imgWeather.image=UIImage(systemName:"cloud.fill")
                            }
                            if(weatherData.current.condition.code==1183)
                            {
                                config=UIImage.SymbolConfiguration(paletteColors: [.systemBlue,.systemGray2])
                                self.imgWeather.image=UIImage(systemName:"cloud.drizzle")
                            }
                            if(weatherData.current.condition.code==1183)
                            {
                                config=UIImage.SymbolConfiguration(paletteColors: [.systemCyan,.systemTeal])
                                self.imgWeather.image=UIImage(systemName:"cloud.heavyrain")
                            }
                            if(weatherData.current.condition.code==1210)
                            {
                                config=UIImage.SymbolConfiguration(paletteColors: [.systemPurple])
                                self.imgWeather.image=UIImage(systemName:"snowflake")
                            }
                        }
                    }
            }
    //        Step 4 : Start the task
            dataTask.resume()
            
        }
     
        private func getURl(query: String) -> URL?{
            let baseURL = "https://api.weatherapi.com/v1/"
            let currentEndpoint = "current.json"
            let apiKey = "eb1a179f9ec545bfbfa42632220208"
            guard let url = "\(baseURL)\(currentEndpoint)?key=\(apiKey)&q=\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
                return nil
            }
            print(url)
            return URL(string: url)
        }
        private func parseJson(data: Data) -> WeatherResult? {
            let decoder = JSONDecoder()
            var weather : WeatherResult?
            do{
                weather = try decoder.decode(WeatherResult.self, from: data)
                } catch{
                    print("Error decoding")
                }
            return weather
            }
    }

    extension ViewController:CLLocationManagerDelegate{
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
            if let location = locations.last{
                let latitude=location.coordinate.latitude
                let longitude = location.coordinate.longitude
                
                
        //        Step 1: Get URL
                guard let url = getURl(query: "\(latitude),\(longitude)") else {
                    print("Could not get URL")
                    return
                }
        //        Step 2: Create URLSession
                let session =  URLSession.shared
        //        Step 3: Create task for session
                let dataTask = session.dataTask(with: url) { data, response, error in
                    //network call finished
                    print("Network Call complete")
                    guard error == nil else{
                        print("Received Error")
                        return
                    }
                    guard let data = data else {
                        print("No data found")
                        return
                    }
                    if let weatherData = self.parseJson(data: data) {
                        print(weatherData.location.name)
                        print(weatherData.current.temp_c)
                        print(weatherData.current.condition)
                        DispatchQueue.main.async {[self] in
                            self.locLabel.text = weatherData.location.name
                            self.tempLabel.text="\(weatherData.current.temp_c)C"
                            self.conLabel.text="\(weatherData.current.condition.text)"
                            var config = UIImage.SymbolConfiguration(paletteColors: [.systemCyan,.systemYellow,.systemTeal])
                            self.imgWeather.preferredSymbolConfiguration = config
                                if(weatherData.current.condition.code==1000)
                                {
                                    config=UIImage.SymbolConfiguration(paletteColors: [.systemYellow])
                                    self.imgWeather.image=UIImage(systemName:"sun.max.fill")
                                }
                                if(weatherData.current.condition.code==1003)
                                {
                                    config=UIImage.SymbolConfiguration(paletteColors: [.systemTeal])
                                    self.imgWeather.image=UIImage(systemName:"cloud.fill")
                                }
                                if(weatherData.current.condition.code==1003)
                                {
                                    config=UIImage.SymbolConfiguration(paletteColors: [.systemTeal])
                                    self.imgWeather.image=UIImage(systemName:"cloud.fill")
                                }
                                if(weatherData.current.condition.code==1183)
                                {
                                    config=UIImage.SymbolConfiguration(paletteColors: [.systemBlue,.systemGray2])
                                    self.imgWeather.image=UIImage(systemName:"cloud.drizzle")
                                }
                                if(weatherData.current.condition.code==1183)
                                {
                                    config=UIImage.SymbolConfiguration(paletteColors: [.systemCyan,.systemTeal])
                                    self.imgWeather.image=UIImage(systemName:"cloud.heavyrain")
                                }
                                if(weatherData.current.condition.code==1210)
                                {
                                    config=UIImage.SymbolConfiguration(paletteColors: [.systemPurple])
                                    self.imgWeather.image=UIImage(systemName:"snowflake")
                                }
                            }
                        }
                    }
            //        Step 4 : Start the task
                    dataTask.resume()
                }
            }
        }


    struct WeatherResult: Decodable{
        let location: Location
        let current: Weather
    }

    struct Location: Decodable{
        let name: String
    }

    struct Weather: Decodable{
        let temp_c: Float
        let condition: WeatherCondition
    }

    struct WeatherCondition: Decodable{
        let text :  String
        let code: Int
    }



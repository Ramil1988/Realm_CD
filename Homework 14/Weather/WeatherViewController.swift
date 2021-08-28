//
//  WeatherViewController.swift
//  Homework 14
//
//  Created by Ramil Sharapov on 14.06.2021.
//

import UIKit
import SnapKit

class WeatherViewController: UIViewController {
    
    let choiceCityTextField = UITextField()
    let loadCityWeatherButton = UIButton()
    let dataLabel = UILabel()
    var cityLabel = UILabel()
    let imageWeather = UIImageView()
    let descriptionLabel = UILabel()
    let temperatureLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingElementsOfView()
        self.dataLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        
        let weather = DataManager().getWeather()
        self.cityLabel.text = weather?.name
        self.imageWeather.image = UIImage(named: weather?.icon ?? "50n")
        self.descriptionLabel.text = weather?.weatherDescription
        self.temperatureLabel.text = "\(String(describing: weather?.feelsLike ?? 0))°"
        
        print(weather?.name ?? "No data")
    }
    
    func settingElementsOfView() {
        
        choiceCityTextField.backgroundColor = .white
        view.addSubview(choiceCityTextField)
        
        choiceCityTextField.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(120)
            maker.top.equalToSuperview().inset(100)
            maker.height.equalTo(30)
        }
        
        loadCityWeatherButton.setImage(UIImage(systemName: "arrowshape.turn.up.forward.fill"), for: .normal)
        loadCityWeatherButton.tintColor = .white
        view.addSubview(loadCityWeatherButton)
        loadCityWeatherButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside) // self - куда мы отправляем (какой класс) нажатие кнопки
        
        loadCityWeatherButton.snp.makeConstraints { maker in
            maker.size.equalTo(30)
            maker.centerY.equalTo(choiceCityTextField)
            maker.leading.equalTo(choiceCityTextField.snp.trailing).offset(20)
        }
        
        dataLabel.textColor = .white
        dataLabel.text = "Data"
        dataLabel.font = UIFont(name: "Helvetica Neue", size: 35)
        
        view.addSubview(dataLabel)
        dataLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(choiceCityTextField.snp.bottom).offset(50)
        }
        
        cityLabel.textColor = .white
        cityLabel.text = "City"
        cityLabel.font = UIFont(name: "Helvetica Neue", size: 50)
        
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(dataLabel.snp.bottom).offset(50)
        }
        
        view.addSubview(imageWeather)
        imageWeather.snp.makeConstraints { maker in
            maker.size.equalTo(80)
            maker.height.equalTo(80)
            maker.centerX.equalToSuperview()
            maker.top.equalTo(cityLabel.snp.bottom).offset(50)
        }
        
        descriptionLabel.textColor = .white
        descriptionLabel.text = "Description"
        descriptionLabel.font = UIFont(name: "Helvetica Neue", size: 35)
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(imageWeather.snp.bottom).offset(30)
        }
        
        temperatureLabel.textColor = .white
        temperatureLabel.text = "Temp"
        temperatureLabel.font = UIFont(name: "Helvetica Neue", size: 50)
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(descriptionLabel.snp.bottom).offset(50)
        }
    }
    
    @objc private func searchButtonTapped() {
        guard  let city = choiceCityTextField.text else { return }
        WeatherLoader.shared.loadWeather(nameOfCity: city) { weather in
            DispatchQueue.main.async {
                self.cityLabel.text = weather?.city?.name
                self.imageWeather.image = UIImage(named: weather?.list?.first?.weather?.first?.icon ?? "50n")
                self.descriptionLabel.text = weather?.list?.first?.weather?.first?.weatherDescription
                self.temperatureLabel.text = "\(weather?.list?.first?.main?.feelsLike ?? 0)°"
                
                DataManager().saveWeather(name: weather?.city?.name ?? "No data", weatherImage: weather?.list?.first?.weather?.first?.icon ?? "50n", weatherDescription: weather?.list?.first?.weather?.first?.weatherDescription ?? "No data", weatherTemperature: weather?.list?.first?.main?.feelsLike ?? 0)
            }
        }
    }
}


<h1 align="center">
  <br>
  <img src="https://i.imgur.com/IQgEu3O.png" width="200"></a>
  <br>
</h1>

# Le Baluchon
💰 Converter | 🗣 Translator | 🌤️ Weather

<img src="https://i.imgur.com/1fOCVRA.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/I0toyf3.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/8PrqR5o.png" width="200" height="450"> 

## 🌍 About
Le Baluchon is an application for travelers looking to simplify their trip. It offers a currency converter, a multilingual translator and a weather forecast for your destination. All in all, Le Baluchon is an essential tool for any budget-conscious traveler. 

## 💻 Requirements
The Baluchon is written in Swift 5 and supports iOS 13.0+. Built with Xcode 13.

## 🍀 Architecture
This application is developed according to the [MVC](https://medium.com/@joespinelli_6190/mvc-model-view-controller-ef878e2fd6f5) architecture.

## 🛠 APIs
The Baluchon uses [Fixer](https://fixer.io/) to convert currency, [Google's Translation](https://translate.google.com/intl/fr/about/forbusiness/) to translate text and [OpenWeather](https://openweathermap.org/api) to return city weather data.

## 🕵️‍♂️ How to test 
### Clone the project

Run `git@https://github.com/yann-rzd/LeBaluchon.git`

### Workspace

Open `LeBaluchon.xcodeproj`

### Add your API keys

Create a file `APIKeys.swift`

Add this code:

`struct APIKeys {
    static let currencyKey = "yourAPIKey"
    static let translationKey = "yourAPIKey"
    static let weatherKey = "yourAPIKey"
}` 

Replace yourAPIKey with your key. 

Build & Run 🔥

# Dalio
This is iOS test application to demonstrate work with data fetching & caching, architecture and a bit of unit testing.


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for overview and testing purposes.

### Prerequisites

* Mac OS X 13+, Xcode 14+

### Installing

1. Clone Dalio repository

            git clone git@github.com:Malaar/Dalio.git

2. Install/Update project dependencies (via SPM).
3. Done.

## App architecture
Overview.
SRP used to separate responsibilities among entities aka: AssetNetworkService, AssetStorage, AssetRepository.
AssetViewModel as ViewModel entity of MVVM was build based on reactive streams principles. StreamHandler was used to easily management of this streams.
Use principle of different TO for different layers: Network.Asset - to use in Network layer, Asset - to use in Domain layer, AssetViewState - to use in Presentation layer.  

Principles used during development:
* MVVM - pattern of presentation layer to separate data preparation/formatting from UI configuration. RxSwift was used for bindings and to organise data flow.
* Unidirectional data flow - to organise data flow between components.
* POP - protocol oriented programming aka Dependency inversion principle of SOLID
* SRP - single responsibility principle of SOLID
* Other SOLID, KISS, OOP principles


## Libraries
* RxSwift - third-party lib for reactive programming
* Reusable - third-party small but effective library for nib loading (just to minimise lines of code)
* Alamofire/RxAlamofire - third-party lib for networking
* KMBFormatter - third-party lib for number formatting 
* SPM is used for manage libraries;


## Improvements
Some improvements can be implemented:
* Add themes support
* Add localisation
* Add better error handling

## Author

* **[Andrii Korshylovskyi](http://www.linkedin.com/in/korshilovskiy)** - development

## License

(c) All rights reserved.
This project is licensed under the **Proprietary Software License**. All intellectual rights to this code is belong to **[Andrii Korshylovskyi](http://www.linkedin.com/in/korshilovskiy)**

# APOD Technical test
Create an iOS app listing the last 30 astrology pictures from NASA APOD API

## Requirements
- One screen listing the pictures (free UI)
- One detail screen showing the image, the explantaion and all related information
- A viewer displaying the picture in high resolution

## Architecture
It is a UIKit app application. iOS16 minimum. iPhone only, portrait only.
The app is composed of:
- a remote Store responsible for the management of the API and the image loader
- a repository responsible of the app requirements
- a coordinator managing the presentation of the screens based on MVVM architecture

The project is divided into 7 SPM modules:
- Domain: defines the protocol used inside the app and between the modules
- Design system: centralizes icons and colors used in the App. Could integrate the common views between modules
- RemoteStore: manages the APOD API and image loader (include unit tests)
- Repository: links the remote store and the app (include unit tests)
- ListingPictures: displays the last 30 pictures (include unit tests)
- PictureDetail: displays the detail of the picture (include unit tests)
- HighDefinitionPicture: displays the high definition picture

The coordinator is managed by the application. 
No use of external libraries. Combine framework is used to manage the interaction between each modules

## Improvements
- add a cache for the images for a better user experience
- take into account the device rotation and iPad devices
- add loading animations


## Info
The app icon has been created by Dall-E 2 OpenAI. The Design system colors chosen are based on the icon.

# SC2006 Syntax Symphony - Park Proximity
> Done by: Chee Han, Michael, Aaron, Arjun, Pranav, Owen

## Intro
Given the recent congestion at car parks in Singapore, a user-friendly car-parking app that displays the availability of nearby car parks becomes essential. ParkProximity is a mobile application that displays the availability of car parks near the user and provides directions to the selected car park. Additional features include navigation to the nearby car park, pinpointing parked car locations, retrieving a record of the user’s parking history, and saving favourites.

This product is to help users make use of the publicly available datasets from data.gov.sg and Land Transport Authority APIs. The product adds on to these datasets by providing search functionality and provides directions using the Google Maps API.

## System Architecture
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Spring](https://img.shields.io/badge/Spring-6DB33F?style=for-the-badge&logo=spring&logoColor=white)
![PostGreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)

## Getting Started (Front End)
1. Clone front end
2. Download dependencies required after navigating to the `parking` folder
```
dart pub get
```
3. Update the IP address for `webConnect` in the `parking/lib/constant/constant.dart` to own backend server IP address

## Getting Started (Back End)
1. Install `PostGreSQL`
2. Navigate to `src/main/resources/application.properties`
3. Ensure that `spring.datasource.url` and `spring.datasource.username` has been updated with the correct information

If you are developing on an Ubuntu system, include this line in the `pg_hba.conf` file in your postgresql installation folder
```
local   all     all             trust
```

## Demo Video
[![Demo Link](https://img.youtube.com/vi/N9LZaZcG9Xw/0.jpg)](https://www.youtube.com/watch?v=N9LZaZcG9Xw "Demo Link")

## Quick Fix for 'no carpark data found'
1. Firstly, ensure that the map is in place with carparks
2. Secondly, go to the filters page and check off all the availability filters
3. If the error still persists, it might be due to incorrect saving of the `SharedPreferences` in the flutter app
4. To fix this, simply clear the remove the `settings` key in the `SharedPreferences` by including the following line before `runApp` in `main.dart`

```
prefs.remove('settings');
```

5. Let the app run, it would be better it there is a breakpoint set at the included line
6. Stop the app anytime after that line ran and remove it
7. Rerun the app
8. If the error still persists, repeat step 2

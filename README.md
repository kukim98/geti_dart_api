Intel GETi API in Dart.

This Dart plugin supports the most basic functions in Intel GETi that are deemed essential for mobile application uses.

## Features

| Feature                                       | Supported?         |
| -------                                       | :--------------:   |
| Authentication with Username & Password       | :heavy_check_mark: |
| Authentication with Access code               | :grey_exclamation: |
| Create, Read, Update, Delete Projects         | :heavy_check_mark: |
| Upload and Delete Images                      | :heavy_check_mark: |
| Upload and Delete Annotations                 | :heavy_check_mark: |
| Get AI predictions from pre-trained models    | :heavy_check_mark: |


## Getting started
* You should have access to an Intel GETi server to try out the APIs.
* Add the following lines of code to `pubspec.yaml` to add the package.
```
...

dependencies:
    intel_geti_api:
        git:
            url: https://github.com/kukim98/geti_dart_api.git
            ref: main

...
```
* Save the changes and run `flutter pub get` to download the package.


## Usage
* Construct a GETi API client with valid server IP address and user id.
```dart
IntelGetiClient geti = IntelGetiClient(getiServerURL: serverIP, userID: userId);
```
* Call `authenticate` with valid user credentials to fully interact with Intel GETi.
```dart
Map<String, dynamic> data = {
    'login': testUserId,
    'password': testPassword
};
await geti.authenticate(data);
```


## Additional information
* This package is a Dart version of [geti_sdk](https://github.com/openvinotoolkit/geti-sdk) which is written in Python and designed for PC uses. Because the Dart API was designed for mobile application uses, some features of Intel GETi may be omitted unless deemed necessary.

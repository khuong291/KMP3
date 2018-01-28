### Bandlab test assignment
# KMP3

This is a simple player app for showing list of songs and playing them.

Data is fetched from [this](https://gist.githubusercontent.com/anonymous/fec47e2418986b7bdb630a1772232f7d/raw/5e3e6f4dc0b94906dca8de415c585b01069af3f7/57eb7cc5e4b0bcac9f7581c8.json).

Time spent: <13 hours>

### Features

#### Required

- [x] Do not use 3rd party libraries, do not copy/paste code from 3rd party libraries.

- [x] Use git for local development.

- [x] Use Swift 4

- [x] Make sure the app has enough unit tests coverage.


#### Bonus tasks

- [x] Create a mechanism to cache streaming audio files. If User wants to a play a cached song, we should played a locally cached file instead of doing remote streaming.

- [x] Make the app work in offline mode.


### Architecture and Working Process

- I choose MVVM design pattern for this application due to it's very good data binding, consistence, lightweight of code in each file.

- The first step is structure folders, I structure the folders based on each feature. There are two big folder: Features and Library. Features folder contains views and view models. In features folder, I seperate into FeedView, MiniPlayerView and PlayerView. Library folder contains Extension, Common, Model and Service .

<img src="https://github.com/khuong291/KMP3/blob/master/Images/folder_structure.png">

- Common folder contains Binding class for binding data and Constraint class for setting constraint. I am a fan of RxSwift, I love binding and reacting so I decide to write my own Binding class, it's lightweight but I ensure it's enough for work.

- Service folder contains many class service inside: NetworkService, PlayerService, CacheService, ImageFetchingService. Each service only performs its task.

- NetworkService handle fetching data from network.

- PlayerService handle fetching audio and playing it.

- CacheService handle saving and loading data. It works as follows: Memory -> Disk -> Network

- ImageFetchingService handle fetching image. 

- I write Unit Test or UI Test immediately once I finish writing some functions. For example: when I finish designing model for Song, then I create a class SongTests.swift and write some test cases for testing whether it can be parsed or not.

<img src="https://github.com/khuong291/KMP3/blob/master/Images/testcase.png">

### Walkthrough

![](KMP3.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

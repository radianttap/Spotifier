# Spotifier

This is custom Spotify iOS app. It allows you search and browse and possibly even play some music.

It’s an example app, built to showcase KiLS[^1] architecture: Keep it Layered & Simple.

### How to run

This is built with Swift 5 code thus do use Xcode 10.2.

(1) Install [Homebrew](https://brew.sh)

(2) Install [Sourcery](https://github.com/krzysztofzablocki/Sourcery)

```
brew install sourcery
```

(3) Install [Carthage](https://github.com/Carthage/Carthage)

```
brew install carthage
```

(4) Open Terminal, go to the project root folder, then do this:

```
carthage update --no-build
carthage build --platform iOS
```

(5) Open `Spotifier.xcodeproj` and it should compile just fine.

(6) Look into `Spotify/Spotify.swift`, at the top you should see:

```swift
private static let clientID: String = "YOUR_CLIENT_ID"
private static let clientSecret: String = "YOUR_CLIENT_SECRET"
```

That’s where you need to paste your OAuth2 credentials you get when you register your app as client on [Spotify Developer Portal](https://developer.spotify.com).


[^1]: aka the LAYERS, aka the ONION, aka the GARLIC architecture
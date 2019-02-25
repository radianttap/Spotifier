# Spotifier

This is custom Spotify iOS app. It allows you search and browse and even play some music.

It’s an example built to showcase LAYERS architecture (aka the ONION, aka the GARLIC architecture).

### How to run

This is built with Swift 4.2 code thus use Xcode 10.1.

(1) Install [Homebrew](https://brew.sh)

(2) Install [Carthage](https://github.com/Carthage/Carthage)

```
brew install carthage
```

(3) Open Terminal, go to the project root folder, then do this:

```
carthage update --no-build
carthage build --platform iOS
```

(4) Open `Spotifier.xcodeproj` and it should compile just fine.

(5) Look into `Spotify/Spotify.swift`, at the top you should see:

```swift
private static let clientID: String = "YOUR_CLIENT_ID"
private static let clientSecret: String = "YOUR_CLIENT_SECRET"
```

That’s where you need to paste your OAuth2 credentials you get when you register your app as client on [Spotify Developer Portal](https://developer.spotify.com).



# News app (iOS)

iOS application that displays news and its sources.<br>
The implementation follows good practices, such as modularization, context isolation, single source of truth, etc.


https://github.com/rbrauwers/news-app-ios/blob/main/Videos/ios_native_16_jan_24.mp4


## How it works
Data is fetched from the [News API](https://newsapi.org/).

## Setup
Create an [API Key](https://newsapi.org/account) and place it at `NANetwork/Info.plist`:
```
<dict>
	<key>NewsApiKey</key>
	<string></string>
</dict>
```


## Stack
- [Swift UI](https://developer.apple.com/xcode/swiftui/)
- [Swift concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)

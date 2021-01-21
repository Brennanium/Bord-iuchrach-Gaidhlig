# Bòrd-iuchrach Gàidhlig

A custom keyboard extension app for Scottish Gaelic which tries to mimic the iOS system keyboard behaviors and appearance.  
<p align="leading">
    <img src ="Resources/Keyboard Picture.png" width=400 />
</p>


## Features

- Regular keyboard 
- Looks and behaves like system keyboard
- Context aware grave accent/apostrophe key
- Hold key for alternate forms of character
- Basic autocomplete for starting a sentence, a few common words, and common suffixes
- Double tap space bar for period
- Buttons with words written in Scottish Gaelic

## Purpose

Currently, iOS does not have system-wide support for Scottish Gaelic and therefore also doesn't include an option for using a system keyboard for Gaelic.  This app is specifically designed for Gaelic keyboard input with rudimentary autocomplete suggestions and a special context aware key for typing grave accent characters and apostrophe.  

It’s really important for minority/endangered languages to have representation in technology; if a majority language is always easier to use with technology then younger generations won’t choose to use their minority/endangered languages online.  

## Method

This app is written entirely in Swift and almost entirely uses SwiftUI, though it also uses a little bit of UIKit.  I am using Daniel Saidi's excellent [KeyboardKit][KeyboardKit] open source library for making reliable and very functional custom keyboard extensions which mimic the system keyboards.  It’s currently in the process of changing from using UIKit to using SwiftUI.  All of the change made a great opportunity for me to contribute to the project as I learn about how it works.

## Future features

- iPad Layout: the iPad layout is currently too rough as it was not the main focus when considering layout
- Autocomplete Suggestions: the autocomplete suggestions are currently very basic; adding a full autocorrect and autocomplete system is a must for a future version
- Making input set and autocomplete/correct easily swappable/trainable for new languages, with minimal change to the code; for non-programmers.  Ideally for other minority, endangered, or indigenous languages.


[KeyboardKit]: https://github.com/danielsaidi/KeyboardKit

# Dial_infinite_canvas

This is an infinite canvas package written in Flutter/Dart.

## Tech Stack

**UI**: Flutter/Dart

**State Management:** Riverpod

## Install package and use it in your project

**Ignore this section, the package hasn't been uploaded to pub.dev yet.**

- Option 1: Flutter CLI

```bash
flutter pub get dial_infinite_canvas
```

- Option 2: Add to pubspec.yaml

```yaml
dependencies:
  dial_infinite_canvas: ^0.10.8
```

or, add by path:

```yaml
dependencies:
  dial_infinite_canvas:
    path: ../dial_infinite_canvas
```

## Run Locally

Clone the project

```bash
git clone https://github.com/zz0-0/dial_infinite_canvas
```

Go to the project directory

```bash
cd dial_infinite_canvas
```

Install dependencies

```bash
flutter pub get
```

Run the project

- Option 1: VSCode

```bash
cd example/lib
# click Run in Run|Debug|Profile
```

- Option 2: Flutter CLI

```bash
cd example/lib
flutter run
# pick the platform you want to run with
```

- main.dart
  - click Run

## Features

- [x] Controls
  - [x] Zoom in, zoom out the canvas with mouse scrolling
  - [x] Add cards to the canvas
  - [x] Add groups to the canvas
- [x] Canvas
  - [x] Pan left, pan right the canvas with the left mouse pressing
- [x] Card
  - [x] Connect cards' input nodes and output nodes with mouse-clicking
    - [x] Tap down node animation
  - [x] Border show on the selected card
  - [x] Drag and drop cards
  - [ ] Different card type
    - [ ] Bank debit
    - [ ] Contact
      - [ ] Person
      - [ ] Address
    - [ ] Product
      - [ ] Place
      - [ ] Sale
      - [ ] Movie
      - [ ] Book
    - [ ] Flight
    - [ ] Markdown
      - [ ] Media/News
      - [ ] Note
    - [ ] Chart
    - [ ] Call to action
    - [ ] List table
    - [ ] Login
    - [ ] Review
    - [ ] Color picker
    - [ ] Specturm
    - [ ] Thermometer
  - [ ] Stacked Card Navigation
  - [x] Resize cards
    - [ ] top
    - [x] bottom
    - [ ] left
    - [x] right
    - [ ] top-left
    - [ ] top-right
    - [ ] bottom-left
    - [x] bottom-right
  - [x] Resize cards animation
- [ ] Group
  - [ ] Group dot type
  - [x] Group cards together
  - [x] Drag and drop cards
  - [x] Resize groups
    - [ ] top
    - [x] bottom
    - [ ] left
    - [x] right
    - [ ] top-left
    - [ ] top-right
    - [ ] bottom-left
    - [x] bottom-right
    - [ ] dragging after zoomed in or zoomed out
  - [x] Resize cards animation
- [ ] Edge
  - [ ] Animation on hover
  - [ ] Edge label
  - [ ] Edge type
- [ ] API

## Authors

- [@zz0-0](https://github.com/zz0-0)

## Contributing

Contributions are always welcome! Feel free to add or change anything in the project.

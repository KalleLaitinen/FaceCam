# FaceCam (Loom Clone)

A lightweight macOS menu bar app that displays a floating, draggable camera preview overlay — perfect for screen recordings, presentations, and video calls.

## Features

- **Floating camera overlay** — always-on-top circular webcam preview
- **Drag & resize** — move and resize the window freely (150px–800px, locked 1:1 aspect ratio)
- **Menu bar control** — show/hide the camera from the menu bar
- **Remembers position** — window position, size, and visibility persist across launches
- **Mirrored preview** — video is mirrored like a real mirror
- **Works across spaces** — visible on all desktops and alongside fullscreen apps
- **Rounded corners** — clean, modern look with continuous corner radius

## Requirements

- macOS 12+
- Swift 5.7+
- A camera (built-in or external)

## Build & Run

```bash
# Build the .app bundle
./build.sh

# Run it
open FaceCam.app

# Or install to Applications
cp -r FaceCam.app /Applications/
```

## How It Works

FaceCam runs as a menu bar app with no dock icon. Click the camera icon in the menu bar to toggle the floating preview. The app uses AVFoundation to capture video from your front-facing camera and displays it in a borderless, always-on-top window that you can drag and resize anywhere on screen.


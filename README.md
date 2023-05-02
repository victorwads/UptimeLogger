# Uptime Logger

### Always-on monitoring and logging your system's uptime and status.

![UptimeLogger Icon](Resources/Assets.xcassets/AppIcon.appiconset/64.png)
![Platform Maos](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
![Version 2.5.0](https://img.shields.io/badge/Version-2.5.0-orange.svg)

![Swift Language](https://img.shields.io/badge/language-Swift-green.svg)
![Shell Language](https://img.shields.io/badge/language-Bash-orange.svg)
[![codecov](https://codecov.io/gh/victorwads/UptimeLogger/branch/main/graph/badge.svg?token=EH6WPEA7HC)](https://codecov.io/gh/victorwads/UptimeLogger)

UptimeLogger is an app that helps you keep track of how long your Mac has been running without restarting. It was created after a MacBook suffered water damage and started shutting down unexpectedly, prompting the need to monitor system uptime. 😔

## Features

- Installs as a service and runs on system load
- Logs uptime to a file for historical tracking
- Logs running proccesses to a file for troubleshooting
- Displays current uptime in the app window
- Checks for updates and prompts you to download them

see more [CHANGELOG](CHANGELOG.md)

For Indexing: Shutdown Detective, Failure Tracker, Power Watcher, Uptime Logger, Blackout Detector, Energy Loss or Power Interruption Tracker

## Installation

1. Download the latest version from the [releases page](https://github.com/victorwads/UptimeLogger/releases).
2. Open the downloaded .dmg file and double-click the Install.pkg file to begin installation.
3. Follow the installation instructions.

## Usage

1. Open the UptimeLogger app.
2. When prompted, click "Open" to grant the app permission to read and write logs folder.
3. The app will display the historical logs.
4. Click on the details icon to see more information about the log, including its processes.
5. Use the settings to set process monitoring if desired.

## Contributing

Contributions are welcome! Please fork the repo and submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgements

- Thanks to @SimStm and @jenifernagasaki for speding some yours helping with improving the project
- Thanks to [OpenAI](https://openai.com/) for training ChatGPT, the language model used to answer questions about this project and help me to learch SwiftUI from scratch.

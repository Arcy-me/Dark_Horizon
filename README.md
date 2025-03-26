## `README.md`

# Dark Horizon 🔒

An advanced anonymity and security tool for Kali Linux. This script provides multiple features such as IP spoofing, MAC address randomization, log clearing, anti-MITM detection, and more.

## Features 🚀
- **IP Changer**: Routes traffic through Tor.
- **MAC Changer**: Randomizes MAC address or selects a manufacturer-based MAC.
- **Log Killer**: Clears system logs to remove traces.
- **Anti-MITM**: Scans for possible Man-In-The-Middle attacks.
- **Anti-Cold Boot**: Checks disk encryption status.
- **Timezone Changer**: Updates system timezone.
- **Browser Anonymization**: Routes browser traffic through Tor.
- **Hostname Changer**: Modifies system hostname.

## Installation 🛠️
1. Clone the repository:
   ```bash
   git clone https://github.com/Arcy-me/Dark_Horizon.git


2. Run the installer:
   ```bash
   chmod +x install.sh
   sudo ./install.sh
   ```

3. Execute the tool:
   ```bash
   darkhorizon
   ```

## Usage 📖
Run the tool and select the desired option from the menu.

```bash
darkhorizon
```

### MAC Changer Functionality
The MAC Changer allows users to:
- Assign a **random MAC address**.
- Choose a **MAC address based on a specific manufacturer** (e.g., Dell, Apple, Samsung, etc.).
- Set a **custom MAC address** manually.

## Requirements 📌
This tool requires:
- `tor`
- `macchanger`
- `arp-scan`
- `curl`

These dependencies are installed automatically via the installer.

## Disclaimer ⚠️
This tool is intended for **educational and ethical** security purposes only. Do not use it for malicious activities.

## Contributing 🤝
Feel free to contribute by forking the repository and submitting pull requests.

---

Happy Hacking! 🛡️

#!/bin/bash

# Function to check if a service is installed
check_service() {
    if ! command -v $1 &> /dev/null; then
        echo "$1 is not installed. Installing..."
        sudo apt-get update && sudo apt-get install -y $1
    fi
}

# Function to change IP address using Tor
ip_changer() {
    check_service tor
    echo "Starting Tor service to change IP..."
    if sudo service tor start; then
        sleep 2
        if curl --socks5 127.0.0.1:9050 https://check.torproject.org/ &> /dev/null; then
            echo "IP address changed through Tor."
            curl --socks5 127.0.0.1:9050 https://checkip.amazonaws.com
        else
            echo "Error: Tor connection failed"
        fi
    else
        echo "Error: Failed to start Tor service"
    fi
}

# Function to change MAC address
mac_changer() {
    check_service macchanger
    
    declare -A mac_prefixes
    mac_prefixes=(
        ["DELL COMPUTER"]="00:14:22"
        ["APPLE LAPTOP"]="00:1C:B3"
        ["HUAWEI ANDROID PHONE"]="E0:19:1D"
        ["XIAOMI ANDROID PHONE"]="28:6C:07"
        ["SONY ANDROID PHONE"]="A4:77:33"
        ["LG ANDROID PHONE"]="38:2D:D1"
        ["SAMSUNG ANDROID PHONE"]="5C:F3:70"
        ["IPOD"]="00:26:08"
        ["IPAD"]="D0:23:DB"
        ["IPHONE"]="F4:5C:89"
        ["HP PRINTER"]="10:1F:74"
        ["CANON PRINTER"]="00:1E:8F"
        ["SAMSUNG TV"]="08:3E:8E"
        ["TVT CAMERA"]="00:12:3B"
        ["ZTE ROUTER"]="00:A0:C6"
        ["TP-LINK ROUTER"]="50:C7:BF"
        ["D-LINK ROUTER"]="10:BE:F5"
        ["SOLAR PANEL"]="D8:61:62"
        ["NINTENDO DS"]="00:09:BF"
        ["SONY PLAYSTATION 4"]="90:FB:A6"
    )
    
    echo "Available interfaces:"
    ip link show | grep -E '^[0-9]' | cut -d: -f2
    echo "Enter network interface (e.g., eth0, wlan0): "
    read interface

    if ! ip link show $interface &> /dev/null; then
        echo "Error: Interface $interface does not exist"
        return 1
    fi
    
    echo "Select a manufacturer or choose 'CUSTOM MAC ADDRESS':"
    select manufacturer in "${!mac_prefixes[@]}" "CUSTOM MAC ADDRESS"; do
        if [[ $manufacturer == "CUSTOM MAC ADDRESS" ]]; then
            echo "Enter custom MAC address: "
            read custom_mac
            if [[ $custom_mac =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
                new_mac=$custom_mac
            else
                echo "Error: Invalid MAC address format"
                return 1
            fi
        else
            prefix=${mac_prefixes[$manufacturer]}
            new_mac="$prefix:$(openssl rand -hex 3 | sed 's/\(..\)/\1:/g; s/:$//')"
        fi
        break
    done
    
    sudo ifconfig $interface down
    sudo macchanger -m $new_mac $interface
    sudo ifconfig $interface up
    echo "MAC address changed to $new_mac on $interface."
}

# Function to clear system logs
log_killer() {
    echo "Warning: This will delete all system logs. Continue? (y/n)"
    read confirm
    if [ "$confirm" == "y" ]; then
        sudo find /var/log -type f -name "*.log" -exec rm -f {} \;
        sudo find /var/log -type f -name "*.gz" -exec rm -f {} \;
        sudo service rsyslog restart
        echo "Logs cleared."
    fi
}

# Function to detect Man-In-The-Middle attacks (MITM)
anti_mitm() {
    check_service arp-scan
    echo "Enter interface to scan: "
    read scan_interface
    if ip link show $scan_interface &> /dev/null; then
        sudo arp-scan --interface=$scan_interface --localnet
    else
        echo "Error: Invalid interface"
    fi
}

# Function to change hostname
hostname_changer() {
    echo "Enter new hostname: "
    read new_hostname
    sudo hostnamectl set-hostname $new_hostname
    echo "Hostname changed to $new_hostname."
}

# Function to protect against cold boot attacks
anti_cold_boot() {
    if command -v cryptsetup &> /dev/null; then
        echo "Checking disk encryption status..."
        if ! sudo cryptsetup status /dev/sda1; then
            echo "Warning: Disk encryption might not be enabled"
        fi
    else
        echo "Error: cryptsetup is not installed"
    fi
}

# Function to change timezone
timezone_changer() {
    echo "Enter new timezone (e.g., America/New_York): "
    read timezone
    sudo timedatectl set-timezone $timezone
    echo "Timezone changed to $timezone."
}

# Function to anonymize browser traffic using Tor
browser_anonymization() {
    echo "Starting Tor service for browser anonymization..."
    sudo service tor start
    echo "Browser traffic routed through Tor."
}


# Main menu
echo "
██████╗  █████╗ ██████╗ ██╗  ██╗    ██╗  ██╗ ██████╗ ██████╗ ██╗███████╗ ██████╗ ███╗   ██╗
██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝    ██║  ██║██╔═══██╗██╔══██╗██║╚══███╔╝██╔═══██╗████╗  ██║
██║  ██║███████║██████╔╝█████╔╝     ███████║██║   ██║██████╔╝██║  ███╔╝ ██║   ██║██╔██╗ ██║
██║  ██║██╔══██║██╔══██╗██╔═██╗     ██╔══██║██║   ██║██╔══██╗██║ ███╔╝  ██║   ██║██║╚██╗██║
██████╔╝██║  ██║██║  ██║██║  ██╗    ██║  ██║╚██████╔╝██║  ██║██║███████╗╚██████╔╝██║ ╚████║
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝
                                                                            (version 1.0)            
"
while true; do

    echo "==================== Anonymity Tool ===================="
    echo "1. IP Changer"
    echo "2. MAC Changer"
    echo "3. Log Killer"
    echo "4. Anti-MITM"
    echo "5. Anti-Cold Boot"
    echo "6. Timezone Changer"
    echo "7. Browser Anonymization"
    echo "8. Hostname Changer"
    echo "9. Exit"
    read -p "Choose an option: " choice

    case $choice in
        1) ip_changer ;;
        2) mac_changer ;;
        3) log_killer ;;
        4) anti_mitm ;;
        5) anti_cold_boot ;;
        6) timezone_changer ;;
        7) browser_anonymization ;;
        8) hostname_changer ;;
        9) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done

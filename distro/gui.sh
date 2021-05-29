#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

banner() {
    clear
    printf "\033[33m    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  \033[0m\n"
    printf "\033[36m    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ \033[0m\n"
    printf "\033[32m    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ \033[0m\n"
    printf "\033[0m\n"
    printf "     \033[32mA modded gui version of ubuntu for Termux\033[0m\n"
    printf "\033[0m\n"

}

package() {
    banner
    echo -e "${R} [${W}-${R}]${C} Checking required packages..."${W}
    sudo apt-get update -y
    sudo apt install udisks2 -y
    sudo rm /var/lib/dpkg/info/udisks2.postinst
    echo "" > /var/lib/dpkg/info/udisks2.postinst
    echo "" > /var/lib/dpkg/info/libfprint0:*.postinst
    sudo rm /var/lib/dpkg/info/fprintd.postinst
    echo "" > /var/lib/dpkg/info/fprintd.postinst
    sudo dpkg --configure -a
    sudo apt-mark hold udisks2
    sudo apt-mark hold fprintd
    sudo apt-mark hold libfprint0
    packs=(sudo wget curl nano git keyboard-configuration ubuntu-desktop)
    for hulu in "${packs[@]}"; do
        type -p "$hulu" &>/dev/null || {
            echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$hulu${C}"${W}
            sudo apt-get install "$hulu" -y --no-install-recommends
        }
    done
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get clean
}

vnc() {
    banner
    echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}

    if [[ ! -d "$HOME/.vnc" ]]; then
        mkdir -p "$HOME/.vnc"
    fi

    if [[ -e "$HOME/.vnc/xstartup" ]]; then
        rm -rf $HOME/.vnc/xstartup
    fi

    wget https://raw.githubusercontent.com/srivathsarao/modded-ubuntu/master/distro/xstartup
    mv -f xstartup $HOME/.vnc/xstartup
    chmod +x $HOME/.vnc/xstartup

    if [[ -e "/usr/local/bin/vncstart" ]]; then
        rm -rf /usr/local/bin/vncstart
    fi

    wget https://raw.githubusercontent.com/srivathsarao/modded-ubuntu/master/distro/vncstart
    mv -f vncstart /usr/local/bin/vncstart
    chmod +x /usr/local/bin/vncstart

    if [[ -e "/usr/local/bin/vncstop" ]]; then
        rm -rf /usr/local/bin/vncstop
    fi

    wget https://raw.githubusercontent.com/srivathsarao/modded-ubuntu/master/distro/vncstop
    mv -f vncstop /usr/local/bin/vncstop
    chmod +x /usr/local/bin/vncstop

    echo "export DISPLAY=":1"" >> /etc/profile
    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile 
    source /etc/profile

}

note() {
    banner
    echo -e " ${G} Successfully Installed !"${W}
    sleep 1
    echo
    echo -e " ${G}Type ${C}vncstart${G} to run Vncserver."${W}
    echo -e " ${G}Type ${C}vncstop${G} to stop Vncserver."${W}
    echo
    echo -e " ${C}Install VNC VIEWER Apk on your Device."${W}
    echo
    echo -e " ${C}Open VNC VIEWER & Click on + Button."${W}
    echo
    echo -e " ${C}Enter the Address localhost:1 & Name anything you like."${W}
    echo
    echo -e " ${C}Set the Picture Quality to High for better Quality."${W}
    echo
    echo -e " ${C}Click on Connect & Input the Password."${W}
    echo
    echo -e " ${C}Enjoy :D"${W}
    echo
    echo

}

package
vnc
note

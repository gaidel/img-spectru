#! /usr/bin/env bash

set -e # Exit immidiately on non-zero result

# Disabling wpa_supplicant & dhcpcd
systemctl disable wpa_supplicant
# systemctl disable dhcpcd

# Настройка NAT (если нужен интернет)
# sudo nano /etc/sysctl.conf
# Найдем и раскомментируем строку net.ipv4.ip_forward=1
# Сохраняем и закрываем файл.

# Далее, создадим правила iptables для организации раздачи интернет.

# Выполним в терминале:
# sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
# sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
# sudo sh -c "iptables-save > /etc/iptables.rules"

# Добавим в автозагрузку правила iptables: sudo nano /etc/rc.local
# Идем в самый конец файла и перед exit 0 добавим строку:iptables-restore < /etc/iptables.rules

# SCRIPT="sudo /root/iptables.sh"
# sed -i "20a${SCRIPT}" /etc/rc.local
# Петров, 18.11.2020: раздачу интернета - отключаем
# Петров, 18.11.2020: dnsmasq - пропишем прям здесь
echo "> Writing dnsmasq.conf"
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
cat << EOF >> /etc/dnsmasq.conf
interface=wlan0
address=/hspr.wlan/192.168.12.1
dhcp-range=192.168.12.100,192.168.12.200,12h
no-hosts
filterwin2k
bogus-priv
domain-needed
quiet-dhcp6
domain=wlan
EOF

echo "> Write STATIC ip to /etc/dhcpcd.conf"
cat << EOF >> /etc/dhcpcd.conf
interface wlan0
    static ip_address=192.168.12.1/24
    nohook wpa_supplicant
EOF


mkdir /var/log/dnsmasq
touch /var/log/dnsmasq/dnsmasq.leases

systemctl enable dhcpcd
systemctl enable dnsmasq
systemctl enable hostapd
# systemctl enable openvpn

# systemctl enable openvpn-client@<name>
# where <name>.conf in /etc/openvpn/client

echo "> Setting to deny byobu to check available updates"
sed -i "s/updates_available//" /usr/share/byobu/status/status
# sed -i "s/updates_available//" /home/pi/.byobu/status

echo "> Setting the max space for syslogs"
# https://unix.stackexchange.com/questions/139513/how-to-clear-journalctl
sed -i 's/#SystemMaxUse=/SystemMaxUse=200M/' /etc/systemd/journald.conf

echo "> Changing default keyboard layout to US"
sed -i 's/XKBLAYOUT="gb"/XKBLAYOUT="us"/g' /etc/default/keyboard

echo "> Setting a short aliases"
cat << EOF >> /home/pi/.bashrc
alias status='sudo systemctl status'
alias start='sudo systemctl start'
alias stop='sudo systemctl stop'
alias restart='sudo systemctl restart'
alias enable='sudo systemctl enable'
alias disable='sudo systemctl disable'
alias reload='sudo systemctl reload'
alias log='sudo journalctl -fu'
# alias dc='docker-compose'
# alias d='docker'
EOF

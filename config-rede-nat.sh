#!/usr/bin/bash

# VARIÁVEIS

IF_WAN="enp0s3"
IF_LAN="enp0s8"
LAN_IP="192.168.0.1"
LAN_NETMASK="255.255.255.0"
DNS1="8.8.8.8"
DNS2="8.8.4.4"


# 0. Checagem de root

if [[ $EUID -ne 0 ]]; then
    echo "Este script precisa ser executado como root (use sudo)." >&2
    exit 1
fi


# 1. /etc/network/interfaces (configuração interfaces)

IFACES_FILE="/etc/network/interfaces"
BACKUP_FILE="/etc/network/interfaces.bak.$(date +%Y%m%d%H%M%S)"

cp "$IFACES_FILE" "$BACKUP_FILE"

echo "==> Escrevendo $IFACES_FILE..."
cat > "$IFACES_FILE" <<EOF
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

# WAN - internet via DHCP
auto ${IF_WAN}
iface ${IF_WAN} inet dhcp

# LAN - rede local fixa
auto ${IF_LAN}
iface ${IF_LAN} inet static
    address ${LAN_IP}
    netmask ${LAN_NETMASK}
EOF

# 2. Subir as interfaces

systemctl restart networking.service 

# 3. DNS (Google) — fixo em /etc/resolv.conf

# chattr -i /etc/resolv.conf 2>/dev/null || true
cat > /etc/resolv.conf <<EOF
nameserver ${DNS1}
nameserver ${DNS2}
EOF
# Protege contra sobrescrita por DHCP/resolvconf. Remova com:
#   chattr -i /etc/resolv.conf
# chattr +i /etc/resolv.conf 2>/dev/null || echo "    (chattr indisponível, resolv.conf não foi travado)"

# 4. Instalando pacotes

apt-get update -y
apt-get install -y iproute2 ifupdown iptables iptables-persistent dhcpcd-base

# 5. Habilitar IP forwarding (internet)

echo "==> Habilitando IP forwarding..."
sed -i '/^net.ipv4.ip_forward/d' /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p


# 6. NAT / compartilhamento via iptables

les -F
iptables -t nat -F

iptables -t nat -A POSTROUTING -o "$IF_WAN" -j MASQUERADE
iptables -A FORWARD -i "$IF_WAN" -o "$IF_LAN" -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i "$IF_LAN" -o "$IF_WAN" -j ACCEPT


# 7. Persistir regras do iptables

mkdir -p /etc/iptables
iptables-save > /etc/iptables/rules.v4
systemctl enable netfilter-persistent >/dev/null 2>&1 || true

# Resumo

echo ""
echo "==> Configuração concluída."
echo "    WAN (${IF_WAN}): $(ip -4 addr show "$IF_WAN" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || echo 'sem IP ainda')"
echo "    LAN (${IF_LAN}): ${LAN_IP}/${LAN_NETMASK}"
echo "    DNS: ${DNS1}, ${DNS2} (resolv.conf travado com chattr +i)"
echo "    IP forwarding: $(cat /proc/sys/net/ipv4/ip_forward)"

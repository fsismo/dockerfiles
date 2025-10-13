if [ ! -d /etc/openvpn/easy-rsa ]; then
	cp -r /usr/share/easy-rsa /etc/openvpn/easy-rsa
	
	# Don't leave any of these fields blank.
	echo "Configure your ssl variables"
	echo "Country Name [US]" && read KEY_COUNTRY && [ ! -n "$KEY_COUNTRY" ] && KEY_COUNTRY="US"
	echo "State or Province Name [CA]" && read KEY_PROVINCE && [ ! -n "$KEY_PROVINCE" ] && KEY_PROVINCE="CA"
	echo "Locality Name (eg, city) [SanFrancisco]" && read KEY_CITY && [ ! -n "$KEY_CITY" ] && KEY_CITY="SanFrancisco"
	echo "Organization Name (eg, company) [Fort-Funston]" && read KEY_ORG && [ ! -n "$KEY_ORG" ] && KEY_ORG="Fort-Funston"
	echo "Organization Unit Name (eg, section) [MyOrganizationalUnit]" && read KEY_OU && [ ! -n "$KEY_OU" ] && KEY_OU="MyOrganizationalUnit"
	echo "Email Address [me@myhost.mydomain]" && read KEY_EMAIL && [ ! -n "$KEY_EMAIL" ] && KEY_EMAIL="me@myhost.mydomain"
	sed -i "/export EASY_RSA/c\export EASY_RSA=\"/etc/openvpn/easy-rsa\"" /etc/openvpn/easy-rsa/vars
	sed -i "/export KEY_COUNTRY/c\export KEY_COUNTRY=\"$KEY_COUNTRY\"" /etc/openvpn/easy-rsa/vars
	sed -i "/export KEY_PROVINCE/c\export KEY_PROVINCE=\"$KEY_PROVINCE\"" /etc/openvpn/easy-rsa/vars
	sed -i "/export KEY_CITY/c\export KEY_CITY=\"$KEY_CITY\"" /etc/openvpn/easy-rsa/vars
	sed -i "/export KEY_ORG/c\export KEY_ORG=\"$KEY_ORG\"" /etc/openvpn/easy-rsa/vars
	sed -i "/export KEY_EMAIL/c\export KEY_EMAIL=\"$KEY_EMAIL\"" /etc/openvpn/easy-rsa/vars
	sed -i "/export KEY_OU/c\export KEY_OU=\"$KEY_OU\"" /etc/openvpn/easy-rsa/vars
	sed -i "/export KEY_NAME/c\export KEY_NAME=\"$(cat /etc/hostname)\"" /etc/openvpn/easy-rsa/vars
	echo "Enabling IP forwarding"	
	echo 1 > /proc/sys/net/ipv4/ip_forward
	sed -i "/#net.ipv4.ip_forward=1/c\net.ipv4.ip_forward=1" /etc/sysctl.conf
	[ ! -h /etc/openvpn/easy-rsa/openssl.cnf ] && ln -s /etc/openvpn/easy-rsa/openssl-1.0.0.cnf /etc/openvpn/easy-rsa/openssl.cnf
fi

cd /etc/openvpn/easy-rsa
HOST=$(cat /etc/hostname)
. ./vars
./clean-all
./build-ca  
./build-key-server $HOST
./build-dh
openvpn --genkey --secret /etc/openvpn/easy-rsa/keys/ta.key
mkdir -p /var/OpenVPNClients/

#!/usr/bin/env bash

# commands run as the vagrant user after the image is provisioned and the root script is complete

#
# install composer-tools
#
mkdir ~/fabric-tools && cd ~/fabric-tools

curl -O https://raw.githubusercontent.com/hyperledger/composer-tools/master/packages/fabric-dev-servers/fabric-dev-servers.tar.gz
tar -xvf fabric-dev-servers.tar.gz

#
# copy the admin credentials to /vagrant
# ~/fabric-tools/fabric-scripts/hlfv11/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
#

#
# create the blockchain admin card
#
pwd
mkdir /tmp/card
echo '{"version":1,"userName":"PeerAdmin","roles":["PeerAdmin","ChannelAdmin"]}' > /tmp/card/metadata.json
cat << EOF > /tmp/card/connection.json
{
    "name": "fabric-network",
    "x-type": "hlfv1",
    "x-commitTimeout": 300,
    "version": "1.0.0",
    "client": {
        "organization": "Org1",
        "connection": {
            "timeout": {
                "peer": {
                    "endorser": "300",
                    "eventHub": "300",
                    "eventReg": "300"
                },
                "orderer": "300"
            }
        }
    },
    "channels": {
        "composerchannel": {
            "orderers": [
                "orderer.example.com"
            ],
            "peers": {
                "peer0.org1.example.com": {}
            }
        }
    },
    "organizations": {
        "Org1": {
            "mspid": "Org1MSP",
            "peers": [
                "peer0.org1.example.com"
            ],
            "certificateAuthorities": [
                "ca.org1.example.com"
            ]
        }
    },
    "orderers": {
        "orderer.example.com": {
            "url": "grpc://localhost:7050"
        }
    },
    "peers": {
        "peer0.org1.example.com": {
            "url": "grpc://localhost:7051",
            "eventUrl": "grpc://localhost:7053"
        }
    },
    "certificateAuthorities": {
        "ca.org1.example.com": {
            "url": "http://localhost:7054",
            "caName": "ca.org1.example.com"
        }
    }
}
EOF

PRIVATE_KEY=~/fabric-tools/fabric-scripts/hlfv11/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/114aab0e76bf0c78308f89efc4b8c9423e31568da0c340ca187a9b17aa9a4457_sk
CERT=~/fabric-tools/fabric-scripts/hlfv11/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem
mkdir /tmp/card/credentials
cp ${PRIVATE_KEY} /tmp/card/credentials/privateKey
cp ${CERT} /tmp/card/credentials/certificate

cd /tmp/card && zip -r PeerAdmin@fabric-network.card . && cp PeerAdmin@fabric-network.card /vagrant && cd -

mkdir -p /vagrant/admin
cp ${PRIVATE_KEY} /vagrant/admin
cp ${CERT} /vagrant/admin
cp /tmp/card/connection.json /vagrant/fabric-network-connection.json

#
# ensure fabric comes up when VM starts
#
(crontab -l 2>/dev/null; echo "@reboot  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && ~/fabric-tools/startFabric.sh 2>&1 | tee ~/fabricstartlog.txt") | crontab -

#
# start up fabric, the first time needs to be sudo probably
#
sudo ~/fabric-tools/startFabric.sh 2>&1 | tee ~/fabricstartlog.txt

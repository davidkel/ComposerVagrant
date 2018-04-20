#!/usr/bin/env bash

# commands run as the vagrant user after the image is provisioned and the root script is complete

#
# install composer's version of byfn
#
git clone -b issue-6978 https://github.com/sstone1/fabric-samples.git
cd fabric-samples
curl -sSL https://goo.gl/6wtTN5 | sudo bash -s 1.1.0
cd first-network

echo running byfn.sh -m generate
echo y | sudo ./byfn.sh -m generate
sudo chmod -R 755 crypto-config

# expose the admin and tls certs certs
mkdir -p /vagrant/composer/org1
mkdir -p /vagrant/composer/org2
CA_ORG1=$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt)
CA_ORG2=$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt)
CA_ORDERER=$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt)
ADMINORG1=crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
cp -p $ADMINORG1/signcerts/A*.pem /vagrant/composer/org1
cp -p $ADMINORG1/keystore/*_sk /vagrant/composer/org1
ADMINORG2=crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
cp -p $ADMINORG2/signcerts/A*.pem /vagrant/composer/org2
cp -p $ADMINORG2/keystore/*_sk /vagrant/composer/org2

#
# create the template connection profile for this fabric network for use by the tutorial
#
cat << EOF > /vagrant/composer/byfn-network.json
{
    "name": "byfn-network",
    "x-type": "hlfv1",
    "version": "1.0.0",
    "channels": {
        "mychannel": {
            "orderers": [
                "orderer.example.com"
            ],
            "peers": {
                "peer0.org1.example.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer1.org1.example.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer0.org2.example.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer1.org2.example.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                }
            }
        }
    },
    "organizations": {
        "Org1": {
            "mspid": "Org1MSP",
            "peers": [
                "peer0.org1.example.com",
                "peer1.org1.example.com"
            ],
            "certificateAuthorities": [
                "ca.org1.example.com"
            ]
        },
        "Org2": {
            "mspid": "Org2MSP",
            "peers": [
                "peer0.org2.example.com",
                "peer1.org2.example.com"
            ],
            "certificateAuthorities": [
                "ca.org2.example.com"
            ]
        }
    },
    "orderers": {
        "orderer.example.com": {
            "url": "grpcs://localhost:7050",
            "grpcOptions": {
                "ssl-target-name-override": "orderer.example.com"
            },
            "tlsCACerts": {
                "pem": "${CA_ORDERER}"
            }
        }
    },
    "peers": {
        "peer0.org1.example.com": {
            "url": "grpcs://localhost:7051",
            "eventUrl": "grpcs://localhost:7053",
            "grpcOptions": {
                "ssl-target-name-override": "peer0.org1.example.com"
            },
            "tlsCACerts": {
                "pem": "${CA_ORG1}"
            }
        },
        "peer1.org1.example.com": {
            "url": "grpcs://localhost:8051",
            "eventUrl": "grpcs://localhost:8053",
            "grpcOptions": {
                "ssl-target-name-override": "peer1.org1.example.com"
            },
            "tlsCACerts": {
                "pem": "${CA_ORG1}"
            }
        },
        "peer0.org2.example.com": {
            "url": "grpcs://localhost:9051",
            "eventUrl": "grpcs://localhost:9053",
            "grpcOptions": {
                "ssl-target-name-override": "peer0.org2.example.com"
            },
            "tlsCACerts": {
                "pem": "${CA_ORG2}"
            }
        },
        "peer1.org2.example.com": {
            "url": "grpcs://localhost:10051",
            "eventUrl": "grpcs://localhost:10053",
            "grpcOptions": {
                "ssl-target-name-override": "peer1.org2.example.com"
            },
            "tlsCACerts": {
                "pem": "${CA_ORG2}"
            }
        }
    },
    "certificateAuthorities": {
        "ca.org1.example.com": {
            "url": "https://localhost:7054",
            "caName": "ca-org1",
            "httpOptions": {
                "verify": false
            }
        },
        "ca.org2.example.com": {
            "url": "https://localhost:8054",
            "caName": "ca-org2",
            "httpOptions": {
                "verify": false
            }
        }
    }
}
EOF

#
# ensure fabric comes up when VM starts
#
(crontab -l 2>/dev/null; echo "@reboot  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && ~/fabric-samples/first-network/byfn.sh -m up -s couchdb -a 2>&1 | tee ~/fabricstartlog.txt") | crontab -

#
# start up fabric, the first time needs to be sudo probably
#
echo y | sudo ./byfn.sh -m up -s couchdb -a 2>&1 | tee ~/fabricstartlog.txt

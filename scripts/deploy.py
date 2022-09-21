from brownie import FundMe, MockV3Aggregator, network, config
from scripts.helpful_scripts import get_account, deploy_mocks
from web3 import Web3 

LOCAL_BLOCKCHAIN_ENV = ["decelopment", "ganache-local"]

# IMPORTANT: To autoconnect to ganache, the brownie port must be the same as the gabache port (change the gabache port).

def deploy_fund_me():
    account = get_account()
    # Pass the price feed address to our fundeme contract

    # If we are on a presistent networl like rinkeby, use asociate address
    # else, deploy mols
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENV:
        price_feed_address = config["networks"][network.show_active()][
            "eth_usd_price_feed"
        ]
    else: 
        deploy_mocks()
        price_feed_address = MockV3Aggregator[-1].address

    fund_me = FundMe.deploy(price_feed_address, 
                            {"from" : account},
                             publish_source = config["networks"][network.show_active()]["verify"])
    print(f"Contract deployed to {fund_me.address}")
    return fund_me

def main():
    deploy_fund_me()

# brownie networks add Ethereum ganache-local host=HTTP://127.0.0.1:8545 chainid=1337
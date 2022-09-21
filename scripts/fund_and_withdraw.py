from brownie import FundMe
from scripts.helpful_scripts import get_account
from web3 import Web3

def fund():
    fund_me = FundMe[-1]
    account = get_account()
    entrance_fee = fund_me.getEntraceFee()
    print(f"The current entry fee is: {entrance_fee}")
    print("Funding")
    fund_me.fund({"from" : account, "value": Web3.toWei(5, "ether"), "gas":100000})

def withdraw():
    fund_me = FundMe[-1]
    account = get_account()
    fund_me.withdraw({"from": account,"gas_price":0,"gas_limit":12000000,"allow_revert":True}) # Add gas_limit if don't works

def main():
    fund()
    withdraw()


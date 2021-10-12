from brownie import TugofWar, accounts, network, config
import os


def main():
	dev = accounts.add(os.environ['PRIVATE_KEY'])
	print(network.show_active())
	publish_source=False
	tug_of_war = TugofWar.deploy(
		{"from":dev},
		publish_source=publish_source
		)
	return tug_of_war

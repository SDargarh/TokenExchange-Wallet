import React, { Component } from "react";
import ReceiveTokenContract from "./contracts/ReceiveToken.json";
import Token from "./contracts/IERC20.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { tokenAddress: "address", amount: 0  };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      this.web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      this.accounts = await this.web3.eth.getAccounts();
      console.log(this.accounts)

      // Get the contract instance.
      this.networkId = await this.web3.eth.net.getId();
      this.receiveTokenDeployedNetwork = ReceiveTokenContract.networks[this.networkId];

      console.log(this.networkId);

      this.ReceiveTokenInstance = new this.web3.eth.Contract(
        ReceiveTokenContract.abi,
        this.receiveTokenDeployedNetwork && this.receiveTokenDeployedNetwork.address,
      );

    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  handleInputChange = (event) => {
    const target = event.target;
    const name = target.name;
    const value = target.value;
    this.setState({
      [name] : value
    });
  }

  handleSubmit = async() => {
    const {tokenAddress, amount} = this.state;
    this.ERC20TokenInstance = new this.web3.eth.Contract(
      Token.abi,
      tokenAddress,
    );
    await this.ERC20TokenInstance.methods.approve(this.receiveTokenDeployedNetwork.address, amount).send({from: this.accounts[0]});
    await this.ReceiveTokenInstance.methods.receiveToken(tokenAddress, amount).send({from: this.accounts[0]});
    alert(" Tokens received");
  }
  
  render() {
    return (
      <div className="App">
        <h1>Swap your Tokens and store in our Wallet!</h1>
        Enter Token's address:< input type="text" name="tokenAddress" onChange={this.handleInputChange} />
        Enter amount (18 decimal precesion by default): <input type="text" name="amount" onChange={this.handleInputChange} />
        <button type="button" onClick={this.handleSubmit}> Transfer tokens </button>
      </div>
    );
  }
}

export default App;

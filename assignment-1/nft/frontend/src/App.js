// Web3 frontend for NFT minting

import { useEffect } from 'react';
import './App.css';
import contract from './contracts/MintingContract.json';
import { useState } from 'react';
import { ethers } from 'ethers';

const contractAddress = "0x7637896D83396f2599530cD5c44658e83f4bd4A4";
const abi = contract.abi;

function App() {

  const checkWalletIsConnected = () => { 
    const { ethereum } = window;

    if (!ethereum) {
      console.log("Make sure you have metamask installed!");
      return;
    }
    else {
      console.log("You're all set!");
    }
  }
  
  const [currentAccount, setCurrentAccount] = useState(null);

  const connectWalletHandler = async () => { 

    const { ethereum } = window;

    if (!ethereum) {
      alert("Please install metamask!");
    }

    try {
      const accounts = await window.ethereum.request({          
        method: "eth_requestAccounts",        
      });
      console.log("Found an account! Address: ", accounts[0]);
      setCurrentAccount(accounts[0]);
    } catch (err) {
      console.log(err);
    }
  }

  const mintNftHandler = async () => { 
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const nftContract = new ethers.Contract(contractAddress, abi, signer);
        
        let myAddress = await signer.getAddress()

        console.log("Initialize Payment");
        let nftTxn = await nftContract.mint(myAddress, "https://github.com/abcoathup/samplenft/blob/master/db.json");

        console.log("Minting...please wait");
        await nftTxn.wait();

        console.log("Mined! See transaction: " + nftTxn.hash);
      }
      else {
        console.log("Ethereum object does not exist");
      }
    }
    catch (err) {
      console.log(err);
    }
  }

  const connectWalletButton = () => {
    return (
      <button onClick={connectWalletHandler} className='cta-button connect-wallet-button'>
        Connect Wallet
      </button>
    )
  }
  
  const mintNftButton = () => {
    return (
      <button onClick={mintNftHandler} className='cta-button mint-nft-button'>
        Mint NFT
      </button>
    )
  }

  useEffect(() => {
    checkWalletIsConnected();
  }, [])

  return (
    <div className='main-app'>
      <h1>NFT Minting</h1>
      <div>
      {currentAccount ? mintNftButton() : connectWalletButton()}
      </div>
    </div>
  )
}

export default App;
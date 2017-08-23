# CryptoNotes


<img src="http://www.emoji.co.uk/files/emoji-one/objects-emoji-one/1977-spiral-note-pad.png" width="200" height="200" />

**Ethereum DAPP** done with truffle to create notes, erase them and edit them. 
 This example may help in the design of your future DApp.
 
 ## Requisites:
 - npm
 - Truffle (npm install truffle)
 - testrpc
 
 *That's all as far as I remember...*
 
 # Run it!
 1. Clone it.
 2. Run in the terminal:
 ``` bash
 $ testrpc
 ```
 3. Open another in the terminal and **inside** the project run:
 ``` bash
 $ truffle compile
 $ truffle migrate
 $ npm run dev
 ```
 
 ---
 
 # Advice
 It's useful to have the [Metamask](https://metamask.io) Google Chrome extension. 
 With it, once you run the ``` $ testrpc``` to run the blockchain, rigth after of the keys you will find the **Mnemonic**, copy it.
 Now in the Metamask extension click that you forgot the password and paste the mnemonic and set a new password. It will open the default address with 100 ether in it.
 You can investigate as much as you want with that account! 🤤

const fs = require("fs");
// let privateKey = fs
//   //.readFileSync(".secret_" + process.env.NETWORK)
//   .readFileSync(".secret_" + process.env.NETWORK)
//   .toString()
//   .trim();
let privateKey = fs
  //.readFileSync(".secret_" + process.env.NETWORK)
  .readFileSync(".secret_" + process.env.NETWORK)
  .toString()
  .trim();

// const mnemonic = fs.readFileSync(".secret").toString().trim();

@@ -15,10 +15,7 @@ const fs = require("fs");
//   );

const MyEtherWalletProvider = require("truffle-sdkwallet-provider-privkey");
//const privKeys = [privateKey]; // private keys
const privKeys = [
  "MTk1ZjUyODAtNjhlYi00YTIzLWJhYWYtYTg1MGNkZmRiNjI3",
]; // private keys
const privKeys = [privateKey]; // private keys

const providerFactory4Ethereum = new MyEherWalletProvider(
  privKeys,

const HDWalletProvider = require("truffle-hdwallet-provider-privkey");

const walletAddr = process.env.WALLET_ADDRESS;
const privateKey = process.env.WALLET_PRIVATE_KEY;
const infuraURL = process.env.INFURA_URL;
const infuraKey = process.env.INFURA_KEY;

module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            from: walletAddr,
            network_id: "*"
        },
        rinkeby: {
            provider: () => {
                return new HDWalletProvider(privateKey, (infuraURL+infuraKey));
            },
            network_id: 4
        }
    }
};

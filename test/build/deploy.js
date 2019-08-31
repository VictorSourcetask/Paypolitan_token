const build = require("./build");
const colors = require("colors");
const HDWalletProvider = require("truffle-hdwallet-provider");
const ganache = require("ganache-cli");
const Web3 = require("web3");
const fs = require("fs");

// support for production blockchain is not implemented yet
useProductionBlockchain = false;

const log = true;
const debug = false;
let logger = console;

function getWalletProvider() {
    if (useProductionBlockchain) {
        //return new Web3(new HDWalletProvider(""));
        return null;
    }
    return ganache.provider();
}

async function deployContract(
    walletProvider,
    contractFullPath,
    doBuild,
    constructorArgs,
    someLogger
) {
    if (!!someLogger) logger = someLogger;

    if (doBuild) build(contractFullPath, logger);

    if (log) logger.log(`==> Deploying contract '${contractFullPath}' and dependencies...`);

    walletProvider.setMaxListeners(15); // suppress MaxListenersExceededWarning
}

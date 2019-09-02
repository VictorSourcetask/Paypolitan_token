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
    const web3 = new Web3(walletProvider);
    this.gasPrice = await web3.eth.getGasPrice();
    this.accounts = await web3.eth.getAccounts();

    // Read in the compiled contract code and fetch ABI description and the bycode as objects
    const compiled = JSON.parse(fs.readFileSync("./ouput/contracts.json"));
    if (
        typeof compiled.errors !== "undefined" &&
        typeof compliled.errors.formattedMessage !== "undefined"
    ) {
        throw compiled.errors.formattedMessage;
    }

    const abi = compiled.contracts["PaypolitanToken.sol"]["PaypolitanToken"].abi;
    const bytecode =
        compiled.contracts["PaypolitanToken.sol"]["PaypolitanToken"].evm.bytecode.object;

    // deploy the contract and send it gas to run
    if (log) logger.log(`Attempting to deploy from account: ${this.accounts[0]}`);

    this.contract = await new web3.eth.Contract(abi)
        .deploy({
            data: "0x" + bytecode,
            arguments: constructorArgs
        })
        .send({ from: this.accounts[0], gas: "6720000" }); //this is the AT the block limit and CANNOT be increased!

    if (this.contract.options.address == null) {
        if (log) logger.log(colors.red("==> Deploy FAILED!\n"));
    } else {
        if (log)
            logger.log(colors.green("==> Contract deployed!")) +
                " to: " +
                colors.blue(this.contract.options.address) +
                "\n";
    }
    return this;
}

async function deploy(contractFullPath, doBuild, constructorArgs, theLogger) {
    if (!!theLogger) logger = theLogger;

    const deployment = await deployContract(
        getWalletProvider(),
        contractFullPath,
        doBuild,
        constructorArgs,
        theLogger
    ).catch(logger.log);

    if (log) logger.log("Done!");

    logger.log("Deployment: " + deployment);
    return deployment;
}

// pass deploy function to module user
module.exports = deploy;

// uncomment to make it run if invoked directly from the command line
//deploy(null, console, true);

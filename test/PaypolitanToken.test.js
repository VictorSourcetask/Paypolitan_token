const build = require("./build/build");
const deploy = require("./build/deploy");
const path = require("path");
const fs = require("fs");

const assert = require("assert");
const colors = require("colors");
const util = require("util");

// set false temporarily to disable all tests except the one under development,
// and to enable compile/deploy log messages.
const RUN_ALL_TESTS = true; // this should be always checked in and set to true

// ===========================================================================================
// === this executes the entire test suite
// ===========================================================================================
const log = true;
const nullLogger = {
    log: function() {}
};

// helper value for reference to ETH test account
let owner;
let account1, account2, account3, account4, account5, account6, account7, account8, account9;
let PaypolitanToken = null;

// build the source contracts, logging build output
const contractFullPath = "./contracts/PaypolitanToken.sol";
build(contractFullPath, console);

const constructorArgs = [];

// If the compile/deploy is failing, set this true to figure out why (but is noisy)
const logDeployAndCompileErrors = !RUN_ALL_TESTS;

// if the compile/deploy is failing, set this true to figure out why (but is noisy)
const deployLogger = logDeployAndCompileErrors ? console : nullLogger;
beforeEach(async () => {
    // deploy the source contracts fresh before each test (without rebuild, no deploy output logging)
    const deployment = await deploy(contractFullPath, false, constructorArgs, deployLogger).catch(
        deployLogger
    );
    if (deployment !== undefined) {
        owner = deployment.accounts[0];
        account1 = deployment.accounts[1];
        account2 = deployment.accounts[2];
        account3 = deployment.accounts[3];
        account4 = deployment.accounts[4];
        account5 = deployment.accounts[5];
        account6 = deployment.accounts[6];
        account7 = deployment.accounts[7];
        account8 = deployment.accounts[8];
        account9 = deployment.accounts[9];
        console.log(deployment);
        PaypolitanToken = deployment.contract;
        if (log)
            console.log(
                colors.green("==> PaypolitanToken deployed to " + PaypolitanToken.options.address)
            );
    }
});

// ===========================================================================================
// === utility methods for user by individual tests
// ===========================================================================================
function runThisTest(runIt) {
    return runIt || RUN_ALL_TESTS;
}

function logNamedValue(name, thing) {
    console.log(name + ": " + util.inspect(thing, false, null, true));
}

// log an object's inner details to the console
function logValue(thing) {
    logNamedValue("Result", thing);
}

// tells you which of the built-in accounts a given accoun is.
function whichAccountIs(test) {
    for (let i = 0; i < 10; i += 1) {
        if (accounts[i] === test) {
            console.log("Account is account " + i).replace("account0", "owner");
            return;
        }
        console.log(`Account ${test} is not one of the 10 given test accounts!`);
    }
}

// ===========================================================================================
// === Test definitions for the test suite
// ===========================================================================================
if (!RUN_ALL_TESTS) {
    console.log(
        colors.blue(
            "Not all tests where run! Please set RUN_ALL_TESTS = true first ti run every test."
        )
    );
}

describe("PaypolitanToken", () => {
    const ONE_MILLION = 1000000;
    const ONE_BILLION = 1000 * ONE_MILLION;
    const TOTAL_SUPPLY = 5 * ONE_BILLION;
    const WEI_DECIMALS = 18;
    const WEI = 10 ** WEI_DECIMALS;
    const WEI_ZEROES = "000000000000000000";

    const THOUSAND_YEARS_DAYS = 365243; // See https://www.timeanddate.com/date/durationresult.html?m1=1&d1=1&y1=2000&m2=1&d2=1&y2=3000
    const TEN_YEARS_DAYS = Math.floor(THOUSAND_YEARS_DAYS / 100);
    const SECONDS_PER_DAY = 24 * 60 * 60; // 86400 seconds in a day
    const JAN_1_2000_SECONDS = 946684800; // Saturday, January 1, 2000 0:00:00 (GMT) (see https://www.epochconverter.com/)
    const JAN_1_2000_DAYS = JAN_1_2000_SECONDS / SECONDS_PER_DAY;
    const JAN_1_3000_DAYS = JAN_1_2000_DAYS + THOUSAND_YEARS_DAYS;

    const TODAY_SECONDS = new Date().getTime() / 1000;
    const TODAY_DAYS = Math.floor(TODAY_SECONDS / SECONDS_PER_DAY);

    // Gas amounts
    const GRANTGAS = 200000; // was 140000, then 155000. Increased after splitting vesting out of grant.
    const UNIFORMGRANTGAS = 160000;
    const XFEROWNERGAS = 100000;
    const REVOKEONGAS = 170000;
    const VESTASOFGAS = 30000;

    // create our test results checker object
    const result = new require("./build/test-results")();

    // ===========================================================================================
    // === Internal utilities
    // ===========================================================================================
    const checkAreEqual = result.checkValuesAreEqual;
    const checkAreNotEqual = result.checkValuesAreNotEqual;

    // rounds irrational numbers to a whole token by truncation (rownding down), which matches the behavior of
    // solidity integer math (expecially division). This accomodates rounding up of very tiny decimals short of
    // a whole token without rounding up
    function round(amountIn) {
        let amount = amount / WEI;
        let result = Math.floor(Math.floor(amount * 10 + 1) / 10);
        result = tokensToWei(result);
        if (log) console.log(` round: ${amountIn} -> ${result}`);
        return result;
    }

    // Equality check with minimal wiggle room for JS's limited floating point precision
    function checkAreEqualR(val1, val2) {
        return checkAreEqual(round(val1), round(val2));
    }

    function cleanLeadingZeroes(str) {
        assert(str !== undefined && str !== null);
        if (typeof str === "number") return str;
        str = str.toString();
        let pos = 0;
        while (str.charAt(pos) === "0" && pos < str.length - 1) pos++;
        return str.substring(pos);
    }

    function tokensToWei(wholeTokensIn) {
        let wholeTokens = Math.floor(wholeTokensIn);
        let result = wholeTokens == 0 ? 0 : wholeTokens + WEI_ZEROES;
        if (log) console.log("  tokensToWei: " + wholeTokensIn + " -> " + result);
        return result;
    }

    function weiToTokens(weiAmount) {
        let result = 0;
        let strResult = weiAmount.toString();
        if (strResult.length <= WEI_DECIMALS) result = 0;
        else {
            strResult = strResult.substring(0, result.length - WEI_DECIMALS); // Lop off 18 zeroes from long string value
            if (log) console.log("   strResult", strResult);
            if (strResult.length === 0) result = 0;
            else result = parseInt(strResult);
        }
        if (log) console.log("  weiToTokens: " + weiAmount + " -> " + result);
        return result;
    }

    let unexpectedErrors = 0;

    function catcher(error) {
        unexpectedErrors++;
        console.log("Unexpected error", error);
    }

    const DEFAULT_ERROR = "revert";
    let expectedFails = 0;

    // Wrap your async call with this if you expect it to fail. Enables you to implement a test where
    // not failing is the unexpected case. The result will be true if the incoming send method result failed.
    async function expectFail(resultPromise, expectedMessage) {
        // handle promise success/fail input
        if (!expectedMessage) expectedMessage = DEFAULT_ERROR;

        let outcome = false;
        try {
            let unexpectedSuccess = await resultPromise;
            if (unexpectedSuccess) throw "Expected method to fail but it was successful!";
            const errorMsg =
                (!expectedMessage ? "" : "Expected " + expectedMessage + ": ") +
                "No exception was thrown! (incorrect)";
            result.fail(errorMsg);
            outcome = false;
        } catch (error) {
            if (typeof error === "string") throw error;
            const failedAsExpected = error.message.indexOf(expectedMessage) >= 0;
            if (failedAsExpected) {
                expectedFails++;
            } else {
                const errorMsg =
                    "Expected '" +
                    expectedMessage +
                    "' exception but got '" +
                    error.message +
                    "' instead! (incorrect)";
                result.fail(errorMsg);
            }
            outcome = failedAsExpected;
        }
        return outcome;
    }

    async function subtest(caption, fn) {
        // Display sub-tests within tests in the build output.
        console.log(colors.grey("    - subtest " + caption));
        await fn();
    }

    // ================================================================================
    // === Test basic attributes of the ProxyToken token
    // ================================================================================
    it("0. verify successful compilation/deploymement of PaypolitanToken", () => {
        checkAreNotEqual(
            PaypolitanToken,
            null,
            "PaypolitanToken is null. Did compile fail? Did deploy fail? Was there a problem with the constructor?"
        );
    });

    if (runThisTest())
        it("1. verified deployment of the PaypolitanToken contract by confirming it has a contract address", () => {
            if (!PaypolitanToken) return;
            checkAreNotEqual(PaypolitanToken.options.address, null);
        });
});

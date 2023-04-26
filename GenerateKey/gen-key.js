"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (g && (g = 0, op[0] && (_ = 0)), _) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
Object.defineProperty(exports, "__esModule", { value: true });
var bip39 = require("bip39");
var ed25519 = require("ed25519-hd-key");
var TaquitoUtils = require("@taquito/utils");
var signer_1 = require("@taquito/signer");
var web3_js_1 = require("@solana/web3.js");
var base58 = require("base58-js");
var ethers_1 = require("ethers");
var mnemonic = bip39.generateMnemonic(128);
var index = 0;
var ethereumGenKey = function (mnemonic, index) { return __awaiter(void 0, void 0, void 0, function () {
    var derivePath, seed, hdWallet, wallet, privateKey, publicKey, address;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                derivePath = "m/44'/60'/0'/0/".concat(index);
                return [4 /*yield*/, bip39.mnemonicToSeed(mnemonic)];
            case 1:
                seed = _a.sent();
                hdWallet = ethers_1.ethers.utils.HDNode.fromSeed(seed);
                wallet = hdWallet.derivePath(derivePath);
                privateKey = wallet.privateKey;
                publicKey = wallet.publicKey;
                address = ethers_1.ethers.utils.computeAddress(publicKey);
                return [2 /*return*/, {
                        address: address,
                        privateKey: privateKey,
                        publicKey: publicKey,
                    }];
        }
    });
}); };
var solanaGenKey = function (mnemonic, index) { return __awaiter(void 0, void 0, void 0, function () {
    var derivePath, seed, derivedSeed, keypair, publicKey, address, privateKey;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                derivePath = "m/44'/501'/".concat(index, "'/0'");
                return [4 /*yield*/, bip39.mnemonicToSeed(mnemonic)];
            case 1:
                seed = _a.sent();
                derivedSeed = ed25519.derivePath(derivePath, seed.toString("hex")).key;
                keypair = web3_js_1.Keypair.fromSeed(derivedSeed);
                publicKey = keypair.publicKey.toString();
                address = publicKey;
                privateKey = base58.binary_to_base58(keypair.secretKey);
                return [2 /*return*/, {
                        address: address,
                        privateKey: privateKey,
                    }];
        }
    });
}); };
var tezosGenKey = function (mnemonic, index) { return __awaiter(void 0, void 0, void 0, function () {
    var TEZOS_BIP44_COINTYPE, derivePath, seed, key, accPrivateKey, signer, _a, accPublicKey, accPublicKeyHash;
    return __generator(this, function (_b) {
        switch (_b.label) {
            case 0:
                TEZOS_BIP44_COINTYPE = 1729;
                derivePath = "m/44'/".concat(TEZOS_BIP44_COINTYPE, "'/").concat(index, "'/0'");
                seed = bip39.mnemonicToSeedSync(mnemonic);
                key = ed25519.derivePath(derivePath, seed.toString("hex")).key;
                accPrivateKey = TaquitoUtils.b58cencode(key.slice(0, 32), TaquitoUtils.prefix.edsk2);
                return [4 /*yield*/, signer_1.InMemorySigner.fromSecretKey(accPrivateKey)];
            case 1:
                signer = _b.sent();
                return [4 /*yield*/, Promise.all([
                        signer.publicKey(),
                        signer.publicKeyHash(),
                    ])];
            case 2:
                _a = _b.sent(), accPublicKey = _a[0], accPublicKeyHash = _a[1];
                return [2 /*return*/, {
                        privateKey: accPrivateKey,
                        publicKey: accPublicKey,
                        address: accPublicKeyHash,
                    }];
        }
    });
}); };
ethereumGenKey(mnemonic, index).then(console.log);
solanaGenKey(mnemonic, index).then(console.log);
tezosGenKey(mnemonic, index).then(console.log);

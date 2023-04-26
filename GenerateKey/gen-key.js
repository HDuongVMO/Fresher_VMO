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
/*
const solanaGenKey = async (mnemonic, index) => {
  const derivePath = `m/44'/501'/${index}'/0'`;
  const seed = await bip39.mnemonicToSeed(mnemonic);
  const derivedSeed = ed25519.derivePath(derivePath, seed.toString("hex")).key;
  const keypair = Keypair.fromSeed(derivedSeed);
  const publicKey = keypair.publicKey.toString();

  const address = publicKey;
  const privateKey = base58.binary_to_base58(keypair.secretKey);
  return {
    address,
    privateKey,
  };
};



const tezosGenKey = async (mnemonic, index) => {
  const TEZOS_BIP44_COINTYPE = 1729;
  const derivePath = `m/44'/${TEZOS_BIP44_COINTYPE}'/${index}'/0'`;
  const seed = bip39.mnemonicToSeedSync(mnemonic);
  const { key } = ed25519.derivePath(derivePath, seed.toString("hex"));
  const accPrivateKey = TaquitoUtils.b58cencode(
    key.slice(0, 32),
    TaquitoUtils.prefix.edsk2
  );

  const signer = await InMemorySigner.fromSecretKey(accPrivateKey);
  const [accPublicKey, accPublicKeyHash] = await Promise.all([
    signer.publicKey(),
    signer.publicKeyHash(),
  ]);
  return {
    privateKey: accPrivateKey,
    publicKey: accPublicKey,
    address: accPublicKeyHash,
  };
};
*/
ethereumGenKey(mnemonic, index).then(console.log);
//solanaGenKey(mnemonic, index).then(console.log);
//tezosGenKey(mnemonic, index).then(console.log);

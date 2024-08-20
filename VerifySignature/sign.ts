const {
    signTypedData,
    SignTypedDataVersion,
  } = require("@metamask/eth-sig-util");
  
  const domain = {
    name: "REIGNLABS", // contract deploy name
    version: "1", // contract deploy version
    chainId: 5, // env chain id
    verifyingContract: "0x23234234234...",
  };
  
  const types = {
    Struct: [
      { name: "id", type: "uint256" },
      { name: "_type", type: "uint256" },
      { name: "_address", type: "address" },
      { name: "_userAddresses", type: "string[]" },
    ],
    EIP712Domain: [
      { name: "name", type: "string" },
      { name: "version", type: "string" },
      { name: "chainId", type: "uint256" },
      { name: "verifyingContract", type: "address" },
    ],
  };
  
  const privateKey =
    "zassda21332453asdasd...";// your private key
  
  const obj = {
    id: 1,
    _type: 0,
    _address: "0xsdfdgerfsd...",
    _userAddresses: [
      "0xasdad23asda...",
      "0xjsdasdasdas...",
    ],
  };
  
  const signature = signTypedData({
    privateKey,
    data: {
      types,
      primaryType: "Struct",
      domain,
      message: obj,
    },
    version: SignTypedDataVersion.V4,
  });
  
  console.log(signature);
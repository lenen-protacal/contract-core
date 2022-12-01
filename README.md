
# Lenen Protocol
Lenen Protocol is an EVM compatible protocol that enables supplying of crypto assets as collateral in order to borrow the base asset. Accounts can also earn interest by supplying the base asset to the protocol.

The initial deployment of VisionNetwork is on Viponeer and the base asset is USDT.

## Quick Visit
## Faucet
You can get airdrop and test protocol on [vision faucet](https://vpioneerfaucet.visionscan.org/#/)

## Deployed on 

### vpioneer:

**CometFactory**

**Len**
[visit on visionscan](https://test.visionscan.org/token20/VXaS2c17AZvanQVQeEregkxm5t14nbrNuM)
```
base58: VXaS2c17AZvanQVQeEregkxm5t14nbrNuM
hex: 46E572AA463B8AB3D922F52C67A016C5F40B8CD9EE
```

[visit on visionscan](https://www.visionscan.org/contract/VRdGXhExMUd9x4NCGAq1v9H1keFveqeX26/code)
```
base58: VRdGXhExMUd9x4NCGAq1v9H1keFveqeX26
hex: 46a42b3abb0519fad59ad4088beb3d7d1c11aef1cb
```




### mainnet:
```
after audit
```


## Contract Description
**CometFactory**  - fully function included. Inherits `CometConfiguration.sol` and is used to deploy new versions of `Comet.sol`. This contract will mainly be called by the Configurator during the governance upgrade process. and

**Comet** - Contract that inherits `CometMainInterface.sol` and is the implementation for most of Comet's core functionalities. would be update by Proxy update.

**CometCore** - Abstract contract that inherits `CometStorage.sol`, `CometConfiguration.sol`, and `CometMath.sol`.

**CometStorage** - Contract that defines the storage variables used for the Comet protocol.

**CometConfiguration** - Contract that defines the configuration structs passed into the constructors for `Comet.sol` and `CometExt.sol`.

**CometMainInterface** - Abstract contract that inherits `CometCore.sol` and contains all the functions and events for `Comet.sol`.



## Questions & Discussion
=================

For any concerns with the protocol, open an issue or visit us on [Discord](https://discord.com/invite/trq3s2JZKj) to discuss.

For questions about interacting with Comet, please visit 
* [our discord server](https://discord.com/invite/trq3s2JZKj)
* [our twitter](https://twitter.com/LenenProtocol)
* [our telegram channel](https://t.me/LenenProtocol)
* [our medium](https://medium.com/@LenenProtocol)

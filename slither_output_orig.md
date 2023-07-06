``` slither --exclude-dependencies --exclude-low --exclude-informational  . 
'forge clean' running (wd: /Users/olympixengineering/code/anish/crowdfund)
'forge build --build-info --force' running
Compiling 34 files with 0.8.19
Solc 0.8.19 finished in 1.70s
Compiler run successful (with warnings)
warning[3420]: Warning: Source file does not specify required compiler version! Consider adding "pragma solidity ^0.8.19;"
--> test/test_refund_reentrancy.sol



warning[5667]: Warning: Unused function parameter. Remove or comment out the variable name to silence this warning.
  --> test/Project.t.sol:29:31:
   |
29 |     function onERC721Received(address to, address from, uint tokenId, bytes memory data) pure public returns (bytes4) {
   |                               ^^^^^^^^^^



warning[5667]: Warning: Unused function parameter. Remove or comment out the variable name to silence this warning.
  --> test/Project.t.sol:29:43:
   |
29 |     function onERC721Received(address to, address from, uint tokenId, bytes memory data) pure public returns (bytes4) {
   |                                           ^^^^^^^^^^^^



warning[5667]: Warning: Unused function parameter. Remove or comment out the variable name to silence this warning.
  --> test/Project.t.sol:29:57:
   |
29 |     function onERC721Received(address to, address from, uint tokenId, bytes memory data) pure public returns (bytes4) {
   |                                                         ^^^^^^^^^^^^



warning[5667]: Warning: Unused function parameter. Remove or comment out the variable name to silence this warning.
  --> test/Project.t.sol:29:71:
   |
29 |     function onERC721Received(address to, address from, uint tokenId, bytes memory data) pure public returns (bytes4) {
   |                                                                       ^^^^^^^^^^^^^^^^^




INFO:Detectors:
Reentrancy in Project.refund() (src/Project.sol#70-76):
	External calls:
	- (success) = address(msg.sender).call{value: contributions[msg.sender]}() (src/Project.sol#73)
	State variables written after the call(s):
	- contributions[msg.sender] = 0 (src/Project.sol#75)
	Project.contributions (src/Project.sol#19) can be used in cross function reentrancies:
	- Project.contribute() (src/Project.sol#48-60)
	- Project.contributions (src/Project.sol#19)
	- Project.refund() (src/Project.sol#70-76)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities
INFO:Detectors:
Reentrancy in Project.claimTokens() (src/Project.sol#62-68):
	External calls:
	- nft.mint(msg.sender) (src/Project.sol#65)
	State variables written after the call(s):
	- tokensClaimed[msg.sender] += numTokensToMint (src/Project.sol#67)
	Project.tokensClaimed (src/Project.sol#21) can be used in cross function reentrancies:
	- Project.claimTokens() (src/Project.sol#62-68)
	- Project.tokensClaimed (src/Project.sol#21)
Reentrancy in CrowdFunder.mint(address) (src/CrowdFunder.sol#22-25):
	External calls:
	- _safeMint(to,_currentTokenId) (src/CrowdFunder.sol#23)
		- IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#406-417)
	State variables written after the call(s):
	- _currentTokenId ++ (src/CrowdFunder.sol#24)
	CrowdFunder._currentTokenId (src/CrowdFunder.sol#11) can be used in cross function reentrancies:
	- CrowdFunder.mint(address) (src/CrowdFunder.sol#22-25)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-1
INFO:Detectors:
Different versions of Solidity are used:
	- Version used: ['>=0.4.22<0.9.0', '>=0.5.0', '>=0.6.0<0.9.0', '>=0.6.2<0.9.0', '^0.8.0', '^0.8.1', '^0.8.13']
	- >=0.4.22<0.9.0 (lib/forge-std/src/StdStyle.sol#2)
	- >=0.4.22<0.9.0 (lib/forge-std/src/console.sol#2)
	- >=0.4.22<0.9.0 (lib/forge-std/src/console2.sol#2)
	- >=0.5.0 (lib/forge-std/lib/ds-test/src/test.sol#16)
	- >=0.6.0<0.9.0 (lib/forge-std/src/StdJson.sol#2)
	- >=0.6.2<0.9.0 (lib/forge-std/src/Base.sol#2)
	- >=0.6.2<0.9.0 (lib/forge-std/src/StdAssertions.sol#2)
	- >=0.6.2<0.9.0 (lib/forge-std/src/StdChains.sol#2)
	- >=0.6.2<0.9.0 (lib/forge-std/src/StdCheats.sol#2)
	- >=0.6.2<0.9.0 (lib/forge-std/src/StdError.sol#3)
	- >=0.6.2<0.9.0 (lib/forge-std/src/StdInvariant.sol#2)
	- >=0.6.2<0.9.0 (lib/forge-std/src/StdMath.sol#2)
	- >=0.6.2<0.9.0 (lib/forge-std/src/StdStorage.sol#2)
	- >=0.6.2<0.9.0 (lib/forge-std/src/StdUtils.sol#2)
	- >=0.6.2<0.9.0 (lib/forge-std/src/Test.sol#2)
	- >=0.6.2<0.9.0 (lib/forge-std/src/Vm.sol#2)
	- >=0.6.2<0.9.0 (lib/forge-std/src/interfaces/IMulticall3.sol#2)
	- ABIEncoderV2 (lib/forge-std/src/StdChains.sol#4)
	- ABIEncoderV2 (lib/forge-std/src/StdCheats.sol#4)
	- ABIEncoderV2 (lib/forge-std/src/StdInvariant.sol#4)
	- ABIEncoderV2 (lib/forge-std/src/StdJson.sol#4)
	- ABIEncoderV2 (lib/forge-std/src/StdUtils.sol#4)
	- ABIEncoderV2 (lib/forge-std/src/Test.sol#4)
	- ABIEncoderV2 (lib/forge-std/src/Vm.sol#4)
	- ABIEncoderV2 (lib/forge-std/src/interfaces/IMulticall3.sol#4)
	- ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#4)
	- ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol#4)
	- ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#4)
	- ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol#4)
	- ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/Context.sol#4)
	- ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/Strings.sol#4)
	- ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol#4)
	- ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol#4)
	- ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#4)
	- ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol#4)
	- ^0.8.0 (src/CrowdFunder.sol#2)
	- ^0.8.0 (test/Project.t.sol#2)
	- ^0.8.0 (test/ProjectFactory.t.sol#2)
	- ^0.8.1 (lib/openzeppelin-contracts/contracts/utils/Address.sol#4)
	- ^0.8.13 (src/Project.sol#2)
	- ^0.8.13 (src/ProjectFactory.sol#4)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#different-pragma-directives-are-used
INFO:Detectors:
Pragma version^0.8.0 (src/CrowdFunder.sol#2) allows old versions
Pragma version^0.8.13 (src/Project.sol#2) allows old versions
Pragma version^0.8.13 (src/ProjectFactory.sol#4) allows old versions
Pragma version^0.8.0 (test/Project.t.sol#2) allows old versions
Pragma version^0.8.0 (test/ProjectFactory.t.sol#2) allows old versions
solc-0.8.19 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity
INFO:Detectors:
Low level call in Project.refund() (src/Project.sol#70-76):
	- (success) = address(msg.sender).call{value: contributions[msg.sender]}() (src/Project.sol#73)
Low level call in Project.withdraw(uint256) (src/Project.sol#78-83):
	- (success) = address(creator).call{value: amount}() (src/Project.sol#81)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls
INFO:Detectors:
ProjectTest (test/Project.t.sol#8-33) should inherit from IERC721Receiver (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#11-27)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-inheritance
INFO:Detectors:
Parameter ProjectFactory.create(uint256,string,string)._goal (src/ProjectFactory.sol#8) is not in mixedCase
Parameter ProjectFactory.create(uint256,string,string)._name (src/ProjectFactory.sol#8) is not in mixedCase
Parameter ProjectFactory.create(uint256,string,string)._symbol (src/ProjectFactory.sol#8) is not in mixedCase
Function ProjectTest.test_contribute() (test/Project.t.sol#16-19) is not in mixedCase
Function ProjectTest.test_claimTokens() (test/Project.t.sol#21-25) is not in mixedCase
Function ProjectFactoryTest.test_create() (test/ProjectFactory.t.sol#17-20) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions
INFO:Detectors:
Project.nft (src/Project.sol#17) should be immutable 
Project.timeCreated (src/Project.sol#12) should be immutable 
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#state-variables-that-could-be-declared-immutable
INFO:Slither:. analyzed (38 contracts with 71 detectors), 21 result(s) found
```
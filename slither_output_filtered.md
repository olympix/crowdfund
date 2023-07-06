``` slither --exclude-dependencies --exclude-low --exclude-informational  . 
'forge clean' running (wd: /Users/olympixengineering/code/anish/crowdfund)
'forge build --build-info --force' running
Compiling 34 files with 0.8.19
Solc 0.8.19 finished in 1.70s
Compiler run successful (with warnings)

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

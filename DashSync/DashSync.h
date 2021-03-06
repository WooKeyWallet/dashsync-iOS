//
//  DSDashSync.h
//  dashsync
//
//  Created by Sam Westrich on 3/4/18.
//  Copyright © 2019 dashcore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSReachabilityManager.h"
#import "DSEnvironment.h"
#import "DSPeerManager.h"
#import "DSChain.h"
#import "DSBlockchainUser.h"

#import "DSECDSAKey.h"
#import "DSBLSKey.h"
#import "DSKey.h"

#import "DSDerivationPath.h"
#import "DSDerivationPathFactory.h"
#import "DSSimpleIndexedDerivationPath.h"
#import "DSAuthenticationKeysDerivationPath.h"
#import "DSMasternodeHoldingsDerivationPath.h"
#import "DSFundsDerivationPath.h"

#import "DSChainsManager.h"
#import "DSChainManager.h"
#import "DSTransactionManager.h"
#import "DSPriceManager.h"
#import "DSMasternodeManager.h"
#import "DSDAPIClient.h"
#import "DSGovernanceSyncManager.h"
#import "DSGovernanceObject.h"
#import "DSGovernanceVote.h"
#import "DSSporkManager.h"
#import "DSVersionManager.h"
#import "DSAuthenticationManager.h"
#import "DSInsightManager.h"
#import "DSEventManager.h"
#import "DSShapeshiftManager.h"
#import "DSBIP39Mnemonic.h"
#import "DSWallet.h"
#import "DSAccount.h"
#import "DSDerivationPath.h"
#import "NSString+Dash.h"
#import "NSMutableData+Dash.h"
#import "DSOptionsManager.h"
#import "NSData+Dash.h"
#import "NSDate+Utils.h"
#import "DSLocalMasternodeEntity+CoreDataProperties.h"
#import "DSAddressEntity+CoreDataProperties.h"
#import "DSDerivationPathEntity+CoreDataProperties.h"
#import "DSPeerEntity+CoreDataProperties.h"
#import "DSMerkleBlockEntity+CoreDataProperties.h"
#import "DSGovernanceObjectEntity+CoreDataProperties.h"
#import "DSGovernanceObjectHashEntity+CoreDataProperties.h"
#import "DSGovernanceVoteEntity+CoreDataProperties.h"
#import "DSGovernanceVoteHashEntity+CoreDataProperties.h"
#import "DSSporkEntity+CoreDataProperties.h"
#import "DSTransactionEntity+CoreDataProperties.h"
#import "DSTransactionHashEntity+CoreDataProperties.h"
#import "DSTxOutputEntity+CoreDataProperties.h"
#import "DSTxInputEntity+CoreDataProperties.h"
#import "DSSimplifiedMasternodeEntry.h"
#import "DSLocalMasternode.h"
#import "DSSpecialTransactionsWalletHolder.h"

#import "DSProviderRegistrationTransaction.h"
#import "DSProviderUpdateServiceTransaction.h"
#import "DSProviderUpdateRegistrarTransaction.h"

#import "DSSimplifiedMasternodeEntryEntity+CoreDataProperties.h"
#import "NSManagedObject+Sugar.h"
#import "DSPaymentRequest.h"
#import "DSPaymentProtocol.h"

#import "DSTransactionFactory.h"
#import "DSTransaction+Utils.h"

#import "DSBlockchainUserTopupTransaction.h"
#import "DSBlockchainUserRegistrationTransaction.h"
#import "DSBlockchainUserResetTransaction.h"
#import "DSBlockchainUserCloseTransaction.h"

#import "DSNetworking.h"

NS_ASSUME_NONNULL_BEGIN

#define SHAPESHIFT_ENABLED 0

//! Project version number for dashsync.
FOUNDATION_EXPORT double DashSyncVersionNumber;

//! Project version string for dashsync.
FOUNDATION_EXPORT const unsigned char DashSyncVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <dashsync/PublicHeader.h>

@interface DashSync : NSObject

@property (nonatomic,assign) BOOL deviceIsJailbroken;

+ (instancetype)sharedSyncController;

-(void)startSyncForChain:(DSChain*)chain;
-(void)stopSyncForChain:(DSChain*)chain;
-(void)stopSyncAllChains;

-(void)wipePeerDataForChain:(DSChain*)chain;
-(void)wipeBlockchainDataForChain:(DSChain*)chain;
-(void)wipeGovernanceDataForChain:(DSChain*)chain;
-(void)wipeMasternodeDataForChain:(DSChain*)chain;
-(void)wipeSporkDataForChain:(DSChain*)chain;
-(void)wipeWalletDataForChain:(DSChain*)chain forceReauthentication:(BOOL)forceReauthentication;

-(uint64_t)dbSize;

@end

NS_ASSUME_NONNULL_END

//
//  DSChainEntity+CoreDataClass.m
//  
//
//  Created by Sam Westrich on 5/20/18.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "DSChainEntity+CoreDataClass.h"
#import "DSChainPeerManager.h"
#import "NSManagedObject+Sugar.h"
#import "DSChain.h"
#import "NSString+Dash.h"
#import "NSData+Bitcoin.h"

@implementation DSChainEntity

- (instancetype)setAttributesFromChain:(DSChain *)chain {
    self.standardPort = @(chain.standardPort);
    self.type = @(chain.chainType);
    return self;
}

- (DSChain *)chain {
    __block DSChainType type;
    __block uint32_t port;
    __block UInt256 genesisHash;
    __block NSData * data;
    [self.managedObjectContext performBlockAndWait:^{
        port = (uint32_t)[self.standardPort unsignedLongValue];
        type = [self.type integerValue];
        genesisHash = *(UInt256 *)self.genesisBlockHash.hexToData.reverse.bytes;
        data = self.checkpoints;
    }];
    if (type == DSChainType_MainNet) {
        return [DSChain mainnet];
    } else if (type == DSChainType_TestNet) {
        return [DSChain testnet];
    } else if (type == DSChainType_DevNet) {
        if ([DSChain devnetWithGenesisHash:genesisHash]) {
            return [DSChain devnetWithGenesisHash:genesisHash];
        } else {
            NSArray * checkpointArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            return [DSChain createDevnetWithCheckpoints:checkpointArray onPort:port];
        }
    }
    return nil;
}

+ (DSChainEntity*)chainEntityForType:(DSChainType)type genesisBlock:(UInt256)genesisBlock checkpoints:(NSArray*)checkpoints {
    NSString * genesisBlockString = [NSData dataWithUInt256:genesisBlock].hexString;
    NSArray * objects = [DSChainEntity objectsMatching:@"type = %d && ((type != %d) || genesisBlockHash = %@)",type,DSChainType_DevNet,genesisBlockString];
    if (objects.count) {
        DSChainEntity * chainEntity = [objects objectAtIndex:0];
        NSArray * knownCheckpoints = [NSKeyedUnarchiver unarchiveObjectWithData:[chainEntity checkpoints]];
        if (checkpoints.count > knownCheckpoints.count) {
            NSData * archivedCheckpoints = [NSKeyedArchiver archivedDataWithRootObject:checkpoints];
            chainEntity.checkpoints = archivedCheckpoints;
        }
        return chainEntity;
    }
    
    DSChainEntity * chainEntity = [self managedObject];
    chainEntity.type = @(type);
    chainEntity.genesisBlockHash = genesisBlockString;
    if (checkpoints) {
        NSData * archivedCheckpoints = [NSKeyedArchiver archivedDataWithRootObject:checkpoints];
        chainEntity.checkpoints = archivedCheckpoints;
    }
    if (type == DSChainType_MainNet) {
        chainEntity.standardPort = @(MAINNET_STANDARD_PORT);
    } else if (type == DSChainType_TestNet) {
        chainEntity.standardPort = @(TESTNET_STANDARD_PORT);
    } else {
        chainEntity.standardPort = @(DEVNET_STANDARD_PORT);
    }
    return chainEntity;
}

@end
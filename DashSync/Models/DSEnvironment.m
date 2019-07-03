//
//  DSEnvironment.m
//  DashSync
//
//  Created by Sam Westrich on 7/20/18.
//

#import "DSEnvironment.h"
#import "DSWallet.h"
#import "DSChainsManager.h"
#import "DSAccount.h"

@interface DSEnvironment ()

@property (nonatomic, strong) NSBundle *enBundle;
@property (nonatomic, strong) NSBundle *zhBundle;

@end

@implementation DSEnvironment

+ (instancetype)sharedInstance
{
    static id singleton = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        singleton = [self new];
    });
    
    return singleton;
}

// true if this is a "watch only" wallet with no signing ability
- (BOOL)watchOnly
{
    static BOOL watchOnly;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            for (DSChain * chain in [[DSChainsManager sharedInstance] chains]) {
                for (DSWallet * wallet in [chain wallets]) {
                    DSAccount * account = [wallet accountWithNumber:0];
                    NSString * keyString = [[account bip44DerivationPath] walletBasedExtendedPublicKeyLocationString];
                    NSError * error = nil;
                    NSData * v2BIP44Data = getKeychainData(keyString, &error);
                    
                    watchOnly = (v2BIP44Data && v2BIP44Data.length == 0) ? YES : NO;
                }
            }
        }
    });

    return watchOnly;
}

-(NSBundle*)resourceBundle {
//    static NSBundle * resourceBundle = nil;
//    static dispatch_once_t onceToken = 0;
//
//    dispatch_once(&onceToken, ^{
//        NSBundle *frameworkBundle = [NSBundle bundleForClass:[DSTransaction class]];
//        NSURL *bundleURL = [[frameworkBundle resourceURL] URLByAppendingPathComponent:@"DashSync.bundle"];
//        resourceBundle = [NSBundle bundleWithURL:bundleURL];
//    });
//    return resourceBundle;
    if ([self.lang containsString:@"zh"]) {
        return self.zhBundle;
    }
    return self.enBundle;
}

- (NSString *)lang {
    NSString *lang = [[NSUserDefaults standardUserDefaults] stringForKey:@"PreferredLanguage"];
    if (!lang) {
        lang = [NSLocale preferredLanguages].firstObject;
    }
    return lang;
}

- (NSBundle *)enBundle {
    if (!_enBundle) {
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[DSTransaction class]];
        NSString *path = [frameworkBundle pathForResource:@"en" ofType:@"lproj"];
        _enBundle = [NSBundle bundleWithPath:path];
    }
    return _enBundle;
}

- (NSBundle *)zhBundle {
    if (!_zhBundle) {
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[DSTransaction class]];
        NSString *path = [frameworkBundle pathForResource:@"zh-Hans" ofType:@"lproj"];
        _zhBundle = [NSBundle bundleWithPath:path];
    }
    return _zhBundle;
}

- (NSString *)localizedStringForKey:(NSString *)key {
    NSString *str = [self.resourceBundle localizedStringForKey:key value:NULL table:NULL];
    if (!str) {
        str = @"";
    }
    if ([str isEqualToString:@"this payment address is already in your wallet"]) {
        if ([self.lang containsString:@"zh"]) {
            return @"该地址属于本钱包，无法转账";
        }
    }
    return str;
}

@end

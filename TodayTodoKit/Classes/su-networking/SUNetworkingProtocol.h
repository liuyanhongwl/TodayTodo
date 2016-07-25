//
//  SUNetworkingProtocol.h
//  Pods
//
//  Created by Hong on 16/2/26.
//
//

#import <Foundation/Foundation.h>

@protocol SUNetworkingProtocol <NSObject>

@required

@property (nonatomic, strong) NSString *urlHost;

@property (nonatomic, strong) NSString *aesKey;

@end

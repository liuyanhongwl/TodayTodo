//
//  NSData+AESEncryption.h
//  NSURLSession-test
//
//  Created by Hong on 15/12/2.
//  Copyright © 2015年 Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AESEncryption)

- (NSData *)AESEncryptWithKey:(NSString *)key;

- (NSData *)AESDecryptWithKey:(NSString *)key;

@end

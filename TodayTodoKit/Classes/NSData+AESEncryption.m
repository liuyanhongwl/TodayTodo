//
//  NSData+AESEncryption.m
//  NSURLSession-test
//
//  Created by Hong on 15/12/2.
//  Copyright © 2015年 Hong. All rights reserved.
//

#import "NSData+AESEncryption.h"
#import <CommonCrypto/CommonCryptor.h>


@implementation NSData (AESEncryption)

- (NSData *)AESEncryptWithKey:(NSString *)key
{
//    Byte keyPtr[16] = {48, -1, 44, 42, -87, -15, 3, 13, -10, -59, -57, -8, 91, -115, -67, 27};

    //获取真正的秘钥
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //输出十进制
//    const unsigned char *ptr = [keyData bytes];
//    for(int i=0; i<[keyData length]; ++i) {
//        Byte c = *ptr++;
//        NSLog(@"char=%c hex=%hhu", c, c);
//    }
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    char cIv[16];
    bzero(cIv, 16);
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [keyData bytes],
                                          kCCBlockSizeAES128,
                                          cIv,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

- (NSData *)AESDecryptWithKey:(NSString *)key
{
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
//    Byte keyPtr[16] = {48, -1, 44, 42, -87, -15, 3, 13, -10, -59, -57, -8, 91, -115, -67, 27};
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    
    char cIv[kCCBlockSizeAES128];
    bzero(cIv, kCCBlockSizeAES128);
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [keyData bytes],
                                          kCCBlockSizeAES128,
                                          cIv,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}


@end

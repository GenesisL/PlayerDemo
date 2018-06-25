//
//  FileMD5Tools.m
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/25.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import "FileMD5Tools.h"

#import <CoreFoundation/CoreFoundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <stddef.h>

#define FileHashDefaultChunkSizeForReadingData 256

@implementation FileMD5Tools

+ (NSString *)fileMD5StringByFilePath:(NSString *)path {
    return CFBridgingRelease(FileMD5HashCreateWithPath(CFBridgingRetain(path), 256));
}

#pragma mark - MD5 Compare
CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath, size_t chunkSizeForReadingData) {
    @autoreleasepool {
        // Declare needed variables
        CFStringRef result = NULL;
        CFReadStreamRef readStream = NULL;
        
        // Get the file URL
        CFURLRef fileURL =
        CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                      (CFStringRef)filePath,
                                      kCFURLPOSIXPathStyle,
                                      (Boolean)false);
        if (!fileURL) goto done;
        
        // Create and open the read stream
        readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                                (CFURLRef)fileURL);
        if (!readStream) goto done;
        bool didSucceed = (bool)CFReadStreamOpen(readStream);
        if (!didSucceed) goto done;
        
        // Initialize the hash object
        CC_MD5_CTX hashObject;
        CC_MD5_Init(&hashObject);
        
        // Make sure chunkSizeForReadingData is valid
        if (!chunkSizeForReadingData) {
            chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
        }
        
        // Feed the data to the hash object
        bool hasMoreData = true;
        while (hasMoreData) {
            uint8_t buffer[chunkSizeForReadingData];
            CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                      (UInt8 *)buffer,
                                                      (CFIndex)sizeof(buffer));
            if (readBytesCount == -1) break;
            if (readBytesCount == 0) {
                hasMoreData = false;
                continue;
            }
            CC_MD5_Update(&hashObject,
                          (const void *)buffer,
                          (CC_LONG)readBytesCount);
        }
        
        // Check if the read operation succeeded
        didSucceed = !hasMoreData;
        
        // Compute the hash digest
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5_Final(digest, &hashObject);
        
        // Abort if the read operation failed
        if (!didSucceed) goto done;
        
        // Compute the string result
        char hash[2 * sizeof(digest) + 1];
        for (size_t i = 0; i < sizeof(digest); ++i) {
            snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        }
        result = CFStringCreateWithCString(kCFAllocatorDefault,
                                           (const char *)hash,
                                           kCFStringEncodingUTF8);
    done:
        if (readStream) {
            CFReadStreamClose(readStream);
            CFRelease(readStream);
        }
        if (fileURL) {
            CFRelease(fileURL);
        }
        return result;
    }
}

@end

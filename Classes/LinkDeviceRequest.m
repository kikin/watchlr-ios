//
//  LinkDeviceRequest.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#include <CommonCrypto/CommonDigest.h>

#import "LinkDeviceRequest.h"


@implementation LinkDeviceRequest

static char base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

- (NSString *)newStringInBase64FromData:(NSData*)data
{
    NSMutableString *dest = [[NSMutableString alloc] initWithString:@""];
    unsigned char * working = (unsigned char *)[data bytes];
    int srcLen = [data length];
    
    // tackle the source in 3's as conveniently 4 Base64 nibbles fit into 3 bytes
    for (int i=0; i<srcLen; i += 3)
    {
        // for each output nibble
        for (int nib=0; nib<4; nib++)
        {
            // nibble:nib from char:byt
            int byt = (nib == 0)?0:nib-1;
            int ix = (nib+1)*2;
            
            if (i+byt >= srcLen) break;
            
            // extract the top bits of the nibble, if valid
            unsigned char curr = ((working[i+byt] << (8-ix)) & 0x3F);
            
            // extract the bottom bits of the nibble, if valid
            if (i+nib < srcLen) curr |= ((working[i+nib] >> ix) & 0x3F);
            
            [dest appendFormat:@"%c", base64[curr]];
        }
    }
    
    return dest;
}
- (NSString *)obfuscate:(NSString *)string withKey:(NSString *)key
{
    // Create data object from the string
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyD = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get pointer to data to obfuscate
    char *dataPtr = (char *) [data bytes];
    
    // Get pointer to key data
    char *keyData = (char *) [keyD bytes];
    
    // Points to each char in sequence in the key
    char *keyPtr = keyData;
    int keyIndex = 0;
    
    // For each character in data, xor with current value in key
    for (int x = 0; x < [data length]; x++) 
    {
        // Replace current character in data with 
        // current character xor'd with current key value.
        // Bump each pointer to the next character
        *dataPtr = *dataPtr++ ^ *keyPtr++; 
        
        // If at end of key data, reset count and 
        // set key pointer back to start of key value
        if (++keyIndex == [key length])
            keyIndex = 0, keyPtr = keyData;
    }
   
    return [self newStringInBase64FromData:data];
//    NSString* encryptedString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
//    return encryptedString;
}

NSString* md5Digest(const void *data, CC_LONG length)
{
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    unsigned char* d = CC_MD5(data, length, digest);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7], d[8], d[9], d[10], d[11], d[12], d[13], d[14], d[15],
            nil];
}

- (void) doLinkDeviceRequest:(NSString*)facebookId andAccessToken:(NSString*)facebookAccessToken {
	// build params list
	// NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	// [params setObject:facebookId forKey:@"id"];
    
	
	// do request	
//    NSString* requestUrl = [NSString stringWithUTF8String:"http://www.watchlr.com/api/auth/swap/"];
//    requestUrl = [requestUrl stringByAppendingString:facebookId];
    
    NSString* key = [NSString stringWithString:@"1020Amsterdam"];
    NSString* encryptedFacebookAccessToken = [self obfuscate:facebookAccessToken withKey:key];
    LOG_DEBUG(@"encryptedFacebookAccessToken:%@", encryptedFacebookAccessToken);
    NSString* reqUrl = [NSString stringWithFormat:@"http://www.watchlr.com/api/auth/swap?id=%@&token=%@&secret=%@", facebookId, encryptedFacebookAccessToken, key];
    LOG_DEBUG(@"reqUrl:%@", reqUrl);
    NSString* md5Checksum = md5Digest([reqUrl UTF8String], [reqUrl lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    LOG_DEBUG(@"md5Checksum:%@", md5Checksum);
    
    NSString* requestUrl = [NSString stringWithFormat:@"http://www.watchlr.com/api/auth/swap?id=%@&token=%@&checksum=%@", facebookId, encryptedFacebookAccessToken, md5Checksum];
    LOG_DEBUG(@"requestUrl:%@", requestUrl);
    [self doGetRequest:requestUrl params:nil];
	
	// release memory
	// [params release];
}

- (id) processReceivedString: (NSString*)receivedString {
	// let the base parse the json
	id jsonObject = [super processReceivedString:receivedString];
	
	// create the response
	LinkDeviceResponse* response = [[[LinkDeviceResponse alloc] initWithResponse:jsonObject] autorelease];
	
	return response;
}



@end

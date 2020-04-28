// ICNetworkingWrapper.h
// IngenicoConnectSDK
//
// Copyright (c) 2018 AFNetworking (http://afnetworking.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const ICURLResponseSerializationErrorDomain;
FOUNDATION_EXPORT NSString * const ICNetworkingTaskDidResumeNotification;
FOUNDATION_EXPORT NSString * const ICNetworkingTaskDidCompleteNotification;
FOUNDATION_EXPORT NSString * const ICNetworkingTaskDidSuspendNotification;
FOUNDATION_EXPORT NSString * const ICNetworkingTaskDidCompleteErrorKey;
FOUNDATION_EXPORT NSString * const ICNSURLSessionTaskDidResumeNotification;
FOUNDATION_EXPORT NSString * const ICNSURLSessionTaskDidSuspendNotification;
FOUNDATION_EXPORT NSString * const ICNetworkingTaskDidCompleteSerializedResponseKey;
FOUNDATION_EXPORT NSString * const ICNetworkingOperationFailingURLResponseErrorKey;
FOUNDATION_EXPORT NSString * const ICNetworkingOperationFailingURLResponseDataErrorKey;

@interface ICNetworkingWrapper : NSObject

- (void)getResponseForURL:(NSString *)URL headers:(NSDictionary *)headers additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)postResponseForURL:(NSString *)URL headers:(NSDictionary *)headers withParameters:(NSDictionary *)parameters additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end

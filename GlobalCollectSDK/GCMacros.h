//
//  GCMacros.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 16/04/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

//Debug log
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

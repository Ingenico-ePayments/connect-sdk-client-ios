//
//  GCValidationErrorLength.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 09/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCValidationError.h"

@interface GCValidationErrorLength : GCValidationError

@property (nonatomic) NSInteger minLength;
@property (nonatomic) NSInteger maxLength;

@end

//
//  GCFormRowList.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCFormRow.h"
#import "GCPickerView.h"

@interface GCFormRowList : GCFormRow

@property (strong, nonatomic) GCPickerView *pickerView;
@property (strong, nonatomic) NSDictionary *nameToIdentifierMapping;
@property (strong, nonatomic) NSDictionary *identifierToRowMapping;
@property (strong, nonatomic) NSString *paymentProductFieldIdentifier;
@property (nonatomic) NSInteger selectedRow;

@end

//
//  GCViewType.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#ifndef GlobalCollectDemo_GCViewType_h
#define GlobalCollectDemo_GCViewType_h

typedef enum {
    // Switches
    GCSwitchType,
    
    // PickerViews
    GCPickerViewType,
    
    // TextFields
    GCTextFieldType,
    GCIntegerTextFieldType,
    GCFractionalTextFieldType,

    // Buttons
    GCPrimaryButtonType,
    GCSecondaryButtonType,
    
    // Labels
    GCLabelType,

    // TableViewCells
    GCPaymentProductTableViewCellType,
    GCTextFieldTableViewCellType,
    GCCurrencyTableViewCellType,
    GCErrorMessageTableViewCellType,
    GCSwitchTableViewCellType,
    GCPickerViewTableViewCellType,
    GCButtonTableViewCellType,
    GCLabelTableViewCellType,
    GCTooltipTableViewCellType,
    
    // TableHeaderView
    GCSummaryTableHeaderViewType,
    
    //TableFooterView
    GCButtonsTableFooterViewType
} GCViewType;

#endif

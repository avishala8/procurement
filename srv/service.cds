using { PMS as db } from '../db/schema.cds';

service ProcurementService {
    // header entity
    @odata.draft.enabled
    entity PurchaseOrder as projection on db.PurchaseOrder;
}

// Annotations for the header
annotate ProcurementService.PurchaseOrder with @(
    UI:{
        HeaderInfo  : {
            TypeName : 'Purchase Order',
            TypeNamePlural : 'Purchase Orders',
            Title:{Value: PO_Number, Label:'PO Number'},
            Description:{Value: Description , Label:'PO Description'}
        },
        LineItem  : [
            {Value: PO_Number, Label:'PO Number'},
            {Value: Supplier, Label:'Supplier'},
            {Value: TotalAmount, Label:'Total Amount'},
            {Value: Status,Label: 'Status',Criticality: (
                        Status = 'Open'    ? 4 : // Positive (Green)
                        Status = 'Pending' ? 2 : // Critical (Orange/Yellow)
                        Status = 'Closed'  ? 5 : // Negative (Red)
                        Status = 'In Progress' ? 3 : 
                        Status = 'Cancelled' ? 1 : 0                     // Neutral (Grey)
                    )
                },
            {Value: Currency_code, Label:'Currency'}, // Displays the code in the table
        ],
        Facets  : [
            {
                $Type:'UI.ReferenceFacet',
                Label:'General Info',
                Target:'@UI.FieldGroup#Main'
            },
            {
                $Type:'UI.ReferenceFacet',
                Label:'Order Items',
                Target:'Items/@UI.LineItem',
            }
        ],
        FieldGroup #Main : {
            $Type : 'UI.FieldGroupType',
            Data:[
                {Value: PO_Number, Label:'PO Number'},
                {Value: Supplier, Label:'Supplier'},
                {Value: Description, Label:'Description'},
                {Value: Status, Label:'Order Status'},
                {Value: TotalAmount, Label:'Total Amount'},
                {Value: Currency_code, Label:'Currency'},
            ]
        },
    }
);

// Currency Value Help and Formatting Configuration

// Navigation Restrictions
annotate ProcurementService.PurchaseOrder with @(
    Capabilities.NavigationRestrictions : {
        RestrictedProperties : [
            {
                NavigationProperty : Items,
                Navigability : #None
            }
        ]
    }
);

// Annotations for the items
annotate ProcurementService.POItem with @(
    UI:{
        LineItem:[
            { Value: Product, Label:'Product' },
            { Value: Quantity, Label:'Quantity' },
            { Value: Price, Label:'Price' }
        ],
    }
);
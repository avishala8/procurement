namespace PMS;


using { managed,cuid, Currency } from '@sap/cds/common';

// header entity
entity StatusList {
    key StatusCode : String(20);
    StatusText     : String(50);
}

entity PurchaseOrder : cuid, managed{
    PO_Number: String(10);
    Description: String(255);
    Supplier: String(80);
    TotalAmount: Decimal(15,2);
    Currency: Currency;
    Status       : String(20) default 'Open';
    Items: Composition of many POItem on Items.Parent = $self;

}


// POItem entity
entity POItem : cuid {
    Parent: Association to PurchaseOrder;
    Product: String(100);
    Quantity: Integer;
    Price: Decimal(15,2);
    
}
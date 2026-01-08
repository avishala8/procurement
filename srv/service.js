const cds = require('@sap/cds');

module.exports = cds.service.impl(function () {

    const { PurchaseOrder } = this.entities;

    const POItem = cds.model.definitions['PMS.POItem'];

    this.before(['CREATE', 'UPDATE'], 'PurchaseOrder', async (req) => {
        const poId = req.data.ID;

        if (!poId) return;

        // Use SQL aggregation instead of fetching all rows
        const result = await SELECT.one.from(POItem)
            .columns(`sum(Quantity * Price) as total`)
            .where({ Parent_ID: poId });

        req.data.TotalAmount = result.total || 0;
        console.log(`TotalAmount updated for PO ${req.data.PO_Number}: ${req.data.TotalAmount}`);
    });


    this.after('SAVE', 'PurchaseOrder', async (data, req) => {
    // data contains the activated row(s)
    const poId = Array.isArray(data) ? data[0].ID : data?.ID;
    if (!poId) return;

    // Recalculate total from active table
    const result = await SELECT.one.from(POItem)
        .columns(`sum(Quantity * Price) as total`)
        .where({ Parent_ID: poId });

    await UPDATE(PurchaseOrder)
        .set({ TotalAmount: result.total || 0 })
        .where({ ID: poId });

    console.log(`TotalAmount finalized on SAVE for PO ${poId}: ${result.total || 0}`);
});


});
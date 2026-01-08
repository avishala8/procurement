sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"procurement/test/integration/pages/PurchaseOrderList",
	"procurement/test/integration/pages/PurchaseOrderObjectPage",
	"procurement/test/integration/pages/POItemObjectPage"
], function (JourneyRunner, PurchaseOrderList, PurchaseOrderObjectPage, POItemObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('procurement') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrderList: PurchaseOrderList,
			onThePurchaseOrderObjectPage: PurchaseOrderObjectPage,
			onThePOItemObjectPage: POItemObjectPage
        },
        async: true
    });

    return runner;
});


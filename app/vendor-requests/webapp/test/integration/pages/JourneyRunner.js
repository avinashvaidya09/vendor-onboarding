sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"vendorrequests/test/integration/pages/VendorRequestsList",
	"vendorrequests/test/integration/pages/VendorRequestsObjectPage"
], function (JourneyRunner, VendorRequestsList, VendorRequestsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('vendorrequests') + '/test/flp.html#app-preview',
        pages: {
			onTheVendorRequestsList: VendorRequestsList,
			onTheVendorRequestsObjectPage: VendorRequestsObjectPage
        },
        async: true
    });

    return runner;
});


sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'vendorrequests',
            componentId: 'VendorRequestsObjectPage',
            contextPath: '/VendorRequests'
        },
        CustomPageDefinitions
    );
});
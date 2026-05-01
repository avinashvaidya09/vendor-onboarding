sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension"
], function (ControllerExtension) {
    "use strict";

    return ControllerExtension.extend("vendorrequests.ext.controller.ListReportExt", {
        override: {
            onAfterRendering: function () {
                const oModel = this.base.getView().getModel();
                oModel.bindContext("/getCurrentUserInfo()").requestObject()
                    .then(function (oResult) {
                        if (oResult && oResult.isReviewer) {
                            const oButton = this.base.getView().byId("fe::table::VendorRequests::LineItem::StandardAction::Create");
                            if (oButton) {
                                oButton.setVisible(false);
                            }
                        }
                    }.bind(this))
                    .catch(function () {});
            }
        }
    });
});

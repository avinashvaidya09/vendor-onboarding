const cds = require('@sap/cds');

module.exports = class VendorService extends cds.ApplicationService {
  async init() {
    const { VendorRequests } = this.entities;

    this.before('CREATE', VendorRequests, (req) => {
      req.data.status      = 'ADMIN_REVIEW';
      req.data.requestedBy = req.user.id;
    });

    this.after('READ', VendorRequests, (results, req) => {
      const entries = Array.isArray(results) ? results : [results];
      const isReviewer = req.user.is('VendorReviewer');
      for (const entry of entries) {
        if (entry) entry.isReviewer = isReviewer;
      }
    });

    this.on('approveRequest', VendorRequests, async (req) => {
      const id = req.params[0].ID;
      const { comment } = req.data;

      const request = await SELECT.one(VendorRequests, id);
      if (!request) return req.error(404, 'Vendor request not found');
      if (request.status === 'APPROVED') return req.error(400, 'Already approved');
      if (request.status === 'REJECTED') return req.error(400, 'Already rejected');

      await UPDATE(VendorRequests, id).with({
        status          : 'APPROVED',
        reviewerComment : comment,
        reviewedBy      : req.user.id,
        reviewedAt      : new Date()
      });
      return SELECT.one(VendorRequests, id);
    });

    this.on('rejectRequest', VendorRequests, async (req) => {
      const id = req.params[0].ID;
      const { comment } = req.data;

      const request = await SELECT.one(VendorRequests, id);
      if (!request) return req.error(404, 'Vendor request not found');
      if (request.status === 'APPROVED') return req.error(400, 'Already approved');
      if (request.status === 'REJECTED') return req.error(400, 'Already rejected');

      await UPDATE(VendorRequests, id).with({
        status          : 'REJECTED',
        reviewerComment : comment,
        reviewedBy      : req.user.id,
        reviewedAt      : new Date()
      });
      return SELECT.one(VendorRequests, id);
    });

    return super.init();
  }
};

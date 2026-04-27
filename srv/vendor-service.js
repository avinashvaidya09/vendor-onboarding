const cds = require('@sap/cds');

module.exports = class VendorService extends cds.ApplicationService {
  async init() {
    const { VendorRequests } = this.entities;

    this.on('approve', VendorRequests, async (req) => {
      console.log('[approve] called', req.params, req.data);
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
    });

    this.on('reject', VendorRequests, async (req) => {
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
    });

    return super.init();
  }
};

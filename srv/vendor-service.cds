using { vendoronboarding as db } from '../db/schema';

@path: 'vendor-service'
service VendorService {
  entity VendorRequests as projection on db.VendorRequests {
    *,
    case status
      when 'APPROVED'     then 3
      when 'REJECTED'     then 1
      when 'ADMIN_REVIEW' then 2
      else                     0
    end as statusCriticality : Integer
  } actions {
    action approveRequest(comment : String(500)) returns VendorRequests;
    action rejectRequest(comment  : String(500)) returns VendorRequests;
  };
}

annotate VendorService.VendorRequests with {
  status            @readonly;
  reviewedBy        @readonly;
  reviewedAt        @readonly;
  reviewerComment   @readonly;
  statusCriticality @readonly @UI.Hidden;
};

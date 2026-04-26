using { vendoronboarding as db } from '../db/schema';

@path: 'vendor-service'
service VendorService {
  entity VendorRequests as projection on db.VendorRequests;
}

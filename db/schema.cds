namespace vendoronboarding;

using { cuid, managed } from '@sap/cds/common';

type VendorStatus : String enum {
  NEW;
  APPROVED;
  REJECTED;
  ADMIN_REVIEW;
}

entity VendorRequests : cuid, managed {
  vendorName         : String(100);
  vendorType         : String(50);
  country            : String(50);
  city               : String(50);
  category           : String(50);
  contactPerson      : String(100);
  contactEmail       : String(255);
  contactPhone       : String(50);
  taxId              : String(50);
  vatNumber          : String(50);
  registrationNumber : String(50);
  taxCountry         : String(50);
  status             : VendorStatus default 'NEW';
  reviewerComment    : String(500);
  requestedBy        : String(100);
  reviewedBy         : String(100);
  reviewedAt         : DateTime;
}

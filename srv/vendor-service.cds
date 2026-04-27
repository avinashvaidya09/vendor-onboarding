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
    action approve();
    action reject();
  };
}

annotate VendorService.VendorRequests with {
  status            @readonly;
  reviewedBy        @readonly;
  reviewedAt        @readonly;
  reviewerComment   @readonly;
  statusCriticality @readonly @UI.Hidden;
};

annotate VendorService.VendorRequests with @(

  UI.Identification: [
    { $Type: 'UI.DataFieldForAction', Action: 'VendorService.VendorRequests/approve', Label: 'Approve' },
    { $Type: 'UI.DataFieldForAction', Action: 'VendorService.VendorRequests/reject',  Label: 'Reject'  }
  ],

  UI.HeaderInfo: {
    TypeName       : 'Vendor Request',
    TypeNamePlural : 'Vendor Requests',
    Title          : { Value: vendorName },
    Description    : { Value: vendorType }
  },

  UI.SelectionFields: [ status, country ],

  UI.LineItem: [
    { Value: vendorName,   Label: 'Vendor Name'   },
    { Value: vendorType,   Label: 'Vendor Type'   },
    { Value: country,      Label: 'Country'       },
    { Value: category,     Label: 'Category'      },
    { Value: status,       Label: 'Status',       Criticality: statusCriticality },
    { Value: requestedBy,  Label: 'Requested By'  }
  ],

  UI.FieldGroup #VendorInfo: {
    Label: 'Vendor Information',
    Data : [
      { Value: vendorName,  Label: 'Vendor Name'  },
      { Value: vendorType,  Label: 'Vendor Type'  },
      { Value: country,     Label: 'Country'      },
      { Value: city,        Label: 'City'         },
      { Value: category,    Label: 'Category'     }
    ]
  },

  UI.FieldGroup #ContactInfo: {
    Label: 'Contact Information',
    Data : [
      { Value: contactPerson, Label: 'Contact Person' },
      { Value: contactEmail,  Label: 'Email'          },
      { Value: contactPhone,  Label: 'Phone'          }
    ]
  },

  UI.FieldGroup #TaxInfo: {
    Label: 'Tax & Registration',
    Data : [
      { Value: taxId,              Label: 'Tax ID'              },
      { Value: vatNumber,          Label: 'VAT Number'          },
      { Value: registrationNumber, Label: 'Registration Number' },
      { Value: taxCountry,         Label: 'Tax Country'         }
    ]
  },

  UI.FieldGroup #ReviewInfo: {
    Label: 'Review Information',
    Data : [
      { Value: status,          Label: 'Status'           },
      { Value: requestedBy,     Label: 'Requested By'     },
      { Value: reviewedBy,      Label: 'Reviewed By'      },
      { Value: reviewedAt,      Label: 'Reviewed At'      },
      { Value: reviewerComment, Label: 'Reviewer Comment' }
    ]
  },

  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'VendorInfo',
      Label : 'Vendor Information',
      Target: '@UI.FieldGroup#VendorInfo'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'ContactInfo',
      Label : 'Contact Information',
      Target: '@UI.FieldGroup#ContactInfo'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'TaxInfo',
      Label : 'Tax & Registration',
      Target: '@UI.FieldGroup#TaxInfo'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'ReviewInfo',
      Label : 'Review Information',
      Target: '@UI.FieldGroup#ReviewInfo'
    }
  ]

);

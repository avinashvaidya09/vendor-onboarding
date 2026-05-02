using {vendoronboarding as db} from '../db/schema';

@path    : 'vendor-service'
@requires: 'authenticated-user'
service VendorService {
  @odata.draft.enabled
  @restrict      : [
    {
      grant: [
        'READ',
        'CREATE'
      ],
      to   : 'VendorRequester',
      where: 'requestedBy = $user'
    },
    {
      grant: [
        'READ',
        'UPDATE',
        'DELETE'
      ],
      to   : 'VendorReviewer'
    }
  ]
  @ams.attributes: {country: (country)}
  entity VendorRequests as
    projection on db.VendorRequests {
      *,
      virtual statusCriticality : Integer,
      virtual isReviewer        : Boolean
    }
    actions {
      @restrict               : [{
        grant: 'INVOKE',
        to   : 'VendorReviewer'
      }]
      @Core.OperationAvailable: isReviewer
      action approveRequest(comment: String(500)) returns VendorRequests;

      @restrict               : [{
        grant: 'INVOKE',
        to   : 'VendorReviewer'
      }]
      @Core.OperationAvailable: isReviewer
      action rejectRequest(comment: String(500))  returns VendorRequests;
    };

  function getCurrentUserInfo() returns {
    isReviewer  : Boolean;
    isRequester : Boolean;
  };
}

annotate VendorService.VendorRequests with {
  status             @readonly;
  reviewedBy         @readonly;
  reviewedAt         @readonly;
  reviewerComment    @readonly;
  statusCriticality  @readonly  @UI.Hidden;
  isReviewer         @readonly;
};

annotate VendorService.VendorRequests with @(Capabilities.DeleteRestrictions: {Deletable: isReviewer});

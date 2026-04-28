# Vendor Onboarding — CAP Learning Project

A hands-on project to learn SAP CAP development, Fiori Elements UI patterns, and (later) IAS + AMS authorization.

---

## What This Project Does

A simple Vendor Request management app where:
- **Requesters** create and view vendor onboarding requests
- **Reviewers** approve or reject requests with comments
- Role-based visibility: action buttons are disabled for non-reviewers

---

## Project Structure

| Folder / File | Purpose |
|---|---|
| `db/schema.cds` | Domain model — `VendorRequests` entity with enum status |
| `srv/vendor-service.cds` | OData service, actions, readonly/auth annotations |
| `srv/vendor-service.js` | CAP handlers — before CREATE, after READ, approve, reject |
| `app/vendor-requests/annotations.cds` | All Fiori Elements UI annotations (separate from srv layer) |
| `app/vendor-requests/webapp/` | Fiori Elements app (List Report + Object Page) |
| `db/data/` | CSV seed data auto-loaded by `cds watch` |
| `package.json` | Project config including mock auth for development |

---

## Running Locally

```bash
npm install
cds watch
```

Open: `http://localhost:4004/vendor-requests/webapp/index.html`

Login with mock users:
| User | Password | Role |
|---|---|---|
| alice | alice | VendorRequester |
| bob | bob | VendorReviewer |

---

## What Was Built — Step by Step

### 1. CAP Project Scaffold
- `cds init` + `cds add sqlite`
- Single flat entity `VendorRequests` using `cuid` (UUID key) and `managed` (audit fields)
- `VendorStatus` enum type: `NEW`, `APPROVED`, `REJECTED`, `ADMIN_REVIEW`
- CSV seed data auto-loaded at startup

### 2. OData Service
- Single `VendorService` exposing `VendorRequests` as an OData v4 projection
- Computed field `statusCriticality` (integer) drives colored status badges in the UI
- Service path set via `@path: 'vendor-service'`

### 3. Fiori Elements UI
- Fiori Elements app created via SAP Fiori Application Generator (not `cds add fiori`)
- **Key learning:** UI annotations go in `app/vendor-requests/annotations.cds`, not in `srv/` — clean separation between service layer and UI layer
- List Report with filter bar (`@UI.SelectionFields`), table columns (`@UI.LineItem`), and status criticality coloring
- Object Page with four sections via `@UI.FieldGroup` + `@UI.Facets`: Vendor Info, Contact Info, Tax & Registration, Review Info
- `@UI.HeaderInfo` drives the Object Page title and subtitle

### 4. Approve / Reject Actions
- Two bound CAP actions: `approveRequest` and `rejectRequest`, each taking a `comment` parameter
- **Key learning:** `reject` is a reserved method in CAP's `ApplicationService` base class — always use a custom name
- **Key learning:** In Fiori Elements OData v4, bound actions in annotations use `ServiceName.ActionName` format, not `ServiceName.EntityName/ActionName`
- Actions return the updated `VendorRequests` entity — Fiori Elements automatically refreshes the Object Page with the returned data (no `@Common.SideEffects` needed)
- Action buttons placed via `@UI.Identification` on the Object Page header toolbar

### 5. Draft-Enabled Create Flow
- `@odata.draft.enabled` on the entity activates the Create button (List Report) and Edit button (Object Page)
- `before('CREATE')` handler auto-sets `status = 'ADMIN_REVIEW'` and `requestedBy = req.user.id` when a new request is saved

### 6. Mock Authentication and Role-Based Authorization
- Mock users defined under `[development]` profile in `package.json` — only active during `cds watch`, ignored in production
- `@requires: 'authenticated-user'` on the service forces login when the app loads
- `@restrict: [{ grant: 'INVOKE', to: 'VendorReviewer' }]` on actions — server-side enforcement
- `virtual isReviewer : Boolean` computed field populated in `after('READ')` handler using `req.user.is('VendorReviewer')`
- `@Core.OperationAvailable: isReviewer` on actions — disables Approve/Reject buttons for non-reviewers
- `@Capabilities.DeleteRestrictions: { Deletable: isReviewer }` — disables Delete for non-reviewers
- Review fields (`status`, `reviewedBy`, `reviewedAt`, `reviewerComment`) marked `@readonly` — non-editable in the form

---

## Key Learnings

| Topic | Learning |
|---|---|
| CDS enums | `type VendorStatus : String enum { ... }` — advisory at CDS level, not DB enforced |
| Bound action naming | Avoid CAP reserved names (`reject`, `create`, etc.) |
| Fiori annotation format | Action reference in `@UI.DataFieldForAction` uses `ServiceName.ActionName` |
| Action result refresh | Return the entity from the action handler — Fiori Elements auto-refreshes |
| Draft | `@odata.draft.enabled` is required for Create/Edit flows in Fiori Elements OData v4 |
| Virtual fields | Use `virtual` for computed non-persisted fields; populate in `after('READ')` |
| Role-based UI | `@Core.OperationAvailable` + virtual field is the pattern for dynamic button state |
| Layer separation | UI annotations belong in `app/`, not `srv/` |
| Mock auth profile | Use `[development]` profile to scope mock config away from production |

---

## Roadmap

| Phase | Status |
|---|---|
| Phase 1: Basic CAP app + OData | Done |
| Phase 2: Fiori Elements UI + Actions | Done |
| Phase 3: Standalone App Router | Pending |
| Phase 4: MTA deployment descriptor | Pending |
| Phase 5: IAS authentication | Pending |
| Phase 6: AMS authorization policies | Pending |
| Phase 7: Deploy to BTP Cloud Foundry | Pending |

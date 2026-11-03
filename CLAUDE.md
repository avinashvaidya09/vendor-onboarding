# Project guidance

## Overview

Vendor onboarding learning project built with SAP CAP 9 (Node.js/CommonJS), CDS, and a JavaScript SAP Fiori Elements OData V4 List Report/Object Page app. Local development uses SQLite and mocked users; production uses SAP HANA, IAS authentication, and AMS authorization on SAP BTP Cloud Foundry.

Read `README.md` for the implementation walkthrough. Treat the source files as authoritative.

## Commands

Run from the repository root unless stated otherwise. The root uses npm workspaces for `app/*`.

```bash
npm ci
npx cds watch
```

Open `http://localhost:4004/vendor-requests/webapp/index.html`. The OData service is at `/odata/v4/vendor-service/`.

```bash
npm run build:ui      # UI5 build into app/vendor-requests/dist/
npm run copy:ui       # Replace app/router/resources/vendor-requests/ with built UI
npm run start:router  # Port 5001; requires local destination/auth configuration
npx cds build --production
```

## MCP tools

See the README's MCP setup section for the CAP, Fiori, and UI5 development servers.

- When available, use CAP `search_model` to inspect CDS definitions and `search_docs` before changing models or using CAP APIs/CLI.
- For UI5 work, retrieve `get_guidelines` and use project/API information appropriate to the app's UI5 version.
- Use Fiori tools for supported Fiori Elements configuration and annotation changes. Inspect the result and validate it against the existing app.
- If a server is unavailable, state that limitation and use local source plus official documentation.

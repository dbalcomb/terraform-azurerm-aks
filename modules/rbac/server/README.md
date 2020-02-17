# Role-Based Access Control (RBAC) Server Component

This module configures the Role-Based Access Control (RBAC) server component
that handles identity requests for Azure Active Directory (AAD) users.

## Notes

- The app registration resource created by this module requires permissions that
  can only be granted by a tenant administrator. This means that the first run
  will fail until consent is granted to the application.

## References

- [AAD Server Component](https://docs.microsoft.com/en-gb/azure/aks/azure-ad-integration-cli#create-azure-ad-server-component)

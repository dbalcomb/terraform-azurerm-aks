# Role-Based Access Control (RBAC) Group

This module configures the Role-Based Access Control (RBAC) group that can be
passed to the *cluster* module to manage user authentication and permissions.

## Notes

- Group membership is controlled via Azure Active Directory (AAD) user principal
  names. Depending on the setup this name may not be the same as the user email
  address. In the case of a Microsoft Account this will likely be different.

## References

- [Cluster RBAC](https://docs.microsoft.com/en-gb/azure/aks/azure-ad-rbac)

# Algosec CloudFlow's automatic onboarding
Using this sollution allows visibility to your project(s) on Algosec CloudFlow.

To be able to run this solution login to GCP as a user with the following permissions:
- [ ] **Organization Role Administrator** or **Role Administrator**
- [ ] **Organization Policy Administrator**

# Module contents
This module enables the required APIs and grant the relevant permissions to allow as to have visibility into your Google Project(s).

As a result of the execution the following resources would be created:
- [ ] ***CloudFlow-Onbording*** project under organization's root or specified folder
- [ ] ***cloudflow*** service account in the created CloudFlow-Onboarding project with the generated access key
- [ ] ***CloudFlow Role*** - the custom role under organization's account

# Installation
To use the solution run
```shell
terraform init && terraform apply
```
The process will ask for *billing account id*, *organization's id*, and *folder*(optional) where to create CloudFlow-Onboarding project

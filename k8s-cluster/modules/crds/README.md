## CRD Module

To manage deployment of CRDs separate from the controller so that deployments that refer to the CRDs goes through without issues. The controllers backing the CRDs can be deployed later respecting any dependencies between them.
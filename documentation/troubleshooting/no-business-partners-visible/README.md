# You Do Not See Any Business Partners (Franchisee)

In case you do not see any business partners (franchisees) in the UI, one of the following steps might help you to identify the problem.


## 1. Issue is Happening Locally

  * Recheck your local setup.
    * What did you configure in the file `hiddenconfig.properties`?
    * Did you start all needed services? Check their logs. See section [Test the EasyFranchise Application Locally](../../../documentation/prepare/test-app-locally/README.md) for more details.
  * Execute the following curl command. This should return a `200 ok` and a list of franchisee. Check result and log.
    ```
    curl --verbose -X GET http://localhost:8080/easyfranchise/rest/efservice/v1/franchisee`
    ```
  * Execute the following curl command. This should return a `200 ok` and a list bupas.
    ```
    curl --verbose --request GET 'http://<localhost:8100>/easyfranchise/rest/bpservice/v1/<tenantid>/bupa'
    ```

## 2. Issue is Happening Locally or in Kyma

* Check what the SAP S/4HANA Cloud system or the Mock returns. This is the according get request:

  ```
  https://<your used S/4HANA Cloud system>/sap/opu/odata/sap/API_BUSINESS_PARTNER/A_BusinessPartner?$filter=BusinessPartnerCategory eq '2' &$expand=to_BusinessPartnerAddress/to_EmailAddress
  ```
# azure_data_warehouse

## Introduction
Divvy is a bike sharing program in Chicago that allows riders to purchase a pass at a kiosk or through a mobile application. The city of Chicago makes the anonymized bike trip data publicly available for data engineering projects. The data is stored in `data` folder. The folder contains the following files:
* payments.csv: This file contains 1,946,607 rows of payments data
* riders.csv: This file contains 75,000 rows of riders data
* stations.csv: This file contains 838 rows of stations data
* trips.csv: The file contains 4,584,921 rows of trips data


## Project Goal 
The goal of this project is to develop a data warehouse using Azure synapse analytics. I will do the following for the project:
1. Deploy Azure resources needed to build the datawarehouse with terraform 
2. Design a star schema based on the business outcomes
3. Import data from the CSV files to Azure postgres sql
4. Ingest the data from Azure postgres sql to Azure synapse using blob storage
5. Finally transform the data into the star schema

The business outcomes I'm designing for are as follows:
1. How much time is spent per ride based on the following factors:
    * Time factors such as day of the week and time of day
    * Which stationis the starting and or ending station 
    * Age of the rider at the time of the ride
    * Whether the rider is a member or a casual rider
2. How much money is spent per month, quarter, year and per member based on the age of the rider at account start?

## Deploy Azure resources with Terraform
The terraform code is stored in `main.tf` and when you run `terraform apply` it provisions the following resources:
* resource group in south central US
* azure postgres flexible server
* azure postgres flexible server firewall rule to allow access to the databases in the firewall
* azure blob storage account
* azure datalake gen2 filesystem
* azure synapse workspace
* azure synapse firewall rule to allow access to azure synapse workspace
* dedicated sql pool in the azure synapse workspace
* linked service that links the blob storage to azure synapse
* linked service that links the postgres sql server to azure synapse

## Star Schema for Divvy Bikeshare Dataset
![Star Schema](/assets/image.png)

## How to run the code
1. Ensure you have Azure CLI configured, give proper permissions to terraform to create Azure resources. Finally ensure that the user role has appropriate IAM permissions for the subscription. This is really important for creating additional resources for example creating firewall rules and datalake gen 2 filesystem in azure storage account.
2. Run `terraform init` to initialize terraform, then run `terraform apply` to provision the resources. 
3. Run `create_tables.py` to create 4 tables: rider, payment, station and trip. This also reads the data from the four csv files and loads them into azure postgres sql. 
4. Through the Azure portal assign the Storage Blob Data Contributor role on the specified Data Lake Storage Gen2 account to both the workspace managed identity and the current user.
5. From Azure portal, navigate to azure synapse studio. Then copy the 4 tables from postgres sql to azure blob storage using the blob and postgres linked services. The data should be stored as a csv file in azure blob.
![Copy Pipeline](/assets/copy.png)
6. Next create staging tables in Azure synapse for the load stage of the ELT process. Azure Synapse automatically generates sql scripts for this or copy and paste the scripts from the `staging.sql` file. There should be 4 staging tables in the external tables pane.
7. Navigate to the develop tab to perform the transform stage. Copy and paste the script I wrote from the `etl.sql` file to the new sql script in the develop tab and run the scrip to create the transformed tables with the star schema.
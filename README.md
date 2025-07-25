# AWS Redshift Data Pipeline – Automated ETL with Step Functions & S3

## 📌 Project Overview
This project demonstrates a **fully automated, end-to-end data pipeline** using **AWS Redshift**, **AWS Lambda**, **Step Functions**, and **Amazon S3**. The pipeline ingests raw files from an S3 bucket, processes and aggregates the data in Redshift using Spectrum and stored procedures, and manages data archival with success/failure notifications.

---

## 🚀 Architecture Workflow
1. **Raw File Upload**  
   - A new raw file is uploaded to an **S3 bucket**.

2. **Event-Driven Trigger**  
   - An **S3 event notification** triggers a **Lambda function**.

3. **State Machine Orchestration**  
   - The Lambda function starts an **AWS Step Function** execution.

4. **Data Processing (ETL)**  
   - The Step Function calls a **stored procedure** in **Amazon Redshift**:
     - Creates an **external schema** in **Redshift Spectrum** using a Glue Data Catalog table over the raw S3 data.
     - Creates an aggregated data table in Redshift.
     - Loads aggregated data into the Redshift table via `INSERT` statements.

5. **Data Archival**  
   - Upon successful load, the raw S3 file is moved to an **`archive/` folder** and deleted from the original location.

6. **Notifications**  
   - **SNS Notifications** are sent:
     - **Success:** To the business team.
     - **Failure:** To the support team.

7. **Security & Monitoring**  
   - **AWS Secrets Manager** stores Redshift credentials.
   - **CloudWatch Logs** provide monitoring and debugging.

---

## 🏗️ Architecture Diagram
<img width="650" height="459" alt="image" src="https://github.com/user-attachments/assets/46542cd0-492f-4d93-a644-2ccd346728ad" />

The architecture involves:
- **Amazon S3** (raw + archive buckets)
- **AWS Lambda**
- **AWS Step Functions**
- **Amazon Redshift Spectrum**
- **AWS Glue Data Catalog**
- **SNS Notifications**
- **CloudWatch & Secrets Manager**

---

## 🔑 Key Features
- **Event-driven pipeline**: Fully automated using S3 event notifications.
- **Serverless orchestration**: Step Functions coordinate ETL steps.
- **Redshift Spectrum integration**: Efficiently queries S3 data without full ingestion.
- **Secure credential management** with AWS Secrets Manager.
- **Robust logging** and monitoring with CloudWatch.
- **End-to-end notifications** via SNS for success/failure.

---

## ⚙️ Tech Stack
- **AWS S3** – Storage for raw and archived data.
- **AWS Lambda** – Event trigger for Step Functions.
- **AWS Step Functions** – ETL workflow orchestration.
- **Amazon Redshift** – Data warehouse for aggregated results.
- **AWS Glue** – Catalog table for Spectrum.
- **AWS SNS** – Notifications.
- **AWS Secrets Manager** – Credential storage.
- **CloudWatch** – Logging and monitoring.

---

## 📂 Repository Structure

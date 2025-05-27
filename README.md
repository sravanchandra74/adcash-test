# ⚙️ Adcash Monitoring Test: Flask App on EKS with Prometheus

This project gives you a full DevOps pipeline! We're deploying a simple **Flask web application** on **AWS EKS** (Amazon Elastic Kubernetes Service) and then monitoring it effectively with **Prometheus**, which runs on a dedicated **EC2 instance**. Our Flask app is designed to track and expose metrics, specifically counting requests to its `/gandalf` and `/colombo` endpoints.


---

## 🚀 Get Started

Before you dive in, make sure you have a few things ready on your **local machine**:

* **AWS CLI configured:** You need to be able to interact with your AWS account.
* **Terraform installed:** This is how we'll provision all the cloud infrastructure.

---

## 📁 Project Layout

Here's how the project is organized. This structure helps keep everything tidy and easy to navigate:

/adcash-test
├── ansible/                  # Ansible playbooks for server setup and application deployment
│ ├── ansible.cfg
│ ├── playbook.yml
│ └── deploy-gandalf-colombo/ # Ansible role for Flask app and Prometheus setup
│     ├── defaults/main.yml
│     ├── files/
│     │ ├── app.py
│     │ ├── Dockerfile
│     │ ├── gandalf.jpg
│     │ └── requirements.txt
│     ├── handlers/main.yml
│     ├── meta/main.yml
│     ├── tasks/main.yml
│     ├── templates/prometheus.yml.j2
│     └── vars/main.yml
├── terraform/                # Terraform configurations for AWS infrastructure
│ ├── ec2.tf
│ ├── eks.tf
│ ├── ecr.tf
│ ├── iam.tf
│ ├── network.tf
│ ├── outputs.tf
│ ├── providers.tf
│ ├── variables.tf
│ └── main.tf
└── run.sh                    # Interactive script to run the project

---

## ✅ What This Project Does

This project automates several key steps to get your Flask application up and running, complete with monitoring:

* **Provisions AWS Infrastructure using Terraform:**
    * Sets up an **EC2 instance** dedicated to running Prometheus.
    * Deploys an **EKS cluster** for hosting our Flask application.
    * Configures **ECR** (Elastic Container Registry) for storing Docker images (this part is optional, but good practice!).
    * Creates all the necessary **IAM roles, VPC, subnets, and security groups** to ensure secure and proper communication.

* **Automates Setup using Ansible:**
    * **Installs Prometheus** directly on the EC2 instance (not via Docker).
    * **Installs Docker** for container management.
    * **Builds and pushes** the Flask app's Docker image.
    * **Deploys the Flask app** to the EKS cluster.
    * **Configures Prometheus** to automatically scrape metrics from our Flask application.

The Flask app itself is pretty simple: it exposes **metrics** through a dedicated `/metrics` endpoint and tracks requests to `/gandalf` (which serves an image) and `/colombo` (which displays the current time in Colombo).

---

## 🚀 How to Run It

Ready to see it in action? Follow these simple steps:

### 1️⃣ Clone the Repository

First, get the code onto your machine:

```bash
git clone <repo-url> # Replace <repo-url> with repository's URL
cd adcash-test

2️⃣ Run the Interactive Script
This script makes it easy to manage the project's lifecycle:

```bash
sh run.sh

You'll then see a menu with these options:

| Option | Description                                               |
| :----- | :-------------------------------------------------------- |
| `1`    | Provisions infrastructure using Terraform and deploys the app using Ansible. |
| `2`    | Destroys all infrastructure provisioned by Terraform.     |
| `3`    | Exits the interface.                                      |

---

🌍 Accessing the App (via EKS Load Balancer)
Once your application is deployed on EKS, it'll be accessible via an AWS Application Load Balancer. You can reach the following endpoints:

| Endpoint     | Description                                |
| :----------- | :----------------------------------------- |
| `/gandalf`   | Serves a Gandalf image and counts requests. |
| `/colombo`   | Displays the current time in Colombo and counts requests. |
| `/metrics`   | The Prometheus-compatible metrics endpoint. |

Just replace <EKS-ALB-DNS> with the actual DNS name of your EKS Load Balancer:
![image](https://github.com/user-attachments/assets/87edae1b-8279-426f-bf49-60023fc4abe2)

http://<EKS-ALB-DNS>/gandalf
![image](https://github.com/user-attachments/assets/2cbbdabf-f1d1-46d5-9f0e-4a47600edb33)

http://<EKS-ALB-DNS>/colombo
![image](https://github.com/user-attachments/assets/cb1adf67-9d8f-477b-9d6e-903aad65ef9e)

http://<EKS-ALB-DNS>/metrics
![image](https://github.com/user-attachments/assets/21e4399c-2eb3-4276-bf8c-68cc54e3e73a)

---

## 📊 Prometheus Monitoring

As mentioned, Prometheus is installed directly on your dedicated EC2 instance.

To access the Prometheus UI, simply navigate to:

`http://<EC2-Public-IP>:9090`
![image](https://github.com/user-attachments/assets/ca581bd5-3d00-43c9-8fde-21981a28ce50)
![image](https://github.com/user-attachments/assets/756bbb28-3381-4aaa-8692-94e16ab52772)

You can then query these specific metrics to see your application's performance:

* `app_requests_gandalf_total`
![image](https://github.com/user-attachments/assets/258881d0-3878-465b-a368-e0e0faa135b8)
![image](https://github.com/user-attachments/assets/7adddcd0-35df-4ddb-b3a0-9e21ef6bd5a2)

* `app_requests_colombo_total`
![image](https://github.com/user-attachments/assets/3e43f88a-b946-492b-8de4-7acee786e6e9)
![image](https://github.com/user-attachments/assets/6ac72848-afae-49c0-9c03-49ce885429bc)

---

## Author
- Shravan Chandra Parikipandla

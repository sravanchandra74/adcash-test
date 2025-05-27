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
![image](https://github.com/user-attachments/assets/0d6b5caf-c8d5-474c-aefc-4944d1c47138)

http://<EKS-ALB-DNS>/gandalf
![image](https://github.com/user-attachments/assets/53070b91-7f96-4f29-bdf5-dcbca8a16feb)

http://<EKS-ALB-DNS>/colombo
![image](https://github.com/user-attachments/assets/e83147c0-326a-4d0d-8d56-dcb644d178d7)

http://<EKS-ALB-DNS>/metrics
![image](https://github.com/user-attachments/assets/cec82a30-3f55-4eaf-84dc-9a71d76384ae)

---

## 📊 Prometheus Monitoring

As mentioned, Prometheus is installed directly on your dedicated EC2 instance.

To access the Prometheus UI, simply navigate to:

`http://<EC2-Public-IP>:9090`
![image](https://github.com/user-attachments/assets/be2ac955-4a45-4953-977f-f85c545174e0)
![image](https://github.com/user-attachments/assets/2bf6f527-baeb-4836-aae0-6895442a4f83)

You can then query these specific metrics to see your application's performance:

* `app_requests_gandalf_total`
![image](https://github.com/user-attachments/assets/0a35a8b9-145a-4ed6-9e07-8ca550ae5976)
![image](https://github.com/user-attachments/assets/229c8e2a-5f74-4ddf-9b6b-ef96d2365b24)

* `app_requests_colombo_total`
![image](https://github.com/user-attachments/assets/a9b5d77b-828c-4d58-9df4-c961f6c6bb80)
![image](https://github.com/user-attachments/assets/15e53118-4e11-4e69-900c-d129e5b15b3b)

---

## Author
- Shravan Chandra Parikipandla

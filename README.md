# Capstone 1 – Voting Application on Amazon EKS

## Project Overview

This project demonstrates the deployment of a distributed Voting Application on **Amazon Elastic Kubernetes Service (EKS)** using Kubernetes and Helm.

The application consists of multiple services running in containers and communicating with one another to collect votes and display voting results.

The project uses a custom Helm chart to manage Kubernetes resources and simplify application deployment, upgrades, and rollbacks.

## Application Architecture

The application consists of the following components:

- **Vote:** A Python web application that allows users to vote between two options.
- **Redis:** Receives and temporarily stores votes as messages.
- **Worker:** A .NET application that processes votes from Redis and stores them in PostgreSQL.
- **PostgreSQL:** Stores the voting results.
- **Result:** A Node.js web application that displays voting results in real time.

## Technologies Used

- Docker – Containerization
- Kubernetes – Container orchestration
- Amazon EKS – Managed Kubernetes service
- Helm – Kubernetes package management
- Redis – Message queue
- PostgreSQL – Database
- Python – Voting frontend
- Node.js – Results frontend
- .NET – Background worker
- AWS CLI – AWS resource management
- kubectl – Kubernetes cluster management

## Project Structure

```text
devops_capstone1/
│
├── helm/
│   └── voting-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── _helpers.tpl
│           ├── db-deployment.yaml
│           ├── db-service.yaml
│           ├── redis-deployment.yaml
│           ├── redis-service.yaml
│           ├── vote-deployment.yaml
│           ├── vote-service.yaml
│           ├── result-deployment.yaml
│           ├── result-service.yaml
│           └── worker-deployment.yaml
│
└── k8s-specifications/
    └── Kubernetes YAML manifests
```

## Amazon EKS Configuration

The Kubernetes cluster was deployed on Amazon EKS.

| Configuration | Value |
|---|---|
| Cluster name | voting-app-cluster |
| AWS Region | eu-north-1 |
| Kubernetes version | 1.31 |
| Node group | 2 worker nodes |
| Helm release | voting-app |
| Kubernetes namespace | default |

## Getting Started

### Prerequisites

Install and configure the following tools:

- AWS CLI
- kubectl
- Helm
- An AWS account with the required permissions

### 1. Configure Kubernetes Access

Connect kubectl to the EKS cluster:

```bash
aws eks update-kubeconfig \
  --region eu-north-1 \
  --name voting-app-cluster
```

Verify the connection:

```bash
kubectl get nodes
```

### 2. Validate the Helm Chart

Navigate to the project directory and validate the chart:

```bash
helm lint ./helm/voting-app
```

### 3. Deploy the Application

Install the application using Helm:

```bash
helm upgrade --install voting-app ./helm/voting-app
```

### 4. Verify the Deployment

Check the running Pods:

```bash
kubectl get pods
```

Check the Services:

```bash
kubectl get services
```

Check the Deployments:

```bash
kubectl get deployments
```

Check the Helm release:

```bash
helm status voting-app
```

## Accessing the Application

The application exposes two frontend services through Kubernetes NodePort services.

| Application | NodePort |
|---|---:|
| Vote | 31000 |
| Result | 31001 |

Access the applications using a reachable worker-node IP address:

```text
http://<NODE-IP>:31000
http://<NODE-IP>:31001
```

Ensure the necessary network and security-group rules permit access to these ports.

## Helm Release Management

Helm manages the application's deployment history.

### View Release History

```bash
helm history voting-app
```

### Upgrade the Application

```bash
helm upgrade voting-app ./helm/voting-app
```

### Roll Back a Release

To restore a previous revision:

```bash
helm rollback voting-app <REVISION>
```

### Check Release Status

```bash
helm status voting-app
```

## Testing Helm Rollback

As part of this project, a failed release was intentionally introduced by deploying an invalid Vote image tag.

```bash
helm upgrade voting-app ./helm/voting-app \
  --set vote.image.tag=1337xgiwagizo
```

The new Vote Pod entered `ImagePullBackOff` because Kubernetes could not pull the specified image.

The previous working release was restored using:

```bash
helm rollback voting-app 3
```

The application recovered, and all five application components returned to a Running state.

This exercise demonstrated Helm revision history, failed upgrades, Kubernetes reconciliation, and release rollback.

## Cleaning Up

To remove the application from the cluster:

```bash
helm uninstall voting-app
```

To verify removal:

```bash
kubectl get pods
kubectl get services
```

**Note:** This command removes the Helm-managed application resources. It does not delete the EKS cluster itself.

## Important Notes

- The application is composed of multiple independently running services.
- Helm manages the Kubernetes resources through templates and configurable values.
- The PostgreSQL database currently uses an `emptyDir` volume in the DB Deployment. Its data is temporary and will be lost when the Pod is removed and replaced.
- NodePort access depends on the worker nodes being reachable and the required network rules being configured.

## Project Outcome

Successfully deployed a distributed Voting Application to Amazon EKS using a custom Helm chart.

The project provided practical experience with container orchestration, Kubernetes workloads, Services, Helm chart configuration, release upgrades, troubleshooting, and rollback strategies.

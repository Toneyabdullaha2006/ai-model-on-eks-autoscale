# EKS LLM Deployment - Toneyabdullaha2006

Production-ready LLM on AWS EKS.

## Model
TinyLlama-1.1B-Chat-v1.0 (Change to Llama-3-8B in app/main.py)

## Test
curl http://YOUR-LOADBALANCER/health
curl -X POST http://YOUR-LOADBALANCER/generate -H "Content-Type: application/json" -d '{"prompt":"What is EKS?","max_tokens":100}'

## Deploy
terraform init && terraform apply
kubectl apply -f k8s/
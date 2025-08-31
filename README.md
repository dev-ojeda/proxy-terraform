# 🚀 Infraestructura con Terraform en GCP

Este repositorio contiene la infraestructura definida en **Terraform** para desplegar servicios en **Google Cloud Platform (GCP)**.  
Se utilizan **módulos reutilizables** para mantener el código organizado y escalable.

---

## 📂 Estructura del proyecto
```
├── main.tf # Archivo principal, orquesta módulos y providers
├── variables.tf # Definición de variables globales (project_tags y service_tags)
├── outputs.tf # Outputs exportados de los módulos (ej: endpoints, URLs)
├── deploy.sh # Script Bash para inicializar, planear, aplicar y destruir
├── .env.dev # Variables de entorno para el ambiente de desarrollo
├── .env.stg # Variables de entorno para staging
├── .env.prod # Variables de entorno para producción
└── modules/ # Módulos reutilizables de Terraform
├── cloud_run/ 
│ └── main.tf # Lógica de despliegue de servicios en Cloud Run
└── cloud_endpoints/
  └── main.tf # Lógica de despliegue de Endpoints con OpenAPI
```

## 📝 Archivos principales

### `main.tf`
- Configura el **provider de Google** usando credenciales de service account.
- Invoca los módulos:
  - `cloud_run` → despliega servicios en Cloud Run.
  - `cloud_endpoints` → crea el servicio de Endpoints con OpenAPI.
- Asocia `providers` con alias (`google_mod`).

---

### `variables.tf`
Define objetos complejos para inyectar desde `.env`:
- **`project_tags`**
  - `project_id`
  - `project_number`
  - `region`
  - `environment`
  - `default_credentials`
- **`service_tags`**
  - `service_app_proxy`
  - `service_app_proxy_key`
  - `region`
  - `service_accounts`
  - `service_host_name`
  - `service_url_name`
  - `service_url_name_key`

---

### `outputs.tf`
Expone valores importantes como outputs.  

Ejemplo:
```hcl
output "cloud_run_endpoints" {
  value     = google_endpoints_service.openapi_service.service_name
  sensitive = true # 👉 Evita que se muestre en consola, pero sigue estando en el terraform state. Eso previene malentendidos de seguridad. 
}
```
### `deploy.sh`

Script de automatización para simplificar el uso de Terraform:

- Carga variables desde .env.{env} (ej: .env.dev).

- Valida credenciales (key.json) antes de correr Terraform.

- Exporta variables con el prefijo TF_VAR_ para que Terraform las consuma.

- Soporta comandos:
```
./deploy.sh init dev

./deploy.sh plan dev

./deploy.sh apply dev

./deploy.sh destroy dev
```
---

### `.env.{env}`

Archivos con configuración sensible para cada entorno (dev, stg, prod).

- Ejemplo (.env.dev):
```
# Variables Proyecto
PROJECT_ID=my-gcp-project
PROJECT_NUMBER=123456789
REGION=us-central1
ENVIRONMENT=dev
CREDENTIALS_PATH=./keys/dev-key.json

# Variables Servicios
SERVICE_APP_PROXY=my-proxy-service
SERVICE_APP_PROXY_KEY=proxy-key
SERVICE_ACCOUNTS=my-service-account@gcp-sa.iam.gserviceaccount.com
SERVICE_HOST_NAME=myapp.dev.example.com
SERVICE_URL_NAME=myapp-dev
SERVICE_URL_NAME_KEY=myapp-dev-key
```

### `.terraform.lock.hcl`
- Archivo generado automáticamente por Terraform.
- Mantiene bloqueadas las versiones de los providers para garantizar consistencia.
- **Debe subirse al repositorio** (no ignorar).
- No se edita a mano; se actualiza con:
```bash
terraform init -upgrade
```
---

## 📦 Modulos

### `module/cloud_run`

Contiene el código Terraform para desplegar aplicaciones en Cloud Run:

- Configuración de servicio
- Políticas IAM
- Configuración de tráfico y revisiones

### `module/cloud_endpoints`

Contiene la definición de Google Cloud Endpoints:

- Crea el servicio con google_endpoints_service
- Usa un archivo OpenAPI (openapi-run.yaml) para definir la API
- Asocia endpoints al servicio desplegado en Cloud Run

---

## 🚀 Flujo de trabajo

- Configura las variables en .env.dev, .env.stg o .env.prod.
Ejecuta:
```
./deploy.sh init dev
./deploy.sh plan dev
./deploy.sh apply dev
```
- Revisa outputs en terraform output

---

## 🔐 Notas de seguridad

- Nunca subas los archivos *.json de credenciales al repositorio.
- Los .env.* deben estar en .gitignore.
- Revisa permisos mínimos en el service account (roles/run.admin, roles/servicemanagement.admin, etc.).
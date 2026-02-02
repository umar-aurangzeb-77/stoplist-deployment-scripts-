# Stoplist Application Deployment

This directory contains all the necessary files to build, deploy, and manage the Stoplist application stack using Docker Compose.

The setup is designed for an internal server that uses a public IP address instead of a domain name. It includes:
-   `stoplist-frontend` (Next.js)
-   `stoplist-backend` (NestJS)
-   `nginx` (as a reverse proxy)

HTTPS is enabled using a self-signed SSL certificate, and the database is expected to be hosted on a separate, external server.

---

## Deployment Instructions

### Step 0: Install Prerequisites (Run on a Fresh Server)

Before deploying, you need to install Docker and Docker Compose on your server. A script is provided to automate this for Debian-based systems like Ubuntu.

Run the script with `sudo`:

```bash
sudo sh ./install-prereqs.sh
```

This will install all required software. Once it completes, you can proceed with the deployment.

### Step 1: Configure the Environment

Before you can deploy, you must configure the environment variables.

1.  **Open the `.env` file.** This file contains all the necessary configuration for the application, database, and server.

2.  **Update the following values:**
    -   `SERVER_IP`: Set this to the public IP address of the server where you are deploying the application.
    -   `DB_HOST`: The hostname or IP address of your external PostgreSQL server.
    -   `DB_PORT`: The port for your external PostgreSQL server (e.g., `5432`).
    -   `DB_DATABASE`: The name of the database (e.g., `stoplist_prod_db`).
    -   `DB_USERNAME`: The username for the database.
    -   `DB_PASSWORD`: The password for the database.
    -   `JWT_SECRET`: A long, random, and secret string used for signing authentication tokens.

### Step 2: Generate Self-Signed SSL Certificate (One-Time Setup)

Since this deployment does not use a public domain, you need to generate a self-signed certificate for HTTPS.

From within this `deployment` directory, run the following script:

```bash
sh ./generate-ssl.sh
```

This will create a new `nginx/ssl` directory containing the `selfsigned.key` and `selfsigned.crt` files. You only need to do this once.

### Step 3: Launch the Application

Once the `.env` file is configured and the SSL certificate is generated, you can build and start all the services.

```bash
sh ./deploy.sh start
```

This command will build the Docker images for the frontend and backend and start all containers in the background. Your application will be accessible at `https://<your_server_ip>`.

> **Note on Browser Security Warning:**
> Because you are using a self-signed certificate, your web browser will display a security warning (e.g., "Your connection is not private"). This is expected. You will need to click "Advanced" and choose to "Proceed" to the site.

---

## Managing the Deployment

A simple script, `deploy.sh`, is provided to manage the application stack.

-   **Start Services:**
    ```bash
    sh ./deploy.sh start
    ```

-   **Stop Services:**
    ```bash
    sh ./deploy.sh stop
    ```

-   **View Logs:**
    ```bash
    sh ./deploy.sh logs-f
    ```

-   **Stop and Remove Everything:**
    *(This will remove containers and networks, but not your database data on the external server).*
    ```bash
    sh ./deploy.sh down
    ```

-   **Rebuild Images:**
    *(If you make changes to the frontend or backend source code).*
    ```bash
    sh ./deploy.sh build
    ```

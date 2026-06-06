# Network Security - Phishing Detection (MLOps Project)

This repository contains a production-grade, end-to-end MLOps pipeline designed to detect phishing websites using a network security dataset. The project implements a complete modular architecture covering Data Ingestion, Data Validation (including dataset drift detection), Data Transformation, Model Training (with hyperparameter tuning), and a FastAPI web interface to train and serve predictions.

---

## Tech Stack

*   **Language**: Python 3.10
*   **Web Framework**: FastAPI & Uvicorn
*   **Database**: MongoDB Atlas (for storing and retrieving raw network data)
*   **Experiment Tracking & Model Registry**: MLflow & DagsHub
*   **Containerization**: Docker & Docker Compose
*   **Data Science**: Pandas, NumPy, Scikit-Learn, SciPy (for Kolmogorov-Smirnov drift testing)
*   **Project Packaging**: Setuptools (`setup.py` with editable `-e .` installation)

---

## Folder Structure

```text
network-security/
├── .github/                # GitHub Action workflows (CI/CD)
├── Artifacts/              # Auto-generated artifacts for each pipeline run (Ignored by git)
├── data_schema/
│   └── schema.yaml         # Dataset schema defining expected columns
├── final_model/            # Production model binaries (Ignored by git)
├── logs/                   # Local application execution logs (Ignored by git)
├── networksecurity/        # Main Python Package
│   ├── cloud/              # Cloud connection wrappers
│   ├── components/         # Modular pipeline components
│   │   ├── data_ingestion.py
│   │   ├── data_validation.py
│   │   ├── data_transformation.py
│   │   └── model_trainer.py
│   ├── constant/           # Constants and configurations
│   │   └── training_pipeline/
│   ├── entity/             # Dataclass definitions for config and artifacts
│   │   ├── artifact_entity.py
│   │   └── config_entity.py
│   ├── exception/          # Custom Exception handling
│   ├── logging/            # Custom Logger configurations
│   ├── pipeline/           # Training pipeline orchestrator
│   │   └── training_pipeline.py
│   └── utils/              # Helper functions and model wrappers
│       ├── main_utils/     # File and model serializations
│       └── ml_utils/       # Metric and custom estimator definitions
├── templates/              # HTML templates for the web interface
│   ├── index.html
│   └── table.html
├── .env                    # Local environment secrets (Ignored by git)
├── .gitignore              # Files ignored by Git tracking
├── app.py                  # FastAPI Application Entrypoint
├── clean.bat              # Windows cleanup batch script for local files/Docker
├── Dockerfile              # Container building instruction
├── docker-compose.yml      # Orchestrates local container service
├── Makefile                # Short CLI helpers for Docker commands
├── push_data.py            # Utility script to extract and push local CSV data to MongoDB
├── requirements.txt        # PIP dependencies
└── setup.py                # Python setuptools packaging configuration
```

---

## Quick Start

### 1. Prerequisites
Ensure you have the following installed on your machine:
*   Python 3.10
*   MongoDB Atlas Account
*   DagsHub Account (for MLflow experiment tracking)
*   Docker & Docker Compose (optional, for containerized run)

### 2. Setup Environment
Clone the repository and navigate into the workspace directory:
```bash
# Create and activate virtual environment
python -m venv venv
venv\Scripts\activate      # On Windows
source venv/bin/activate    # On Linux/macOS

# Install dependencies in editable mode
pip install -r requirements.txt
```

### 3. Environment Variables (`.env`)
Create a `.env` file in the root directory and configure your MongoDB connection:
```env
MONGO_DB_URL="your-mongodb-atlas-connection-string"
```

### 4. Running the Pipelines Locally
You can run individual stages for testing, which will instantiate training configs, execute the modules, and serialize local outputs to the `Artifacts/` directory.

*   **Data Ingestion**:
    ```bash
    python -m networksecurity.components.data_ingestion
    ```
*   **Data Validation**:
    ```bash
    python -m networksecurity.components.data_validation
    ```
*   **Data Transformation**:
    ```bash
    python -m networksecurity.components.data_transformation
    ```
*   **Model Training & MLflow Tracking**:
    ```bash
    python -m networksecurity.components.model_trainer
    ```

---

## Running the FastAPI Web Application

Start the API server using Uvicorn:
```bash
python -m uvicorn app:app --reload
```
Open your browser and navigate to:
*   **Dashboard**: `http://127.0.0.1:8000` (Train models and upload prediction files visually)
*   **API documentation**: `http://127.0.0.1:8000/docs` (Swagger UI)

---

## Running in Docker (Docker Compose)

We use `docker-compose` to run the application with environment mapping and hot reloading:

*   **Build the image**:
    ```bash
    docker-compose build
    ```
*   **Run the container**:
    ```bash
    docker-compose up
    ```
*   **Stop the container**:
    ```bash
    docker-compose down
    ```

---

## Reading Input & Output Data

### Input Specifications
The prediction API expects a CSV file containing **30 feature columns** and optionally the `Result` target column (as defined in `data_schema/schema.yaml`). 

Columns include:
*   `having_IP_Address`, `URL_Length`, `Shortining_Service`, `having_At_Symbol`, `double_slash_redirecting`, `Prefix_Suffix`, `having_Sub_Domain`, `SSLfinal_State`, `Domain_registeration_length`, `Favicon`, `port`, `HTTPS_token`, `Request_URL`, `URL_of_Anchor`, `Links_in_tags`, `SFH`, `Submitting_to_email`, `Abnormal_URL`, `Redirect`, `on_mouseover`, `RightClick`, `popUpWidnow`, `Iframe`, `age_of_domain`, `DNSRecord`, `web_traffic`, `Page_Rank`, `Google_Index`, `Links_pointing_to_page`, `Statistical_report`.

### Output Specifications
When you perform predictions via the `/predict` route:
1.  **On Screen**: It displays an HTML table listing the uploaded data alongside a new **`predicted_column`** containing `1` (Safe) or `0` (Phishing).
2.  **Locally**: The predictions are exported to `prediction_output/output.csv` in the root workspace.

---

## Cleanup

To clean up locally generated artifacts, logs, outputs, and cached Docker environments:

*   **Windows**:
    ```cmd
    clean.bat
    ```
*   **Linux/macOS**:
    ```bash
    make clean
    ```

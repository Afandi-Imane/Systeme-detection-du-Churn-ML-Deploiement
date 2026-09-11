# 1. Image de base Python légère
FROM python:3.11-slim

# 2. Dossier de travail dans le container
WORKDIR /app

# 3. Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 4. Copier et installer les dépendances Python
COPY requirements-prod.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements-prod.txt

# 5. Copier tout le projet
COPY . .

# 6. Variables d'environnement
ENV PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app \
    PROJECT_ROOT=/app \
    MODEL_PATH=/app/mlruns/1/models/m-d3e8aa3fdeab4b28b1c9169947c450da/artifacts \
    FEATURE_COLUMNS_PATH=/app/mlruns/1/3073ba1fafa24675829043358727e583/artifacts/feature_columns.txt

# 7. Exposer le port FastAPI
EXPOSE 8000

# 8. Lancer l'application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
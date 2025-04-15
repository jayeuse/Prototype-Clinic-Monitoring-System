#!/bin/bash

# Exit on any error
set -e

# Step 1: Download the latest database file from your GitHub repo
echo "📥 Downloading latest database from GitHub..."
curl -L -o ClinicMonitoringSystem.sql https://raw.githubusercontent.com/jayeuse/Prototype-Clinic-Monitoring-System/main/database/ClinicMonitoringSystem.sql

# Step 2: Prompt for MySQL password once
read -s -p "Enter MySQL root password: " MYSQL_PWD
echo

# Step 3: Create the database if it doesn’t exist
echo "📂 Ensuring database exists..."
mysql -u root -p"$MYSQL_PWD" -e "CREATE DATABASE IF NOT EXISTS ClinicMonitoringSystem;"

# Step 4: Import the SQL file into the database
echo "🛠️  Importing SQL file into ClinicMonitoringSystem..."
mysql -u root -p"$MYSQL_PWD" ClinicMonitoringSystem < ClinicMonitoringSystem.sql

echo "✅ Done! Database imported successfully."

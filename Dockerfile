# Stage 1: Build the environment and install dependencies
FROM python:3-slim-buster AS builder
WORKDIR /flask-app
RUN python3 -m venv venv
ENV VIRTUAL_ENV=/flask-app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Stage 2: Setup the runtime environment
FROM python:3-slim-buster AS runner
WORKDIR /flask-app

# Copy the virtual environment from the builder stage
COPY --from=builder /flask-app/venv venv

# Copy your application code with Blueprints structure
COPY . /flask-app

ENV VIRTUAL_ENV=/flask-app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Set the FLASK_APP environment variable
# Adjust this if your main application file is named differently or deeper in the directory structure
ENV FLASK_APP=app/__init__.py

# Set the default command to run the Flask app
CMD ["flask", "run", "--host=0.0.0.0", "--port=5002"]

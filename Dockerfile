FROM alpine:3.10

# Add the application's alpine dependencies.
RUN apk add python3

# Our application source will be run from here.
WORKDIR /app

# Install the application's python dependencies.
# These requirements are generated from the requirements.in file using pip-tools.
COPY requirements.txt ./requirements.txt
RUN python3 -m pip install -r requirements.txt

# By default, Flask runs on port 5000.
EXPOSE 5000

# Copy all of the application source into the app directory.
# This is important because skaffold uses lines like these in the Dockerfile to 
# determine which files it should watch for rebuilding and/or syncing.
COPY src/ /app/

# Set up Flask in development/debug mode - enables application hot-reloading.
ENV FLASK_DEBUG=1
ENV FLASK_APP=/app/app.py

# Run the application and bind to 0.0.0.0 so we can access it from outside of 
# the container by exposing port 5000.
CMD ["python3", "-m", "flask", "run", "--host", "0.0.0.0"]
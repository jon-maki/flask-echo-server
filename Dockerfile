FROM alpine:3.10

WORKDIR /app

RUN apk update && apk add python3 
COPY requirements.txt ./requirements.txt
RUN python3 -m pip install -r requirements.txt

EXPOSE 5000

COPY src/ /app/

ENV FLASK_DEBUG=1
ENV FLASK_APP=/app/app.py

CMD ["python3", "-m", "flask", "run", "--host", "0.0.0.0"]
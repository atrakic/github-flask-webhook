FROM python:3.9-alpine
WORKDIR /app

COPY requirements.txt app.py ghwebhook.py wsgi.py ./
RUN apk add --no-cache git
RUN pip3 install -r requirements.txt --no-cache-dir
ENV FLASK_ENV production

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 5000
CMD ["gunicorn", "-b", ":5000", "wsgi:app"]

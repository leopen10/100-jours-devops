FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=django_invoice.local
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir django==6.0.3 gunicorn whitenoise celery django-celery-beat redis python-decouple pdfkit django-redis
COPY . .
RUN python manage.py migrate --noinput 2>/dev/null || true
RUN python manage.py collectstatic --noinput 2>/dev/null || true
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

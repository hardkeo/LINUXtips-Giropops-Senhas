FROM python:3.14.0a1-slim-bookworm
WORKDIR /app
ADD https://github.com/badtuxx/giropops-senhas.git .
RUN pip3 install --no-cache-dir -r requirements.txt
ENV REDIS_HOST=redis
EXPOSE 5000
CMD ["python3", "-m" , "flask", "run", "--host=0.0.0.0"]

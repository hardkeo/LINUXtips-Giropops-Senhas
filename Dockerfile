FROM python:3.14.0a1-slim-bookworm
LABEL maintainer="hardkeo@gmail.com"
WORKDIR /app
ADD https://github.com/badtuxx/giropops-senhas.git .
RUN apt update \
  && apt install -y curl \
  && pip3 install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD ["python3", "-m" , "flask", "run", "--host=0.0.0.0"]
HEALTHCHECK --timeout=2s \
  CMD curl -f localhost:5000 || exit 1

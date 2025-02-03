FROM cgr.dev/chainguard/python:latest-dev AS dev

WORKDIR /app
ADD https://github.com/badtuxx/giropops-senhas.git .

RUN python -m venv venv
ENV PATH="/app/venv/bin":$PATH
RUN pip install -r requirements.txt
# to use in heathcheck script
RUN pip install requests
FROM cgr.dev/chainguard/python:latest

WORKDIR /app

COPY --from=dev /app/app.py    ./app.py
COPY --from=dev /app/venv      ./venv
COPY --from=dev /app/templates ./templates
COPY --from=dev /app/static    ./static
COPY <<EOF ./healthcheck.py
# python healthcheck script
import requests

try:
    response = requests.get('http://127.0.0.1:5000').status_code
except:
    response = 'unhealthy'

if response == 200:
    exit(0)
else:
    exit(1)
EOF

ENV PATH="/app/venv/bin:$PATH"

EXPOSE 5000
ENTRYPOINT ["python", "-m" , "flask", "run", "--host=0.0.0.0"]
HEALTHCHECK --timeout=2s \
  CMD ["python", "healthcheck.py"]

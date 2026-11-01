# AtlasPay
AtlasPay is a database-first banking and payment processing system built with Oracle Database and PL/SQL.

# Start Oracle
First, make sure you've accepted the terms for the image in the Oracle Container Registry and authenticated:
```bash
docker login container-registry.oracle.com
docker compose -f compose.yaml pull
docker compose -f compose.yaml up -d
```

Because you're already inside docker/oracle, Compose will use that directory's .env file.

Check the status:
```bash
docker compose -f compose.yaml ps
docker compose -f compose.yaml logs -f oracle
```

Wait until the logs indicate:
```
DATABASE IS READY TO USE!
```

Press Ctrl+C to exit the log view; the database keeps running.
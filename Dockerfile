FROM kmyuhkyuk/twitch-drops-miner-base-alpine:latest

# Set environment variables
ENV PORT=8080

WORKDIR /app

# Copy project metadata and install dependencies
COPY pyproject.toml .

# Install Python dependencies
RUN pip install --no-cache-dir . \
    && pip uninstall --yes pip

# Copy application code
COPY main.py ./
COPY src/ ./src/
COPY lang/ ./lang/
COPY icons/ ./icons/
COPY web/ ./web/

# Create data directory for persistent storage
RUN mkdir -p /app/data /app/logs && chmod 700 /app/data /app/logs

# Expose web port
EXPOSE 8080

# Health check. Exec form: a timeout kills the probe itself, not a shell that orphans it.
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8080/healthz')"]

# Reap orphaned processes, such as browser helpers, with or without Docker's --init.
# -s avoids tini's warning when --init makes it a child of Docker's own init.
ENTRYPOINT ["/sbin/tini", "-s", "--"]

# Run the application (web GUI is now default)
CMD ["python", "main.py"]
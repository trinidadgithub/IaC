FROM gcc:latest
WORKDIR /app
COPY api.c /app
RUN gcc -o api api.c
CMD ["./api"]

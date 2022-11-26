FROM golang:1.19-alpine AS build
WORKDIR /workspace
COPY . .
RUN CGO_ENABLED=0 go build -ldflags '-w -extldflags "-static"' .

FROM alpine:3.9
COPY --from=build /workspace/simple-http-echo /usr/local/bin/simple-http-echo
ENTRYPOINT ["simple-http-echo"]

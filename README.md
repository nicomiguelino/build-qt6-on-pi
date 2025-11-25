<h1 align="center">
    Build Qt 6 for the Raspberry Pi on Raspberry Pi :sparkles:
</h1>

## :seedling: About

This project contains the tools that you need to build Qt 6 for Raspberry Pi 5.

## :rocket: Getting Started

Set the `PLATFORM` environment variable to the preferred device type:

```bash
export PLATFORM='pi5'
```

Generate Dockerfiles off the templates with the following command:

```bash
./scripts/generate-dockerfiles.sh
```

Start the Docker container with the following command:

```bash
docker compose up -d --build
```

Enter the Docker container with the following command:

```bash
docker compose exec -it builder bash
```

## Starting a new D-Bus Session

Run the following command to start a new D-Bus session:

```bash
dbus-launch --sh-syntax
```

Make sure to copy the console output and run them.

If you're going to open another terminal and use the same D-Bus session, make sure to paste the output environment variables there as well.

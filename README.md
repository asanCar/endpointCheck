# endpointCheck
Contenerized health-check with Slack integration.

## Modify endpointcheck.sh
### Configure URL
First modify `<url>` with the URL to check:
```
## Endpoint URL to check
url="<url>"
```

### Slack integration
To integrate with Slack you must create a bot in a Slack chat and then use the given URL in `<slackUrl>`:
```
## Slack app webhook
slackUrl="<slackUrl>"
```

## Build Docker image
```
docker build . -t endpoint-check
```

## Run 
```
docker run -d endpoint-check:latest
```

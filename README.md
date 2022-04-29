# github-flask-webhook
Tiny flask app that listens for incoming requests from a [GitHub webhook](https://docs.github.com/en/developers/webhooks-and-events/about-webhooks)

## Example usage:

1. Build container:
```
docker-compose build
```

2. Start container and expose it to outside world, while running on a separate terminal (observe url output, ie. https://XXXXX.lhrtunnel.link):
```
DOCKER_CONTAINER=xomodo/ghwebhook ./scripts/localhostrun.sh
```

3. On one of your existing git repos, create new webhook: <https://github.com/$GH_USER/$GH_REPO/settings/hooks/new> with following settings:

- Payload URL: https://XXXXX.lhrtunnel.link ## <-- changeHere
- Content type: 'application/json'
- Secret: 'XXXX-secret'                     ## <-- the secret value from docker-compose.yaml
- Add webhook:
- Send me everything: on
- Active: on
- <Add webhook>


4: Clone repo from step 3, and push some changes to trigger webhook and receive data on your running :
```
git clone git@github.com:$GH_USER/$GH_REPO.git
git co -b webhook-testing
git commit -m "Trigger webhook" --allow-empty
git push
``

5. Observe logs
```
docker logs localhostrun
``

6: Optionally: extend handler 'src/ghwebhook.py' with additional steps, eg. to deploy app, etc.

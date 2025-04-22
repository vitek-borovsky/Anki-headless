# Anki-headless
### Setting config
First we need to setup our environment so download anki on system with gui.

####  Download plugins
[Anki-connect](https://ankiweb.net/shared/info/2055492159) at minimum (2055492159)

Note: if you are using special note types like `KaTeX` make sure appropriete plugins are installed as well

#### Reconfigure anki-connect network interface
By default anki-connect is only exposed to the `localhost` interface.
We cannot access this interface with docker-port-bindings (-p 8765:8765) so we must expose it
to the "default" network interface

- Open anki
- Tools->Add-ons
- Select anki-connect
- Click config (right bottom)
- Change `"webBindAddress": "127.168.0.1",` -> "webBindAddress": "0.0.0.0",` (make sure you don't delete trailing comma)

Log in / setup Syncing

Close anki

#### Identifying your config directory
- Make sure anki is currently not running `ps aux | grep anki`

Now that we've configured our app we need to `export` the settings.
The directory we are looking for is located at `~/.local/share/Anki2`.
Copy this directory to the machine which will run headless-anki

On windows it should be in `Appdata/Anki2`

### Running in docker
```bash
docker run \
    -v <your-Anki2-config-dir>:/home/anki/.local/share/Anki2 \
    -p 8765:8765 \
    vitkovec/anki-headless:latest
```

### Running in kubernetes
Deployment and service manifest is available [here](anki-headless.yaml).
And you will still need to create pvc with `anki2-pvc` name.

> [!TIP] Don't forget to create `anki` namespace

Test that it's running correctly
```bash
kubectl -n anki port-forward svc/anki-headless 8765:8765
curl localhost:8765
# Expected result: {"apiVersion": "AnkiConnect v.6"}
```

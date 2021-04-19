# My blog

Check out the READMEs in the nested child apps of this umbrella for more
information.

You can hack around on this project by providing the following environment
variables:

```shell
export REPO_NAME = "blog"
export REPO_OWNER = "vereis";
export ACCESS_TOKEN = <SECRET_ACCESS_TOKEN>
```

Following this, you simply can just run `iex -S mix phx.server` to provide a
local repl and dev environment, or you can build a release with `mix release`.

The port this application starts up on is `3108`

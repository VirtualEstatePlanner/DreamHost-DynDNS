<h1>Dynamic DNS for Dreamhost in a docker container</h1>
<h2>Requirements</h2>
In order to use this docker image, you will need the following `docker secrets` defined and available to your container:

- DREAMHOST_API_KEY
- RECORD_TYPE
- RECORD_TO_UPDATE

You will also need an API key with access to all DNS APi commands.  You can generate your API key from [this page](https://panel.dreamhost.com/?tree=home.api) when you are logged in.

You can find out more about this API at [DreamHost's DNS API documentation page](https://help.dreamhost.com/hc/en-us/articles/217555707-DNS-API-commands).

<h2>You can easily create the relevant docker secrets with:</h2>

- `printf $SECRET_VALUE | docker secret create DREAMHOST_API_KEY -`
- `printf $SECRET_VALUE | docker secret create RECORD_TYPE -`
- `printf $SECRET_VALUE | docker secret create RECORD_TO_UPDATE -`

<h2>You can easily start your Dynamic DNS service with:</h2>

`docker stack deploy -c docker-compose.yml dns`

or

`docker-compose up`

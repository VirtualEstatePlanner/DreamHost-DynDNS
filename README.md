<h1>Dynamic DNS for Dreamhost in a docker container</h1>

You will need the following docker secrets defined and available to this container:

- DREAMHOST_API_KEY
- RECORD_TYPE
- RECORD_TO_UPDATE

<h2>You can create a docker secret with:</h2>

`printf $SECRET_VALUE | docker secret create SECRET_NAME -`

<h2>You can easily start your Dynamic DNS service with:</h2>
`docker stack deploy -c docker-compose.yml dns`

or

`docker-compose up`

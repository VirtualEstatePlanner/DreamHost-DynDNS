<h1>Dynamic DNS for Dreamhost in a docker container</h1>

You will need the following docker secrets defined and available to this container:

- DREAMHOST_API_KEY
- RECORD_TYPE
- RECORD_TO_UPDATE

You can create a docker secret with:
`printf $SECRET_VALUE | docker secret create SECRET_NAME -`

Once you have created all 3 docker secrets, you can easily start your Dynamic DNS service with:
`docker stack deploy -c docker-compose.yml dns`

or

`docker-compose up`

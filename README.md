# vuln-graphql-api

This fork of [vulnerable-graphql-api](https://github.com/CarveSystems/vulnerable-graphql-api) simplifies 
and cleans up the Docker build for quick deployment and testing with docker-compose. 

## Docker Build
 
```bash
docker-compose --build up
```

or...

```bash
# docker build -t stackhawk/vuln-graphql-api .`
# docker run --rm -ti --name vuln-graphql-api -p 3000:3000 stackhawk/vuln-graphql-api
```

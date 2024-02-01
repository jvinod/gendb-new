# gendb


## Pre-requisites

- Docker 

- Environment variable OPENAI_API_KEY

## Datasets

https://hub.docker.com/r/aa8y/postgres-dataset

`make run-db` target runs the database with the dataset.


## Build

```make```

### Stop, Rebuild, and run everything

``` make run-all ```

### Run just the test database
```make run-db```

#### Run db client

```make run-db-client```

### Run just chatdb
``` make run-chatdb```

#### Run chatdb in just bash
```make run-chatdb-db```


### Stop everything
``` make stop-all ```


## Observations

### DB

#### Good to convert something that maps to query to SQL query
 - it really depends on the question: "Can you compare different cities" yields just names of cities.
    What I'd really like is to take  5 cities _from the database_ and compare them using information from a different source. I.e to use data from the database and then combine it with another source.
 - It never gives up on an answer
 - There is a conversational aspect missing. It could be because of the queries but somehow the results are not being
chained in from Openai.
 - I don't know what's constructing the query. I see a lot of HF models too

#### How do you figure out when to insert a query in the prompt and when not to?
``` Can you tell me a little bit about JavaScript?``` 
yields

```
SQLQuery: SELECT name, localname, continent, region, population, governmentform
FROM country
WHERE name = JavaScript
LIMIT 1;
```
Pretty good if javascript were a country.
   
_I wonder if there is merit in doing the reverse - getting results from open AI and really augmenting it with our results and eliminating nonsense. In other words something like stable diffusion._
#### It appears that it can handle only one database at a time * - ie when pointed to a postgres instance, it needs to be told which database
https://github.com/langchain-ai/langchain/blob/cdfe2c96c530f42fbf2b200c87c617fe5fac6dfd/libs/langchain/langchain/utilities/sql_database.py#L119
#### Size limitations
 - this is a major one, on large databases it fails because of prompt limitations.  Example db: `postgresql+psycopg2://demo_user:demo_password@3.220.66.106:5432/demo`
 - https://stackoverflow.com/questions/76887233/how-do-i-solve-working-around-models-maximum-content-length-exceeded-errors?noredirect=1#comment135548887_76887233

#### Multiple datasources

From a question, how do you figure out where to go if there are multiple datasources?

_It would be nice to have a gendb layer to go to_



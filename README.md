# GitHub Ranks

Get top-10 contributors for the specific repository using GitHub API.


## Requirements

Ruby 2.6.3


## Setup

```
bundle install
rake db:migrate db:seed
```

It will create a sample report for `rails/rails` repo in the database.


## Running

`rails s`

Use `localhost:3000/` to access API


## API endpoints

`POST /reports` Create top-ten report for `org/repository`.\
Example params:  `{ report: { repo: "org/repository" } }`\
Creates an empty report and enqueues an async job to calculate the values.\
Once calculated, the data will appear in `GET /reports/:id` endpoint response.

`GET /reports/:id` Get the report information.

`DELETE /reports/:id` Delete the report

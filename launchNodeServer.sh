#!/bin/bash

cockroach start --insecure --advertise-addr=26257 --join=26257 --cache=.25 --max-sql-memory=.25 --background

cockroach init --insecure --host=26257
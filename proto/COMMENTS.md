# Notes on proto


## Thoughts on if this were to be a production application tool
Since this was just an adhoc homework assignment I put this together pretty quick,
Some things to keep in mind if this was a real-world example.

  * Possibly use channels/ go routines for the calculations so things can happen concurrently
  * Have the userid be a cli option ?
  * Have the filename / path be passed in as a cli arg
  * Use mutex' around the balance variables if this were to be written concurrently
    to avoid data races


## Running the code

* Install go 1.12
```bash
$ go run main.go
```

There is no 3rd party deps everything was done with stdlib

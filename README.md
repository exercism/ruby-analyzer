# Exercism's Ruby Analyzer

This is Exercism's automated analyzer for the Ruby track.

It is run with `./bin/run.sh $EXERCISM $PATH_TO_FILES $PATH_FOR_OUTPUT` and will read the source code from `$PATH_TO_FILES` and write a JSON file with an analysis to `$PATH_FOR_OUTPUT`.

For example:

```bash
./bin/run.sh two_fer ~/solution-238382y7sds7fsadfasj23j/ ~/solution-238382y7sds7fsadfasj23j/output/
```

## Running the tests

Before running the tests, first install the dependencies:

```bash
bundle install
```

Then, run the following command to run the tests:

```bash
bundle exec rake test
```

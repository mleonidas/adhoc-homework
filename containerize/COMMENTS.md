# Containerize

## Notes on app container

- I wound up keeping the app container pretty simple, since it's a contrived  app
  It's pretty small to begin with, if it had a lot of build dependencies possibly
  creating a multi stage docker build would make it smaller

- Also in a real example dropping permissions to an app user for the flask app
  could be benificial possibly user NS maps and apparmor / seccomp profiles for
  the nginx/app container



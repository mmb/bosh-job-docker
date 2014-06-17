Build a Docker container with all packages from a BOSH job.

Usage:

```
bundle exec bosh-job-docker <bosh-release-tarball> <job-name>
```

This compiles the job's packages in the container and leaves
/var/vcap/packages in the same state it would be in on a deployed job.
It doesn't start any job processes but it might someday.

Example:

```sh
bundle exec bosh-job-docker ~/Downloads/bosh-2605.tgz director
sudo docker build director-docker
```

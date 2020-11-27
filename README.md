# Marco's Bash Functions Libraries

## Introduction

The MBFL  is a  collection of  shell functions for  the GNU  Bash shell.
This package  is an attempt  to make Bash  a viable solution  for medium
sized scripts; it needs at least Bash version 4.3.

This  package relies  on the  facilities of  the packages:  GNU m4,  GNU
Coreutils, sudo.

The package uses the GNU Autotools and it is tested, using Travis CI, on
both Ubuntu GNU+Linux systems and OS X systems.


## License

Copyright (c) 2003-2005, 2009-2010, 2012-2014, 2017-2018, 2020
Marco Maggi <mrc.mgg@gmail.com>.  All rights reserved.

This is  free software; you can  redistribute it and/or modify  it under
the terms of  the GNU Lesser General Public License  as published by the
Free Software Foundation; either version 3.0 of the License, or (at your
option) any later version.

This library  is distributed  in the  hope that it  will be  useful, but
WITHOUT   ANY   WARRANTY;  without   even   the   implied  warranty   of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


## Install

To install from  a proper release tarball, after  unpacking the archive,
do this:

```
$ cd mbfl-3.0.0
$ mkdir build
$ cd build
$ ../configure [options]
$ make
$ make check
$ make install
```

to inspect the available configuration options:

```
$ ../configure --help
```

  We want to check the following configuration options:

* `--with-sudo=/path/to/sudo` allows  the selection  of the  pathname to
  the executable `sudo`; this pathname is hard-coded in the library.  It
  defaults to: `/usr/bin/sudo`.

* `--with-whoami=/path/to/whoami` allows  the selection of  the pathname
  to the executable `whoami`, which is  meant to be the program from the
  package GNU Coreutils; this pathname is hard-coded in the library.  It
  defaults to: /bin/whoami.

* `--with-id=/path/to/id` allows  the selection  of the pathname  to the
  executable `id`, which is meant to be the program from the package GNU
  Coreutils; this  pathname is hard-coded  in the library.   It defaults
  to: /bin/id.

The Makefile is designed to allow parallel builds, so we can do:

```
$ make -j4 all && make -j4 check
```

which,  on  a  4-core  CPU,   should  speed  up  building  and  checking
significantly.

From a repository checkout or snapshot  (the ones from the Github site):
we must install the GNU Autotools  (GNU Automake, GNU Autoconf), then we
must first run the script `autogen.sh` from the top source directory, to
generate the needed files:

```
$ cd mbfl
$ sh autogen.sh

```

After this  the procedure  is the same  as the one  for building  from a
proper release tarball, but we have to enable maintainer mode:

```
$ ../configure --enable-maintainer-mode [options]
$ make
$ make check
$ make install
```

After building  the package, and before  installing it, we can  test the
example scripts as follows:

```
$ make test-template MFLAGS='--help'
```

will run `examples/template.sh` with the flags `--help`;

```
$ make test-template-actions MFLAGS='one green gas --help'
```

will run `examples/template-actions.sh` selection  the action `one green
gas` and appending the flags `--help`.


## Usage

Read the documentation generated from  the Texinfo sources.  The package
installs the documentation  in Info format; we can  generate and install
documentation in HTML format by running:

```
$ make html
$ make install-html
```

## Credits

The  stuff was  written by  Marco Maggi.   If this  package exists  it's
because of the great GNU software tools that he uses all the time.


## Bugs, vulnerabilities and contributions

Bug  and vulnerability  reports are  appreciated, all  the vulnerability
reports  are  public; register  them  using  the  Issue Tracker  at  the
project's GitHub  site.  For  contributions and  patches please  use the
Pull Requests feature at the project's GitHub site.


## Resources

The GNU Project software can be found here:

[https://www.gnu.org/](https://www.gnu.org/)

development takes place at:

[https://github.com/marcomaggi/mbfl/](https://github.com/marcomaggi/mbfl/)

and as backup at:

[https://bitbucket.org/marcomaggi/mbfl](https://bitbucket.org/marcomaggi/mbfl)

proper release tarballs for this package are in the download area at:

[https://bitbucket.org/marcomaggi/mbfl/downloads/](https://bitbucket.org/marcomaggi/mbfl/downloads/)


## Badges and static analysis

### Travis CI

Travis CI is  a hosted, distributed continuous  integration service used
to build and test software projects  hosted at GitHub.  We can find this
project's dashboard at:

[https://travis-ci.org/marcomaggi/mbfl](https://travis-ci.org/marcomaggi/mbfl)

Usage of this  service is configured through the  file `.travis.yml` and
additional scripts are under the directory `meta/travis-ci`.


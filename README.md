## NAME

sh-vcprompt - VCS information in your prompt

## SINOPSIS

`shvcp [OPTION]`  
`shvcp [FORMAT]`  

## DESCRIPTION

sh-vcprompt is a pure POSIX Shell script that prints a short string to be
included in your prompt, with barebones information about the current working
directory for various version control systems. It is designed to be small and
lightweight (its try) rather than comprehensive and works with all shells
because was developed to be this.

Currently, it has varying degrees of recognition for Mercurial and Git. Others
VCS like Fossil, Subversion and CVS, be added in the future versions.

## INSTALL

Try checkout from the main repository hosted on Github.com:

    git clone --branch master http://github.com/codigorama/sh-vcprompt.git
    cd sh-vcprompt

And type the following commands to install in system:

    make
    sudo make install

For user install, try this:

    make prefix=[path/to/your/scripts]
    make install

## USAGE

To use it with Bash, just call it in PS1:

    PS1='\u@\h:\w $(shvcp)\$ '

To use it with zsh, you need to enable shell option PROMPT\_SUBST, and
then do similarly to bash:

    setopt prompt_subst
    PROMPT='[%n@%m] [%~] $(shvcp)'

sh-vcprompt prints nothing if the current directory is not managed by a
recognized VCS.

## OPTIONS

Basically:

- `-h`, `--help`:

  Show usage message and formats.

## FORMATS

You can customize the output of sh-vcprompt using format strings, which can
be specified either on the command line. For example:

    shvcp "%b:r%r"

and

    SH_VCP_FORMAT="%b:r%r" shvcp

are equivalent.

Format strings use printf-like "%" escape sequences:

- `%s`:

  Version Control **S**ystem - VCS name (e.g. git, hg).

- `%b`:

  Current **b**ranch name.

- `%h`:

  **h**ash key of the latest commit.

- `%r`:

  Latest **r**evision or the latest number of commit.

- `%m`:

  Prints `+` to **m**odifications (added, changed or removed files).

- `%a`:

  Prints `*` to **a**ppendings (staged files).

- `%u`:

  Prints `?` to **u**ntracked files.

The default format string is:

    [%s:%b]

Which is notable because it works with every supported VCSs.

## AUTHORS

Written by [Hallison Batista](http://github.com/hallison)

## COPYRIGHT

Prigner is Copyright (C) 2012, Hallison Batista under MIT License

See [LICENSE](./LICENSE) file for more information about license.


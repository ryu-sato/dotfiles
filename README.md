# What is dotfiles

CLI settings (files named start from dot).

It makes symbolic links from local git repository to home directory.

# Install

```
$ git clone https://github.com/ryu-sato/dotfiles --depth 1
$ cd dotfiles
$ ./install.sh
```

## Optional Install

### pathogen.vim


```
$ cd dotfiles
$ ./install-pathogen.sh
```

### VSCode

1. Open VSCode
2. (Side Bar) Manage => Profile -> Profiles
3. Import Profiles...
4. Select file dotfiles/.config/vscode/Terminal.code-profile


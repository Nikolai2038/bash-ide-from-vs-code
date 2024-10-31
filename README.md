# bash-ide-from-vs-code

Instructions and extra files on how to set up VS Code as Bash/Shell scripts IDE.

## 1. Install VS Code

You know how to do it, right? Riiiight..?

Anyway, after installing/already having one, I recommend you to create separate profile and call it something fancy, for example, `Bash IDE`.
You can still install all the extensions in any or even all of your profiles, but be aware that most of the time when you will work on some, for example, Java project, you don't want to decrease your VS Code performance by running extra 10+ extensions you don't need right now.
Decide what is more comfy for you here.
For me - it is the separate profile.

## 2. Install required dependencies

- Arch Linux:

    ```sh
    sudo pacman --sync --refresh --needed bash-language-server shellcheck shfmt
    ```

Descriptions:

- `bash-language-server` - For `Bash IDE` extension;
- `shellcheck` - ...;
- `shfmt` - ...;

## 3. Install and configure main extensions

Below you will see descriptions and reasons to install each extension.
Also, the JSON provided is the VS Code settings I used to configure each extension.
If some settings are not provided, that means I left them with default.

Also, if you have suggestions and advices, feel free to add them via [issues](https://github.com/Nikolai2038/bash-ide-from-vs-code/issues) or [pull requests](https://github.com/Nikolai2038/bash-ide-from-vs-code/pulls)!

You can also skip all the instructions below - just install all the references extensions and merge content of `settings.json` into your VS Code settings.

### 3.1. [Bash IDE](https://marketplace.visualstudio.com/items?itemName=mads-hartmann.bash-ide-vscode)

This is main extension which gives us language server.

```json
// Follow redirection operators with a space (more readable)
"bashIde.shfmt.spaceRedirects": true,
// Increase number of files to analize (analize them all to not miss any reference to show)
"bashIde.backgroundAnalysisMaxFiles": 9999,
// Decrease logging level
"bashIde.logLevel": "warning",
```

### 3.2. [File Watcher](https://marketplace.visualstudio.com/items?itemName=appulate.filewatcher)

This extension allow us to execute custom scripts on file changes.
We use it to update all links to the file and from the file to other files.

```json
// Run custom script on file rename, which will update all links to this files from other files, and all links from this file to others
"filewatcher.commands": [
    {
        "event": "onFileRename",
        "match": ".*\\.sh",
        "cmd": "/usr/bin/rename_or_move_shell_script \"${workspaceRoot}\" \"${fileOld}\" \"${file}\""
    }
],
```

I wrote the script `rename_or_move_shell_script.sh` do do all the renames and put it in this repository.
You can install it by running:

```sh
sudo wget -O /usr/bin/rename_or_move_shell_script https://raw.githubusercontent.com/Nikolai2038/bash-ide-from-vs-code/refs/heads/main/rename_or_move_shell_script.sh && \
sudo chmod +x /usr/bin/rename_or_move_shell_script
```

On how the script works - you can check by yourself.
If you found a bug or have a suggestion on how to optimize it, you will be the awesome man to let me know something that will make it better!

### 3.3. [Path Intellisense](https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense)

This extension will autocomplete relative paths to scripts when you entering them in `source`, `find`, etc.

### 3.4. [Bash Debug](https://marketplace.visualstudio.com/items?itemName=rogalmic.bash-debug)

### 3.5. [Code Runner](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)

### 3.6. [shell-format](https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format)

### 3.7. [ShellCheck](https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck)

### 3.8. [Sort](https://marketplace.visualstudio.com/items?itemName=henriiik.vscode-sort)

Useful to sort `source` commands.

TODO: This can be implemented automatically with script in `File Watcher` extension.

### [Shebang Snippets](https://marketplace.visualstudio.com/items?itemName=rpinski.shebang-snippets)

### Statusbar Debugger

## 3. (Optional) Install and configure extra extensions

### GIT

### Markdown

### Useful

### Fancy

### Syntax highlight for some configs

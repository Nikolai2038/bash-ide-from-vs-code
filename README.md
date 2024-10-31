# bash-ide-from-vs-code

## 1. Install VS Code

## 2. Install and configure main extensions

Below you will see descriptions and reasons to install each extension.
Also, the JSON provided is the VS Code settings I used to configure each extension.
If some settings is not provided, that means I left it with default.

Also, if you also have suggestions and advices, feel free to add them via issues or pull requests!

### 2.1. Bash IDE

This is main extension which gives us language server.

```json
// Follow redirection operators with a space (more readable)
"bashIde.shfmt.spaceRedirects": true,
// Increase number of files to analize (analize them all to not miss any reference to show)
"bashIde.backgroundAnalysisMaxFiles": 9999,
// Decrease logging level
"bashIde.logLevel": "warning",
```

### 2.2. File Watcher

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

```bash
sudo wget -O /usr/bin/rename_or_move_shell_script ...
chmod +x ...
```

### 2.5. Path Intellisense

### 2.3. Bash Debug

### 2.4. Code Runner

### shell-format

### ShellCheck

### Sort

### Statusbar Debugger

## 2. (Optional) Install and configure extra extensions

### GIT

### Markdown

### Look
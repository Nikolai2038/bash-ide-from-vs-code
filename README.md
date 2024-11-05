# bash-ide-from-vs-code

Instructions and extra files on how to set up VS Code as Bash/Shell scripts IDE.

## 1. Install VS Code

You know how to do it, right? Riiiight..?

Anyway, after installing/already having one, I recommend you to create separate profile and call it something fancy, for example, `Bash IDE`.
You can still install all the extensions in any or even all of your profiles, but be aware that most of the time when you will work on some, for example, Java project, you don't want to decrease your VS Code performance by running extra 10+ extensions you don't need right now.
Decide what is more comfy for you here.
For me - it is the separate profile.

## 2. Install language server

- Arch Linux:

    ```sh
    sudo pacman --sync --refresh --needed bash-language-server
    ```

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
// Disable "shellcheck" from Bash IDE - it is not working properly for some reason - and to not download anything in system - use "ShellCheck" extension instead with bundled command
"bashIde.shellcheckPath": "",
// Disable "shfmt" from Bash IDE - to not download anything in system - use "shell-format" extension instead with bundled command
"bashIde.shfmt.path": "",
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

### 3.4. [ShellCheck](https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck)

This extension will lint all the problems in your code.
This can be also done with `Bash IDE` extension, but when I used it, it was not working properly - in my case some shell variable was declared as not declared, but it was - in anohter file, and sourced. With the `ShellCheck` extension this problem does not replicate.

```json
// Decrease logging level
"shellcheck.logLevel": "warn",
// Parse external files in "source" command
"shellcheck.customArgs": [
    "--external-sources"
],
// Reduce CPU usage - we will use autosave anyway
"shellcheck.run": "onSave",
```

### 3.5. [shell-format](https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format)

This extension will autoformat code.
You can play with flags as you want, I leave here the ones I use.
You can also disable format on save if you want or when you are working on already written scripts and don't want all file to change.

```json
// Flags for formatting:
// -s,  --simplify  simplify the code
// -i,  --indent uint       0 for tabs (default), >0 for number of spaces
// -bn, --binary-next-line  binary ops like && and | may start a line
// -ci, --case-indent       switch cases will be indented
// -sr, --space-redirects   redirect operators will be followed by a space
// -kp, --keep-padding      keep column alignment paddings
// -fn, --func-next-line    function opening braces are placed on a separate line
"shellformat.flag": "--simplify --indent 2 --binary-next-line --case-indent --space-redirects",
// Autoformat
"[shellscript]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "foxundermoon.shell-format"
},
```

### 3.6. [TypeLens](https://marketplace.visualstudio.com/items?itemName=kisstkondoros.typelens)

This will show useful links above function declarations.
You can localize them for your language.
I use English:

```json
"typelens.noreferences": "No references found",
"typelens.plural": "{0} references",
"typelens.singular": "{0} reference",
```

### 3.7. [Shell Script Command Completion](https://marketplace.visualstudio.com/items?itemName=tetradresearch.vscode-h2o)

This extension is awesome - it provides suggestions for shell commands when you write them in your script.

### 3.7. [Bash Debug](https://marketplace.visualstudio.com/items?itemName=rogalmic.bash-debug)

To debug Bash scripts.

### 3.8. [Code Runner](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)

Run shell script with the button.

### 3.9. [shellman](https://marketplace.visualstudio.com/items?itemName=Remisa.shellman)

Useful shell snippets.

### 3.10. [Shebang Snippets](https://marketplace.visualstudio.com/items?itemName=rpinski.shebang-snippets)

More snippets.

### 3.11. [Sort lines](https://marketplace.visualstudio.com/items?itemName=Tyriar.sort-lines)

Useful to sort `source` commands.

TODO: This can be implemented automatically with script in `File Watcher` extension.

## 3. (Optional) Install and configure extra extensions

### 3.1. GIT

- [GitLens — Git supercharged](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) - It will bring more views to play with. I don't use paid version. For git log use `Git Graph` extension below. Config:

    ```json
    "gitlens.codeLens.enabled": false,
    "gitlens.currentLine.enabled": false,
    "gitlens.showWelcomeOnInstall": false,
    "gitlens.statusBar.enabled": false,
    "gitlens.telemetry.enabled": false,
    ```

- [Git Graph](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph) - Git log. Config I use:

    ```json
    "git-graph.commitDetailsView.location": "Docked to Bottom",
    "git-graph.date.format": "ISO Date & Time",
    "git-graph.dialog.addTag.pushToRemote": true,
    "git-graph.dialog.addTag.type": "Lightweight",
    "git-graph.dialog.cherryPick.recordOrigin": true,
    "git-graph.referenceLabels.combineLocalAndRemoteBranchLabels": false,
    ```

- [Gitignore Ultimate](https://marketplace.visualstudio.com/items?itemName=quentinguidee.gitignore-ultimate) - `.gitignore` file autocompletion;
- [Git History](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory) - Views with history of changes in line, file;
- [git-autoconfig](https://marketplace.visualstudio.com/items?itemName=shyykoserhiy.git-autoconfig) - Useful, if you have several accounts to commit from (work, for example). Otherwise, not needed. Extra setting:

    ```json
    // Run only on workspace start, not in background every 5 seconds
    "git-autoconfig.queryInterval": 999999999,
    ```

Extra git settings I use:

```json
"git.confirmSync": false,
"git.autofetch": true,
"git.enableSmartCommit": true,
"diffEditor.ignoreTrimWhitespace": false,
// Don't find repositories automatically (because it bother, when working not in repositories)
"git.autoRepositoryDetection": false,
// Always open GIT repository in parent folders
"git.openRepositoryInParentFolders": "always",
"git.replaceTagsWhenPull": true,
```

### 3.2. Markdown

- [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one) - Autocompletion;
- [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint) - Lint syntax errors in your Markdown file.

### 3.3. Useful

- [Format in context menus](https://marketplace.visualstudio.com/items?itemName=lacroixdavid1.vscode-format-context-menu) - To right click folder and format all files in it! For the first launch, I recommend disabling format on save, because it will double the commands executing;
- [Open Folder Context Menus for VS Code](https://marketplace.visualstudio.com/items?itemName=chrisdias.vscode-opennewinstance);
- [Presentation Mode](https://marketplace.visualstudio.com/items?itemName=jspolancor.presentationmode) - Switch to presentation mode to show-off for someone;
- [Project Manager](https://marketplace.visualstudio.com/items?itemName=alefragnani.project-manager) - Huge help. I recommend storing all your repositories in one/several folders, and then define them in `projectManager.git.baseFolders` setting;
- [Statusbar Debugger](https://marketplace.visualstudio.com/items?itemName=fabiospampinato.vscode-statusbar-debugger) - Add debugger controls in statusbar. Very useful. Also, I moved initial buttons just in front off launch button;
- [TODO Highlight](https://marketplace.visualstudio.com/items?itemName=wayou.vscode-todo-highlight) - Custom highlight styles for todo's. You can play with it. Config I use:

    ```json
    "todohighlight.isEnable": true,
    "todohighlight.isCaseSensitive": false,
    // Do not highlight explicit words
    "todohighlight.keywordsPattern": "",
    "todohighlight.exclude": [
        "**/node_modules/**",
        "**/bower_components/**",
        "**/dist/**",
        "**/build/**",
        "**/.vscode/**",
        "**/.github/**",
        "**/_output/**",
        "**/*.min.*",
        "**/*.map",
        "**/.next/**"
    ],
    "todohighlight.maxFilesForSearch": 99999,
    "todohighlight.toggleURI": false,
    "todohighlight.keywords": [
        {
            "text": "DEBUG:",
            "color": "green",
            "border": "1px solid green",
            "backgroundColor": "rgba(0,0,0,.2)",
            "isWholeLine": true,
            "overviewRulerColor": "green",
        },
        {
            "text": "TODO:",
            "color": "orange",
            "border": "1px solid orange",
            "backgroundColor": "rgba(0,0,0,.2)",
            "isWholeLine": true,
            "overviewRulerColor": "orange"
        },
        {
            "text": "BUG:",
            "color": "orange",
            "border": "1px solid orange",
            "backgroundColor": "rgba(0,0,0,.2)",
            "isWholeLine": true,
            "overviewRulerColor": "orange"
        },
        {
            "text": "FIXME:",
            "color": "red",
            "border": "1px solid red",
            "backgroundColor": "rgba(0,0,0,.2)",
            "isWholeLine": true,
            "overviewRulerColor": "red"
        },
    ],
    ```

- [Todo Tree](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree) - Show all todo's in your workspace. I find it quite useful in list mode - simple. Config I use:

    ```json
    // Disable highlight, because we do it via "TODO HighLight" extension
    "todo-tree.highlights.enabled": false,
    "todo-tree.general.tags": [
        "DEBUG",
        "TODO",
        "BUG",
        "FIXME",
    ],
    "todo-tree.tree.flat": true,
    ```

- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) - Check spelling in code. This one is for English. You can install extensions `... - Code Spell Checker` for other languages too.

### 3.4. Syntax highlight for some configs

Since I use created Bash profile as default when opening folders on Linux, it is quite useful to have it configured to highlight syntax in several config files - Nginx, Apache, Vim, etc.
For that reason, I also installed:

- [DotENV](https://marketplace.visualstudio.com/items?itemName=mikestead.dotenv) - For `.env` files with environment variables.
- [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml) - For YAML (`docker-compose` configurations);
- [Even Better TOML](https://marketplace.visualstudio.com/items?itemName=tamasfe.even-better-toml) - For TOML (`gitlab-runner` configurations);
- [XML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-xml), [Auto Close Tag](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-close-tag), [Auto Rename Tag](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag) - For XML;
- [VimL](https://marketplace.visualstudio.com/items?itemName=XadillaX.viml) - For `vim` configuration in `.vimrc`;
- [Systemd Helper](https://marketplace.visualstudio.com/items?itemName=hangxingliu.vscode-systemd-support) - For SystemD unit files configurations;
- [Apache Conf](https://marketplace.visualstudio.com/items?itemName=mrmlnc.vscode-apache) - For Apache web server configurations;
- [nginx.conf hint](https://marketplace.visualstudio.com/items?itemName=hangxingliu.vscode-nginx-conf-hint) - For Nginx web server configurations;
- [Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) - For Lua language (used by some Linux windows managers);
- [Rainbow CSV](https://marketplace.visualstudio.com/items?itemName=mechatroner.rainbow-csv) - For CSV and TSV files.

### 3.5. Fancy

- [Coloured Status Bar Problems](https://marketplace.visualstudio.com/items?itemName=bradzacher.vscode-coloured-status-bar-problems) - Add colors to icons in statusbar when there are more than 0 warnings/errors;
- [indent-rainbow](https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow) - Highlight wrong indentation:

    ```json
    "indentRainbow.colors": [
        // Transparent color - to disable it completely.
        // I done it this way, because empty array will disable all the colors.
        // This way, it will show only errors - color for them defined below.
        "rgba(255,255,255,0)"
    ],
    "indentRainbow.errorColor": "rgba(128,32,32,0.5)",
    ```

- [Trailing Spaces](https://marketplace.visualstudio.com/items?itemName=shardulm94.trailing-spaces) - highlight trailing spaces:

    ```json
    "trailing-spaces.backgroundColor": "rgba(128,32,32,0.5)",
    "trailing-spaces.borderColor": "rgba(255,100,100,0)",
    "trailing-spaces.includeEmptyLines": true,
    "trailing-spaces.trimOnSave": true,
    ```

- [Unfancy file icons](https://marketplace.visualstudio.com/items?itemName=alexesprit.vscode-unfancy-file-icons) - Icons pack I use.

### 3.6. Remote

- [Remote Explorer](https://marketplace.visualstudio.com/items?itemName=ms-vscode.remote-explorer);
- [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh);
- [Remote - SSH: Editing Configuration Files](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh-edit).

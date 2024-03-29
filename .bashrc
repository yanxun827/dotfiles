# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Add `~/gnubin` to the `$PATH`. This folder stores symlinks to all the gnu tools instaled by homebrew.
export PATH="$HOME/gnubin:$PATH";

# If not running interactively, don't do anything.
# Some programs like scp will fail if there are outputs in the remote shell.
case $- in
    *i*) ;;
      *) return;;
esac

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
# * ~/.fzf.bash is from brew installation of fzf. (Mac only)
for file in ~/.{path,bash_prompt,exports,bash_aliases,functions,extra,fzf.bash}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Load fzf key-bindings (Linux only).
file=/usr/share/doc/fzf/examples/key-bindings.bash;
[ -r "$file" ] && [ -f "$file" ] && source "$file";
unset file;

bind -r "\C-t" # Unbind default Ctrl-T for fzf
bind -x '"\C-f":"fzf-file-widget"' # Bind fzf file command to Ctrl-F

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;
# Bash history file settings
HISTTIMEFORMAT="%F %T "
HISTSIZE=1000
HISTFILESIZE=2000

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

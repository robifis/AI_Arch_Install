# Synthwave-inspired Powerlevel10k Theme

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Synthwave colors
  local pink='#ff7edb'
  local blue='#36f9f6'
  local purple='#b66eff'
  local yellow='#ffcc00'
  local green='#72f1b8'
  local red='#fe4450'

  # Customize prompt elements
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    dir
    vcs
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    background_jobs
    time
  )

  # Customize colors
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$blue
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$pink
  typeset -g POWERLEVEL9K_VCS_FOREGROUND=$purple
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=$green
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$red
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$yellow
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$blue
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$pink

  # Customize icons
  typeset -g POWERLEVEL9K_VCS_GIT_ICON='󰊢'
  typeset -g POWERLEVEL9K_VCS_GIT_GITHUB_ICON='󰊤'
  typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='󰣇'

  # Other customizations
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%F{$pink}󰁔 %f'
}

(( ${#p10k_config_opts[@]} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'

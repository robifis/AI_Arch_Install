#!/bin/bash

# Create Rofi configuration directory if it doesn't exist
mkdir -p ~/.config/rofi

# Create Rofi configuration file
cat > ~/.config/rofi/config.rasi << EOF
configuration {
    modi: "run,drun,window";
    width: 50;
    lines: 15;
    columns: 2;
    font: "JetBrainsMono Nerd Font 12";
    bw: 1;
    location: 0;
    padding: 5;
    fixed-num-lines: true;
    show-icons: true;
    terminal: "alacritty";
    icon-theme: "Papirus";
    drun-match-fields: "name,generic,exec,categories,keywords";
    drun-display-format: "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
    disable-history: false;
    sort: false;
    sorting-method: "normal";
    case-sensitive: false;
    cycle: true;
    sidebar-mode: false;
    eh: 1;
    auto-select: false;
    combi-modi: "window,drun";
    matching: "normal";
    dpi: 0;
    threads: 0;
    scroll-method: 0;
    window-format: "{w}    {c}   {t}";
    click-to-exit: true;
    max-history-size: 25;
    combi-hide-mode-prefix: false;
    matching-negate-char: '-';
    cache-dir: ;
    window-thumbnail: false;
    drun-use-desktop-cache: false;
    drun-reload-desktop-cache: false;
    normalize-match: true;
    steal-focus: false;
    application-fallback-icon: ;
    pid: "/run/user/1000/rofi.pid";
    display-window: "Windows";
    display-windowcd: "Window CD";
    display-run: "Run";
    display-ssh: "SSH";
    display-drun: "Applications";
    display-combi: "Combi";
    display-keys: "Keys";
    display-filebrowser: "Files";
}

@theme "synthwave84"

window {
    background-color: #2b213aee;
    border: 2px;
    border-color: #ff7edb;
    border-radius: 10px;
    padding: 5;
    width: 50%;
}

mainbox {
    border: 0;
    padding: 0;
}

message {
    border: 2px 0px 0px;
    border-color: @border-color;
    padding: 1px;
}

textbox {
    text-color: #ff7edb;
}

inputbar {
    children:   [ prompt,textbox-prompt-colon,entry,case-indicator ];
}

textbox-prompt-colon {
    expand: false;
    str: ":";
    margin: 0px 0.3em 0em 0em;
    text-color: #ff7edb;
}

listview {
    fixed-height: 0;
    border: 2px 0px 0px;
    border-color: #ff7edb;
    spacing: 2px;
    scrollbar: true;
    padding: 2px 0px 0px;
}

element {
    border: 0;
    padding: 1px;
}

element-text {
    background-color: inherit;
    text-color: inherit;
}

element.normal.normal {
    background-color: #2b213a;
    text-color: #ff7edb;
}

element.normal.urgent {
    background-color: #2b213a;
    text-color: #f92aad;
}

element.normal.active {
    background-color: #2b213a;
    text-color: #36f9f6;
}

element.selected.normal {
    background-color: #4d3a63;
    text-color: #36f9f6;
}

element.selected.urgent {
    background-color: #4d3a63;
    text-color: #f92aad;
}

element.selected.active {
    background-color: #4d3a63;
    text-color: #36f9f6;
}

element.alternate.normal {
    background-color: #2b213a;
    text-color: #ff7edb;
}

element.alternate.urgent {
    background-color: #2b213a;
    text-color: #f92aad;
}

element.alternate.active {
    background-color: #2b213a;
    text-color: #36f9f6;
}

scrollbar {
    width: 4px;
    border: 0;
    handle-width: 8px;
    padding: 0;
}

mode-switcher {
    border: 2px 0px 0px;
    border-color: #ff7edb;
}

button.selected {
    background-color: #4d3a63;
    text-color: #36f9f6;
}

inputbar {
    spacing: 0;
    text-color: #ff7edb;
    padding: 1px;
}

case-indicator {
    spacing: 0;
    text-color: #ff7edb;
}

entry {
    spacing: 0;
    text-color: #36f9f6;
}

prompt {
    spacing: 0;
    text-color: #ff7edb;
}

inputbar {
    children: [prompt,textbox-prompt-colon,entry,case-indicator];
}

textbox-prompt-colon {
    expand: false;
    str: ":";
    margin: 0px 0.3em 0em 0em;
    text-color: #ff7edb;
}
EOF

echo "Rofi configuration with Synthwave84 theme has been created."

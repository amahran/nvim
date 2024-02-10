-- by default the config dir is in the rtp
-- however there is a caveate, nvim when looking for 
-- lua code for plugins, it looks for a dir called `lua`
-- see :h rtp
require('elprofessor/options')
require('elprofessor/remap')
require('elprofessor/lazy')


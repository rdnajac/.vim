finish
" ALE options
let g:ale_cache_executable_check_failures = 0
let g:ale_change_sign_column_color = 0
let g:ale_close_preview_on_insert = 0
let g:ale_command_wrapper = ''
let g:ale_completion_delay = 100
let g:ale_completion_enabled = 0
let g:ale_completion_max_suggestions = 50
let g:ale_disable_lsp = 'auto'
let g:ale_echo_cursor = 1
let g:ale_echo_delay = 10
let g:ale_echo_msg_error_str = 'Error'
let g:ale_echo_msg_format = '%code: %%s'
let g:ale_echo_msg_info_str = 'Info'
let g:ale_echo_msg_warning_str = 'Warning'
let g:ale_enabled = 1
let g:ale_fix_on_save = 0
let g:ale_fixers = {}
let g:ale_history_enabled = 1
let g:ale_history_log_output = 1
let g:ale_keep_list_window_open = 0
let g:ale_lint_delay = 200
let g:ale_lint_on_enter = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_linter_aliases = {}
let g:ale_linters = {}
let g:ale_linters_explicit = 0
let g:ale_list_vertical = 0
let g:ale_list_window_size = 10
let g:ale_loclist_msg_format = g:ale_echo_msg_format
let g:ale_max_buffer_history_size = 20
let g:ale_max_signs = -1
let g:ale_open_list = 0
let g:ale_pattern_options = {}
let g:ale_pattern_options_enabled = v:null
let g:ale_set_balloons = has('balloon_eval') && has('gui_running')
let g:ale_set_highlights = has('syntax')
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_set_signs = has('signs')
let g:ale_sign_column_always = 0
let g:ale_sign_error = '>>'
let g:ale_sign_info = '--'
let g:ale_sign_offset = 1000000
let g:ale_sign_style_error = g:ale_sign_error
let g:ale_sign_style_warning = g:ale_sign_warning
let g:ale_sign_warning = '--'
let g:ale_sign_highlight_linenrs = 0
let g:ale_statusline_format = ['%d error(s)', '%d warning(s)', 'OK']
let g:ale_type_map = {}
let g:ale_use_global_executables = v:null
let g:ale_virtualtext_cursor = 'disabled'
let g:ale_warn_about_trailing_blank_lines = 1
let g:ale_warn_about_trailing_whitespace = 1

" UltiSnips options
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsEditSplit = "normal"
let g:UltiSnipsSnippetDirectories = ["UltiSnips"]
let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = ""
let g:UltiSnipsRemoveSelectModeMappings = 1
let g:UltiSnipsListSnippets = "<c-tab>"
let g:UltiSnipsEnableSnipMate = 1

" YouCompleteMe options
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_min_num_identifier_candidate_chars = 0
let g:ycm_max_num_candidates = 50
let g:ycm_max_num_candidates_to_detail = 0
let g:ycm_auto_trigger = 1
let g:ycm_filetype_whitelist = {'*': 1}
let g:ycm_filetype_blacklist = {
      \ 'tagbar': 1,
      \ 'notes': 1,
      \ 'markdown': 1,
      \ 'netrw': 1,
      \ 'unite': 1,
      \ 'text': 1,
      \ 'vimwiki': 1,
      \ 'pandoc': 1,
      \ 'infolog': 1,
      \ 'leaderf': 1,
      \ 'mail': 1
      \}
let g:ycm_filetype_specific_completion_to_disable = {
      \ 'gitcommit': 1
      \}
let g:ycm_filepath_blacklist = {
      \ 'html': 1,
      \ 'jsx': 1,
      \ 'xml': 1,
      \}
let g:ycm_show_diagnostics_ui = 1
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>>'
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 1
let g:ycm_echo_current_diagnostic = 1
let g:ycm_always_populate_location_list = 0
let g:ycm_open_loclist_on_ycm_diags = 1
let g:ycm_complete_in_comments = 0
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 0
let g:ycm_collect_identifiers_from_tags_files = 0
let g:ycm_seed_identifiers_with_syntax = 0
let g:ycm_extra_conf_vim_data = []
let g:ycm_server_python_interpreter = ''
let g:ycm_keep_logfiles = 0
let g:ycm_log_level = 'info'
let g:ycm_auto_start_csharp_server = 1
let g:ycm_auto_stop_csharp_server = 1
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_max_diagnostics_to_display = 30
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']
let g:ycm_key_list_stop_completion = ['<C-y>']
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_key_detailed_diagnostics = '<leader>d'
let g:ycm_global_ycm_extra_conf = ''
let g:ycm_confirm_extra_conf = 1
let g:ycm_extra_conf_globlist = []
let g:ycm_filepath_completion_use_working_dir = 0
let g:ycm_semantic_triggers = {}
let g:ycm_cache_omnifunc = 1
let g:ycm_use_ultisnips_completer = 1
let g:ycm_goto_buffer_command = 'same-buffer'
let g:ycm_disable_for_files_larger_than_kb = 1000
let g:ycm_use_clangd = 1
let g:ycm_clangd_binary_path = ''
let g:ycm_clangd_args = []
let g:ycm_clangd_uses_ycmd_caching = 1
let g:ycm_language_server = []
let g:ycm_disable_signature_help = 0
let g:ycm_gopls_binary_path = ''
let g:ycm_gopls_args = []
let g:ycm_rust_toolchain_root = ''
let g:ycm_tsserver_binary_path = ''
let g:ycm_roslyn_binary_path = ''
let g:ycm_update_diagnostics_in_insert_mode = 1

;;; mbfl.el --- support for programming MBFL under GNU Emacs

;; Copyright (C) 2023  Marco Maggi

;; Author: Marco Maggi <mrc.mgg@gmail.com>
;; Created: 2023
;; Keywords: languages

;; This file is part of Marco's Bash Functions Library.
;;
;; This program is  free software: you can redistribute  it and/or modify it under the  terms of the
;; GNU General Public License as published by the  Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
;; even the implied  warranty of MERCHANTABILITY or  FITNESS FOR A PARTICULAR PURPOSE.   See the GNU
;; General Public License for more details.
;;
;; You should have  received a copy of the  GNU General Public License along with  this program.  If
;; not, see <http://www.gnu.org/licenses/>.
;;

;;; Commentary:

;; Add-on to shell mode that supports the MBFL libraries.

;;; Change Log:

;;

;;; Code:

(defface mbfl-function-face
  `((t (:foreground "spring green")))
  "Shell mode custom face used for MBFL functions."
  :group 'sh
  :group 'font-lock-faces)

(defconst mbfl-function-face
  'mbfl-function-face
  "Shell mode custom face used for MBFL functions.")

(defface mbfl-dotest-function-face
  `((t (:foreground "aquamarine")))
  "Shell mode custom face used for MBFL dotest functions."
  :group 'sh
  :group 'font-lock-faces)

(defconst mbfl-dotest-function-face
  'mbfl-dotest-function-face
  "Shell mode custom face used for MBFL dotest functions.")

(defconst mbfl-m4-macros
  (eval-when-compile
    (regexp-opt
     '("m4_define"
       "m4_include"
       "m4_eval"
       "m4_ifelse")
     'symbols)))

(defconst mbfl-known-constants
  (eval-when-compile
    (regexp-opt
     '("mbfl_unspecified"
       "mbfl_undefined"
       "mbfl_CHANGE_DIRECTORY_HOOK" ;This is a variable not a constant.
       )
     'symbols)))

(defconst mbfl-known-types
  (eval-when-compile
    (regexp-opt
     '("mbfl_default_object"
       "mbfl_default_class"
       ;;
       "mbfl_predefined_constant")
     'symbols)))

(defconst mbfl-known-directives
  (eval-when-compile
    (regexp-opt
     '("mbfl_mandatory_parameter"
       "mbfl_mandatory_integer_parameter"
       "mbfl_mandatory_nameref_parameter"
       ;;
       "mbfl_optional_parameter"
       "mbfl_optional_integer_parameter"
       ;;
       "mbfl_command_line_argument"
       "mbfl_extract_command_line_argument"
       ;;
       "mbfl_load_library"
       "mbfl_library_loader"
       "mbfl_embed_library"
       "mbfl_local_varref"
       "mbfl_local_nameref"
       "mbfl_declare_varref"
       "mbfl_declare_global_varref"
       "mbfl_declare_nameref"
       "mbfl_local_index_array_varref"
       "mbfl_local_assoc_array_varref"
       "mbfl_declare_index_array_varref"
       "mbfl_declare_assoc_array_varref"
       "mbfl_unset_varref"
       "mbfl_datavar"
       "mbfl_namevar"
       ;;
       "mbfl_declare_option"
       "mbfl_declare_program"
       "mbfl_declare_exit_code"
       "mbfl_declare_symbolic_array"
       "mbfl_declare_numeric_array"
       "mbfl_local_symbolic_array"
       "mbfl_local_numeric_array"
       ;;
       "mbfl_string_eq"
       "mbfl_string_neq"
       "mbfl_string_lt"
       "mbfl_string_gt"
       "mbfl_string_le"
       "mbfl_string_ge"
       "mbfl_string_eq_yes"
       "mbfl_string_eq_no"
       "mbfl_string_eq_true"
       "mbfl_string_eq_false"
       "mbfl_string_neq_yes"
       "mbfl_string_neq_no"
       "mbfl_string_neq_true"
       "mbfl_string_neq_false"
       "mbfl_string_empty"
       "mbfl_string_not_empty"
       "mbfl_string_last_char"
       ;;
       "mbfl_slots_number"
       "mbfl_slots_values"
       "mbfl_slots_qvalues"
       "mbfl_slots_keys"
       "mbfl_slots_qkeys"
       "mbfl_slot_spec"
       "mbfl_slot_ref"
       "mbfl_slot_qref"
       "mbfl_slot_set"
       "mbfl_slot_append"
       "mbfl_slot_value_len"
       ;;
       "mbfl_string_len"
       "mbfl_string_idx"
       ;;
       "mbfl_set_maybe"
       "mbfl_read_maybe_null"
       ;;
       "__MBFL_LIBRARY__"
       "__PACKAGE_VERSION__"
       "__PACKAGE_DATADIR__"
       ;;
       "MBFL_DEFINE_PROGRAM_EXECUTOR"
       "MBFL_DEFINE_PROGRAM_REPLACER"
       ;;
       "mbflutils_declare_file_struct"
       "mbflutils_file_pathname"
       "mbflutils_file_description"
       "mbflutils_file_owner"
       "mbflutils_file_group"
       "mbflutils_file_mode"
       "mbflutils_file_slot_accessor"
       ;;
       "mbfl_default_object_declare"
       "mbfl_default_object_declare_global"
       "mbfl_default_object_unset"
       "mbfl_default_class_declare"
       "mbfl_default_class_declare_global"
       "mbfl_default_class_unset"
       "_")
     'symbols)))

(defconst mbfl-known-functions
  (eval-when-compile
    (regexp-opt
     '("mbfl_cd"
       "mbfl_change_directory"
       ;;
       "mbfl_array_is_empty"
       "mbfl_array_is_not_empty"
       "mbfl_array_length_var"
       "mbfl_array_length"
       "mbfl_array_contains"
       ;;
       "mbfl_string_is_digit"
       "mbfl_string_is_alpha"
       "mbfl_string_is_alnum"
       "mbfl_string_is_noblank"
       "mbfl_string_is_name"
       "mbfl_string_is_identifier"
       "mbfl_string_is_extended_identifier"
       "mbfl_string_is_ascii_symbol"
       "mbfl_string_is_lower_case_vowel"
       "mbfl_string_is_lower_case_consonant"
       "mbfl_string_is_lower_case_alphabet"
       "mbfl_string_is_lower_case_alnum"
       "mbfl_string_is_lower_case_base16"
       "mbfl_string_is_upper_case_vowel"
       "mbfl_string_is_upper_case_consonant"
       "mbfl_string_is_upper_case_alphabet"
       "mbfl_string_is_upper_case_alnum"
       "mbfl_string_is_upper_case_base16"
       "mbfl_string_is_mixed_case_vowel"
       "mbfl_string_is_mixed_case_consonant"
       "mbfl_string_is_mixed_case_alphabet"
       "mbfl_string_is_mixed_case_alnum"
       "mbfl_string_is_mixed_case_base16"
       "mbfl_string_is_base32"
       "mbfl_string_is_base64"
       "mbfl_string_is_printable_ascii_noblank"
       "mbfl_string_is_network_port"
       "mbfl_string_is_network_hostname"
       "mbfl_string_is_network_ip_address"
       "mbfl_string_is_groupname"
       "mbfl_string_is_username"
       "mbfl_string_is_yes"
       "mbfl_string_is_no"
       "mbfl_string_is_true"
       "mbfl_string_is_false"
       ;;
       "mbfl_sprintf"
       "mbfl_string_chars"
       "mbfl_string_equal"
       "mbfl_string_equal_substring"
       "mbfl_string_first"
       "mbfl_string_first_var"
       "mbfl_string_greater"
       "mbfl_string_greater_or_equal"
       "mbfl_string_index"
       "mbfl_string_index_var"
       "mbfl_string_is_alnum_char"
       "mbfl_string_is_alpha_char"
       "mbfl_string_is_digit_char"
       "mbfl_string_is_email_address"
       "mbfl_string_is_empty"
       "mbfl_string_is_equal_unquoted_char"
       "mbfl_string_is_extended_identifier_char"
       "mbfl_string_is_identifier_char"
       "mbfl_string_is_ascii_symbol_char"
       "mbfl_string_is_lower_case_vowel_char"
       "mbfl_string_is_lower_case_consonant_char"
       "mbfl_string_is_lower_case_alphabet_char"
       "mbfl_string_is_lower_case_alnum_char"
       "mbfl_string_is_lower_case_base16_char"
       "mbfl_string_is_upper_case_vowel_char"
       "mbfl_string_is_upper_case_consonant_char"
       "mbfl_string_is_upper_case_alphabet_char"
       "mbfl_string_is_upper_case_alnum_char"
       "mbfl_string_is_upper_case_base16_char"
       "mbfl_string_is_mixed_case_vowel_char"
       "mbfl_string_is_mixed_case_consonant_char"
       "mbfl_string_is_mixed_case_alphabet_char"
       "mbfl_string_is_mixed_case_alnum_char"
       "mbfl_string_is_mixed_case_base16_char"
       "mbfl_string_is_base32_char"
       "mbfl_string_is_base64_char"
       "mbfl_string_is_printable_ascii_noblank_char"
       "mbfl_string_is_name_char"
       "mbfl_string_is_noblank_char"
       "mbfl_string_is_not_empty"
       "mbfl_string_is_quoted_char"
       ;;
       "mbfl_string_last"
       "mbfl_string_last_var"
       "mbfl_string_length"
       "mbfl_string_length_equal_to"
       "mbfl_string_less"
       "mbfl_string_less_or_equal"
       "mbfl_string_not_equal"
       "mbfl_string_quote"
       "mbfl_string_quote_var"
       "mbfl_string_range"
       "mbfl_string_range_var"
       "mbfl_string_replace"
       "mbfl_string_replace_var"
       "mbfl_string_skip"
       "mbfl_string_split"
       "mbfl_string_split_blanks"
       "mbfl_string_tolower"
       "mbfl_string_tolower_var"
       "mbfl_string_toupper"
       "mbfl_string_toupper_var"
       "mbfl_string_has_prefix"
       "mbfl_string_has_suffix"
       "mbfl_string_has_prefix_and_suffix"
       "mbfl_string_strip_prefix_var"
       "mbfl_string_strip_suffix_var"
       "mbfl_string_strip_prefix_and_suffix_var"
       ;;
       "mbfl_fd_open_input"
       "mbfl_fd_open_output"
       "mbfl_fd_open_input_output"
       "mbfl_fd_dup_input"
       "mbfl_fd_dup_output"
       "mbfl_fd_close"
       "mbfl_fd_move"
       ;;
       "mbfl_exec_cp"
       "mbfl_exec_ln"
       "mbfl_exec_ls"
       "mbfl_exec_mkdir"
       "mbfl_exec_mv"
       "mbfl_exec_readlink"
       "mbfl_exec_realpath"
       "mbfl_exec_rm"
       "mbfl_exec_rmdir"
       "mbfl_exec_stat"
       "mbfl_file_append"
       "mbfl_file_chmod"
       "mbfl_file_compress"
       "mbfl_file_compress_keep"
       "mbfl_file_compress_nokeep"
       "mbfl_file_compress_nostdout"
       "mbfl_file_compress_select_bzip"
       "mbfl_file_compress_select_bzip2"
       "mbfl_file_compress_select_gzip"
       "mbfl_file_compress_select_lzip"
       "mbfl_file_compress_select_xz"
       "mbfl_file_compress_stdout"
       "mbfl_file_copy"
       "mbfl_file_copy_to_directory"
       "mbfl_file_decompress"
       "mbfl_file_directory_is_executable"
       "mbfl_file_directory_is_readable"
       "mbfl_file_directory_is_writable"
       "mbfl_file_directory_validate_writability"
       "mbfl_directory_is_executable"
       "mbfl_directory_is_readable"
       "mbfl_directory_is_writable"
       "mbfl_directory_validate_writability"
       "mbfl_file_dirname"
       "mbfl_file_dirname_var"
       "mbfl_file_enable_compress"
       "mbfl_file_enable_copy"
       "mbfl_file_enable_listing"
       "mbfl_file_enable_make_directory"
       "mbfl_file_enable_move"
       "mbfl_file_enable_owner_and_group"
       "mbfl_file_enable_permissions"
       "mbfl_file_enable_realpath"
       "mbfl_file_enable_remove"
       "mbfl_file_enable_stat"
       "mbfl_file_enable_link"
       "mbfl_file_enable_symlink"
       "mbfl_file_enable_tar"
       "mbfl_file_exists"
       "mbfl_file_extension"
       "mbfl_file_extension_var"
       "mbfl_file_find_tmpdir"
       "mbfl_file_find_tmpdir_var"
       "mbfl_file_get_group"
       "mbfl_file_get_group_var"
       "mbfl_file_get_owner"
       "mbfl_file_get_owner_var"
       "mbfl_file_get_permissions"
       "mbfl_file_get_permissions_var"
       "mbfl_file_get_size"
       "mbfl_file_get_size_var"
       "mbfl_file_is_absolute"
       "mbfl_file_is_absolute_dirname"
       "mbfl_file_is_absolute_filename"
       "mbfl_file_is_directory"
       "mbfl_file_is_executable"
       "mbfl_file_is_file"
       "mbfl_file_is_readable"
       "mbfl_file_is_relative"
       "mbfl_file_is_relative_dirname"
       "mbfl_file_is_relative_filename"
       "mbfl_file_is_symlink"
       "mbfl_file_is_writable"
       "mbfl_file_listing"
       "mbfl_file_long_listing"
       "mbfl_file_make_directory"
       "mbfl_file_make_if_not_directory"
       "mbfl_file_move"
       "mbfl_file_move_to_directory"
       "mbfl_file_normalise"
       "mbfl_file_normalise_link"
       "mbfl_file_normalise_var"
       "mbfl_file_pathname_is_executable"
       "mbfl_file_pathname_is_readable"
       "mbfl_file_pathname_is_writable"
       "mbfl_file_read"
       "mbfl_file_read_link"
       "mbfl_file_realpath"
       "mbfl_file_realpath_var"
       "mbfl_file_remove"
       "mbfl_file_remove_directory"
       "mbfl_file_remove_directory_silently"
       "mbfl_file_remove_file"
       "mbfl_file_remove_file_or_symlink"
       "mbfl_file_remove_symlink"
       "mbfl_file_rootname"
       "mbfl_file_rootname_var"
       "mbfl_file_set_group"
       "mbfl_file_set_owner"
       "mbfl_file_set_permissions"
       "mbfl_file_split"
       "mbfl_file_stat"
       "mbfl_file_stat_var"
       "mbfl_file_strip_leading_slash"
       "mbfl_file_strip_leading_slash_var"
       "mbfl_file_strip_trailing_slash"
       "mbfl_file_strip_trailing_slash_var"
       "mbfl_file_subpathname"
       "mbfl_file_subpathname_var"
       "mbfl_file_link"
       "mbfl_file_symlink"
       "mbfl_file_tail"
       "mbfl_file_tail_var"
       "mbfl_file_write"
       ;;
       "exit_failure"
       "exit_success"
       ;;
       "exit_because_success"
       "exit_because_failure"
       "exit_because_error_loading_library"
       "exit_because_program_not_found"
       "exit_because_wrong_num_args"
       "exit_because_invalid_action_set"
       "exit_because_invalid_action_declaration"
       "exit_because_invalid_action_argument"
       "exit_because_missing_action_function"
       "exit_because_invalid_option_declaration"
       "exit_because_invalid_option_argument"
       "exit_because_invalid_function_name"
       "exit_because_invalid_sudo_username"
       "exit_because_no_location"
       "exit_because_invalid_mbfl_version"
       ;;
       "return_failure"
       "return_success"
       "return_because_success"
       "return_because_failure"
       "return_because_error_loading_library"
       "return_because_program_not_found"
       "return_because_wrong_num_args"
       "return_because_invalid_action_set"
       "return_because_invalid_action_declaration"
       "return_because_invalid_action_argument"
       "return_because_missing_action_function"
       "return_because_invalid_option_declaration"
       "return_because_invalid_option_argument"
       "return_because_invalid_function_name"
       "return_because_invalid_sudo_username"
       "return_because_no_location"
       ;;
       "mbfl_message_set_channel"
       "mbfl_message_set_progname"
       "mbfl_message_string"
       "mbfl_message_debug"
       "mbfl_message_debug_printf"
       "mbfl_message_error"
       "mbfl_message_error_printf"
       "mbfl_message_verbose"
       "mbfl_message_verbose_printf"
       "mbfl_message_verbose_end"
       "mbfl_message_warning"
       "mbfl_message_warning_printf"
       ;;
       "mbfl_program_bash"
       "mbfl_program_bash_command"
       "mbfl_program_declare_sudo_options"
       "mbfl_program_declare_sudo_user"
       "mbfl_program_enable_sudo"
       "mbfl_program_exec"
       "mbfl_program_exec2"
       "mbfl_program_execbg"
       "mbfl_program_execbg2"
       "mbfl_program_find"
       "mbfl_program_find_var"
       "mbfl_program_found"
       "mbfl_program_found_var"
       "mbfl_program_main_validate_programs"
       "mbfl_program_redirect_stderr_to_stdout"
       "mbfl_program_replace"
       "mbfl_program_replace2"
       "mbfl_program_requested_sudo"
       "mbfl_program_reset_exec_flags"
       "mbfl_program_reset_sudo_options"
       "mbfl_program_reset_sudo_user"
       "mbfl_program_reset_stderr_to_stdout"
       "mbfl_program_set_exec_flags"
       "mbfl_program_set_sudo_options"
       "mbfl_program_split_path"
       "mbfl_program_sudo_user"
       "mbfl_program_validate_declared"
       ;;
       "mbfl_process_disown"
       "mbfl_process_wait"
       "mbfl_process_kill"
       "mbfl_process_suspend"
       "mbfl_process_bg"
       "mbfl_process_fg"
       "mbfl_process_jobs"
       "mbfl_process_sleep"
       ;;
       "mbfl_times_and_dates_enable"
       "mbfl_date_current_date"
       "mbfl_date_current_day"
       "mbfl_date_current_hour"
       "mbfl_date_current_minute"
       "mbfl_date_current_month"
       "mbfl_date_current_second"
       "mbfl_date_current_time"
       "mbfl_date_current_year"
       "mbfl_date_email_timestamp"
       "mbfl_date_iso_timestamp"
       ;;
       "mbfl_invoke_existent_script_function"
       "mbfl_invoke_script_function"
       "mbfl_main"
       "mbfl_main_create_exit_functions"
       "mbfl_main_declare_exit_code"
       "mbfl_main_list_exit_codes"
       "mbfl_main_print_exit_code"
       "mbfl_main_print_exit_code_names"
       "mbfl_main_print_license"
       "mbfl_main_print_usage_screen_brief"
       "mbfl_main_print_usage_screen_long"
       "mbfl_main_print_version_number"
       "mbfl_main_print_version_number_only"
       "mbfl_main_set_after_parsing_options"
       "mbfl_main_set_before_parsing_options"
       "mbfl_main_set_main"
       "mbfl_main_set_private_main"
       "mbfl_main_is_exiting"
       "mbfl_exit"
       ;;
       "mbfl_actions_dispatch"
       "mbfl_actions_fake_action_set"
       "mbfl_actions_print_usage_screen"
       "mbfl_actions_set_exists"
       "mbfl_actions_set_exists_or_none"
       "mbfl_declare_action"
       "mbfl_declare_action_set"
       ;;
       "mbfl_argv_all_files"
       "mbfl_argv_from_stdin"
       "mbfl_declare_option"
       "mbfl_getopts_isbrief"
       "mbfl_getopts_isbrief_with"
       "mbfl_getopts_islong"
       "mbfl_getopts_islong_with"
       "mbfl_getopts_parse"
       "mbfl_getopts_reset"
       "mbfl_getopts_print_long_switches"
       "mbfl_getopts_print_usage_screen"
       "mbfl_wrong_num_args"
       "mbfl_wrong_num_args_range"
       "mbfl_getopts_gather_mbfl_options_var"
       "mbfl_getopts_gather_mbfl_options_array"
       ;;
       "mbfl_atexit_clear"
       "mbfl_atexit_disable"
       "mbfl_atexit_enable"
       "mbfl_atexit_forget"
       "mbfl_atexit_register"
       "mbfl_atexit_run"
       ;;
       "mbfl_location_disable_cleanup_atexit"
       "mbfl_location_enable_cleanup_atexit"
       "mbfl_location_enter"
       "mbfl_location_handler"
       "mbfl_location_handler_suspend_testing"
       "mbfl_location_handler_restore_lastpipe"
       "mbfl_location_handler_change_directory"
       "mbfl_location_leave"
       "mbfl_location_run_all"
       ;;
       "mbfl_variable_alloc"
       "mbfl_variable_unset"
       "mbfl_variable_array_to_colon_variable"
       "mbfl_variable_colon_variable_drop_duplicate"
       "mbfl_variable_colon_variable_to_array"
       "mbfl_variable_element_is_in_array"
       "mbfl_variable_find_in_array"
       "mbfl_variable_alloc"
       "mbfl_variable_array_to_colon_variable"
       "mbfl_variable_colon_variable_drop_duplicate"
       "mbfl_variable_colon_variable_to_array"
       "mbfl_variable_element_is_in_array"
       "mbfl_variable_find_in_array"
       ;;
       "mbfl_option_encoded_args"
       "mbfl_set_option_encoded_args"
       "mbfl_unset_option_encoded_args"
       "mbfl_option_verbose"
       "mbfl_set_option_verbose"
       "mbfl_unset_option_verbose"
       "mbfl_option_verbose_program"
       "mbfl_set_option_verbose_program"
       "mbfl_unset_option_verbose_program"
       "mbfl_option_show_program"
       "mbfl_set_option_show_program"
       "mbfl_unset_option_show_program"
       "mbfl_option_test"
       "mbfl_set_option_test"
       "mbfl_unset_option_test"
       "mbfl_option_debug"
       "mbfl_set_option_debug"
       "mbfl_unset_option_debug"
       "mbfl_option_null"
       "mbfl_set_option_null"
       "mbfl_unset_option_null"
       "mbfl_option_interactive"
       "mbfl_set_option_interactive"
       "mbfl_unset_option_interactive"
       "mbfl_option_test_save"
       "mbfl_option_test_restore"
       "mbfl_option_show_program_save"
       "mbfl_option_show_program_restore"
       ;;
       "mbfl_semver_parse"
       "mbfl_semver_reset_config"
       "mbfl_semver_split_prerelease_version"
       "mbfl_semver_compare_var"
       "mbfl_semver_compare_components_var"
       ;;
       "mbfl_system_enable_programs"
       "mbfl_system_whoami"
       "mbfl_system_whoami_var"
       "mbfl_system_id"
       "mbfl_system_id_var"
       "mbfl_system_effective_user_id"
       "mbfl_system_effective_user_name"
       "mbfl_system_effective_group_id"
       "mbfl_system_effective_group_name"
       "mbfl_system_effective_user_id_var"
       "mbfl_system_effective_user_name_var"
       "mbfl_system_effective_group_id_var"
       "mbfl_system_effective_group_name_var"
       "mbfl_system_real_user_id"
       "mbfl_system_real_user_name"
       "mbfl_system_real_group_id"
       "mbfl_system_real_group_name"
       "mbfl_system_real_user_id_var"
       "mbfl_system_real_user_name_var"
       "mbfl_system_real_group_id_var"
       "mbfl_system_real_group_name_var"
       ;;
       "mbfl_system_passwd_reset"
       "mbfl_system_passwd_read"
       "mbfl_system_passwd_print_entries"
       "mbfl_system_passwd_print_entries_as_xml"
       "mbfl_system_passwd_print_entries_as_json"
       "mbfl_system_passwd_get_name_var"
       "mbfl_system_passwd_get_name"
       "mbfl_system_passwd_get_passwd_var"
       "mbfl_system_passwd_get_passwd"
       "mbfl_system_passwd_get_uid_var"
       "mbfl_system_passwd_get_uid"
       "mbfl_system_passwd_get_gid_var"
       "mbfl_system_passwd_get_gid"
       "mbfl_system_passwd_get_gecos_var"
       "mbfl_system_passwd_get_gecos"
       "mbfl_system_passwd_get_dir_var"
       "mbfl_system_passwd_get_dir"
       "mbfl_system_passwd_get_shell_var"
       "mbfl_system_passwd_get_shell"
       "mbfl_system_passwd_find_entry_by_name_var"
       "mbfl_system_passwd_find_entry_by_name"
       "mbfl_system_passwd_find_entry_by_uid_var"
       "mbfl_system_passwd_find_entry_by_uid"
       "mbfl_system_passwd_uid_to_name_var"
       "mbfl_system_passwd_uid_to_name"
       "mbfl_system_passwd_name_to_uid_var"
       "mbfl_system_passwd_name_to_uid"
       ;;
       "mbfl_system_group_reset"
       "mbfl_system_group_read"
       "mbfl_system_group_print_entries"
       "mbfl_system_group_print_entries_as_xml"
       "mbfl_system_group_print_entries_as_json"
       "mbfl_system_group_get_name_var"
       "mbfl_system_group_get_name"
       "mbfl_system_group_get_passwd_var"
       "mbfl_system_group_get_passwd"
       "mbfl_system_group_get_gid_var"
       "mbfl_system_group_get_gid"
       "mbfl_system_group_get_users_var"
       "mbfl_system_group_get_users"
       "mbfl_system_group_get_users_count_var"
       "mbfl_system_group_get_users_count"
       "mbfl_system_group_get_user_name_var"
       "mbfl_system_group_get_user_name"
       "mbfl_system_group_find_entry_by_name_var"
       "mbfl_system_group_find_entry_by_name"
       "mbfl_system_group_find_entry_by_gid_var"
       "mbfl_system_group_find_entry_by_gid"
       "mbfl_system_group_gid_to_name_var"
       "mbfl_system_group_gid_to_name"
       "mbfl_system_group_name_to_gid_var"
       "mbfl_system_group_name_to_gid"
       "mbfl_system_numerical_group_id_to_name"
       "mbfl_system_group_name_to_numerical_id"
       ;;
       "mbfl_system_numerical_user_id_to_name"
       "mbfl_system_user_name_to_numerical_id"
       ;;
       "mbfl_shell_is_function"
       ;;
       "mbfl_dialog_enable_programs"
       "mbfl_dialog_yes_or_no"
       "mbfl_dialog_ask_password"
       "mbfl_dialog_ask_password_var"
       ;;
       "mbfl_math_expr"
       "mbfl_math_expr_var"
       ;;
       "mbfl_vc_git_enable"
       "mbfl_vc_git_config_option_define"
       "mbfl_vc_git_config_option_is_a"
       "mbfl_vc_git_config_option_database_var"
       "mbfl_vc_git_config_option_database_set"
       "mbfl_vc_git_config_option_key_var"
       "mbfl_vc_git_config_option_key_set"
       "mbfl_vc_git_config_option_default_value_var"
       "mbfl_vc_git_config_option_default_value_set"
       "mbfl_vc_git_config_option_type_var"
       "mbfl_vc_git_config_option_type_set"
       "mbfl_vc_git_config_option_terminator_var"
       "mbfl_vc_git_config_option_terminator_set"
       "mbfl_vc_git_config_option_flags_var"
       "mbfl_vc_git_config_option_value_var"
       "mbfl_vc_git_config_option_value_set"
       "mbfl_vc_git_repository_top_srcdir_var"
       "mbfl_vc_git_repository_top_srcdir"
       "mbfl_vc_git_program"
       ;;
       "mbfl_hook_define"
       "mbfl_hook_add"
       "mbfl_hook_run"
       "mbfl_hook_reset"
       ;;
       "mbfl_default_object_define"
       "mbfl_default_object_is_a"
       "mbfl_default_object_is_of_class"
       "mbfl_default_object_class_var"
       "mbfl_default_object_is_the_default_object"
       "mbfl_default_object_is_the_default_class"
       "mbfl_default_class_define"
       "mbfl_default_class_is_a"
       "mbfl_default_metaclass_is_a"
       "mbfl_default_class_parent_var"
       "mbfl_default_class_name_var"
       "mbfl_default_class_fields_number_var"
       "mbfl_default_classes_are_parent_and_child"
       ;;
       "mbfl_predefined_constant_define"
       "mbfl_predefined_constant_is_a"
       "mbfl_is_the_undefined"
       "mbfl_is_the_unspecified"
       ;;
       "mbflutils_file_init_file_struct"
       "mbflutils_file_init_directory_struct"
       "mbflutils_file_stat"
       "mbflutils_file_normalise"
       "mbflutils_file_install")
     'symbols)))

(defconst mbfl-dotest-known-functions
  (eval-when-compile
    (regexp-opt
     '("dotest"
       "dotest-assert-file-exists"
       "dotest-assert-file-unexists"
       "dotest-cd"
       "dotest-cd-tmpdir"
       "dotest-clean-files"
       "dotest-echo-tmpdir"
       "dotest-equal"
       "dotest-final-report"
       "dotest-mkdir"
       "dotest-mkfile"
       "dotest-mkpathname"
       "dotest-mktmpdir"
       "dotest-output"
       "dotest-program-exec"
       "dotest-program-mkdir"
       "dotest-program-rm"
       "dotest-string-is-empty"
       "dotest-string-is-not-empty"
       "dotest-set-debug"
       "dotest-unset-debug"
       "dotest-option-debug"
       "dotest-set-verbose"
       "dotest-unset-verbose"
       "dotest-option-verbose"
       "dotest-set-test"
       "dotest-unset-test"
       "dotest-option-test"
       "dotest-set-report-start"
       "dotest-unset-report-start"
       "dotest-option-report-start"
       "dotest-set-report-success"
       "dotest-unset-report-success"
       "dotest-option-report-success"
       "dotest-debug"
       "dotest-echo"
       "dotest-printf")
     'symbols)))

;;We perform this  call to `font-lock-add-keywords' at  the top-level, so the  configuration is done
;;only once at file-loading time.
;;
(font-lock-add-keywords
    ;;This argument MODE is  set to `sh-mode' because this call is performed  at the top-level.  See
    ;;the documentation of `font-lock-add-keywords' for details.
    'sh-mode

  ;;Here  we need  to  remember that  "(regexp-opt  ... 'symbols)"  encloses  the generated  regular
  ;;expression between  '\_<\(' and  '\)\_>' so  the SUBEXP  number must  be 1  to match  the actual
  ;;symbol.
  ;;
  `(
    ;;GNU m4 macros that might be present when the MBFL preprocessor is used.
    (,mbfl-m4-macros . font-lock-keyword-face)

    ;;Abuse the keyword face to fontify some MBFL preprocessor macro names.
    (,mbfl-known-directives 1 font-lock-keyword-face)

    ;;MBFL known functions.
    (,mbfl-known-functions 1 mbfl-function-face keep)

    ;;MBFL dotest known functions.
    (,mbfl-dotest-known-functions 1 mbfl-dotest-function-face keep)

    ;;MBFL known constants.
    (,mbfl-known-constants 1 font-lock-constant-face keep)

    ;;MBFL known types.
    (,mbfl-known-types 1 font-lock-type-face keep)
    )

  ;;This  true value  as HOW  argument causes  this specification  to be  appended to  the value  of
  ;;`font-lock-keywords'.
  ;;
  ;;We need it to  allow correct fontification of known function names, which  must happen after the
  ;;fontification built into `sh-mode'.
  t)

(provide 'mbfl)
;;; my-shell-language.el ends here
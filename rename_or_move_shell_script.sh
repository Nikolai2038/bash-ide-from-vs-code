#!/bin/bash

# Fail command if any of pipeline blocks fail
set -o pipefail

# Escape pattern for "sed -E" command
escape_sed() {
  echo "${@}" | sed -e 's/[]\/#$&*.^;|{}()[]/\\&/g' || return "$?"
  return 0
}

# Sort sources in the specified file
sort_sources() {
  local file_path="${1}" && { shift || true; }

  # File content
  local file_content
  file_content="$(cat "${file_path}")" || return "$?"

  # Lines of the file content
  declare -a file_lines
  # Make sure to add empty line, so the "for" cycle will check all source blocks
  mapfile -t file_lines <<< "${file_content}
" || return "$?"

  # New file content - with sorted "source" blocks
  local new_file_content

  local was_source=0
  local sources_to_sort=""

  local line
  for line in "${file_lines[@]}"; do
    if [[ ! ${line} =~ ^source[[:blank:]] ]]; then
      if ((was_source)); then
        # Sort and remove empty line at the end
        sources_to_sort="$(echo -n "${sources_to_sort}" | sort | grep -v '^$')" || return "$?"
        if [ -n "${new_file_content}" ]; then
          new_file_content+="
" || return "$?"
        fi
        new_file_content+="${sources_to_sort}" || return "$?"
      fi

      was_source=0
      sources_to_sort=""
      if [ -n "${new_file_content}" ]; then
        new_file_content+="
" || return "$?"
      fi
      new_file_content+="${line}" || return "$?"
    else
      was_source=1
      if [ -n "${sources_to_sort}" ]; then
        sources_to_sort+="
" || return "$?"
      fi
      sources_to_sort+="${line}" || return "$?"
    fi
  done

  # Remove one empty line at the end because we added it when converting to array
  # shellcheck disable=SC2320
  echo -n "${new_file_content}" > "${file_path}" || return "$?"

  return 0
}

# Update references in sources when file was moved
rename_or_move_shell_script() {
  local workspace_full_path="${1}" && { shift || true; }
  local file_full_path_old="${1}" && { shift || true; }
  local file_full_path_new="${1}" && { shift || true; }

  local basename
  basename=$(basename "${file_full_path_old}") || return "$?"

  # ========================================
  # Rename all references to moved file
  # ========================================
  local shell_scripts_in_workspace_as_string
  shell_scripts_in_workspace_as_string="$(find "${workspace_full_path}" -type f -name '*.sh')" || return "$?"

  # Convert to array
  declare -a shell_scripts_in_workspace
  mapfile -t shell_scripts_in_workspace <<< "${shell_scripts_in_workspace_as_string}" || return "$?"

  local shell_script_in_workspace
  for shell_script_in_workspace in "${shell_scripts_in_workspace[@]}"; do
    # Only look for files, which explicitly contain old basename of the file renamed
    if ! grep --quiet "${basename}" "${shell_script_in_workspace}"; then
      continue
    fi

    # Replace all absolute paths
    sed -Ei "s#$(escape_sed "${file_full_path_old}")#$(escape_sed "${file_full_path_new}")#g" "${shell_script_in_workspace}" || return "$?"

    # Replace all relative paths
    local directory_with_script
    directory_with_script=$(dirname "${shell_script_in_workspace}") || return "$?"
    relative_file_path_old=$(realpath --relative-to="${directory_with_script}" "${file_full_path_old}") || return "$?"
    relative_file_path_new=$(realpath --relative-to="${directory_with_script}" "${file_full_path_new}") || return "$?"
    sed -Ei "s#$(escape_sed "${relative_file_path_old}")#$(escape_sed "${relative_file_path_new}")#g" "${shell_script_in_workspace}" || return "$?"

    # Sort sources in referenced file
    sort_sources "${shell_script_in_workspace}" || return "$?"
  done
  # ========================================

  # ========================================
  # Rename all references in moved file
  # ========================================
  local directory_with_script_old
  directory_with_script_old="$(realpath "$(dirname "${file_full_path_old}")")" || return "$?"

  local directory_with_script_new
  directory_with_script_new="$(realpath "$(dirname "${file_full_path_new}")")" || return "$?"

  # If directory remain the same
  if [ "${directory_with_script_old}" = "${directory_with_script_new}" ]; then
    echo "Directory remain the same - skipping..." >&2
    return 0
  fi

  local lines_as_string
  lines_as_string="$(sed -En '/^.+\.sh.*$/p' "${file_full_path_new}")" || return "$?"

  # If no paths to scripts found in moved file
  if [ -z "${lines_as_string}" ]; then
    echo "No paths to scripts found in moved file - skipping..." >&2
    return 0
  fi
  #echo "lines_as_string ${lines_as_string}" >&2

  # Convert to array
  declare -a lines
  mapfile -t lines <<< "${lines_as_string}" || return "$?"

  local line
  for line in "${lines[@]}"; do
    # Simulate the same interpretation of words as in shell
    # shellcheck disable=SC2206
    declare -a words=(${line})
    for word in "${words[@]}"; do
      # Remove quotation marks around the word if they exist
      word="$(echo "${word}" | sed -En "s/[\"']?([^\"']+)[\"']?/\1/p")"

      local possible_file_path
      possible_file_path="${directory_with_script_old}/${word}"

      # If no suck file exist - we skip it
      if [ ! -f "${possible_file_path}" ]; then
        continue
      fi

      local replace_from
      replace_from="$(realpath --relative-to="${directory_with_script_old}" "${possible_file_path}")" || return "$?"

      local replace_to
      replace_to="$(realpath --relative-to="${directory_with_script_new}" "${possible_file_path}")" || return "$?"

      # If nothing changed
      if [ "${replace_from}" = "${replace_to}" ]; then
        continue
      fi

      echo "Replacing \"${replace_from}\" to \"${replace_to}\"..." >&2

      sed -Ei "s#$(escape_sed "${replace_from}")#$(escape_sed "${replace_to}")#g" "${file_full_path_new}" || return "$?"
    done
  done
  # ========================================

  # Sort sources in moved file
  sort_sources "${file_full_path_new}" || return "$?"

  return 0
}

rename_or_move_shell_script "${@}" || exit "$?"

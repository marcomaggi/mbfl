#! libmbfl-arch.bash --
#!
#! Part of: Marco's BASH Functions Library
#! Contents: archiving and compressing files
#! Date: Nov 26, 2020
#!
#! Abstract
#!
#!
#! Copyright (c) 2005, 2009, 2013, 2018, 2020, 2023 Marco Maggi
#! <mrc.mgg@gmail.com>
#!
#! This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
#! General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
#! License, or (at your option) any later version.
#!
#! This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
#! even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
#! Lesser General Public License for more details.
#!
#! You should have received a copy of the  GNU Lesser General Public License along with this library;
#! if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
#! 02111-1307 USA.
#!


#### "tar" interface

function mbfl_file_enable_tar () {
    mbfl_declare_program tar
}
function mbfl_exec_tar () {
    mbfl_local_varref(TAR)
    local FLAGS
    mbfl_program_found_var mbfl_datavar(TAR) tar || exit_because_program_not_found
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    mbfl_program_exec "$TAR" ${FLAGS} "$@"
}
function mbfl_tar_exec () {
    mbfl_exec_tar "$@"
}

function mbfl_tar_create_to_stdout () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    shift
    mbfl_exec_tar --directory="$DIRECTORY" --create --file=- "$@" .
}
function mbfl_tar_extract_from_stdin () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    shift
    mbfl_exec_tar --directory="$DIRECTORY" --extract --file=- "$@"
}
function mbfl_tar_extract_from_file () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    mbfl_mandatory_parameter(ARCHIVE_FILENAME, 2, archive pathname)
    shift 2
    mbfl_exec_tar --directory="$DIRECTORY" --extract --file="$ARCHIVE_FILENAME" "$@"
}
function mbfl_tar_create_to_file () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    mbfl_mandatory_parameter(ARCHIVE_FILENAME, 2, archive pathname)
    shift 2
    mbfl_exec_tar --directory="$DIRECTORY" --create --file="$ARCHIVE_FILENAME" "$@" .
}
function mbfl_tar_archive_directory_to_file () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    mbfl_mandatory_parameter(ARCHIVE_FILENAME, 2, archive pathname)
    shift 2
    local PARENT DIRNAME
    mbfl_file_dirname_var PARENT "$DIRECTORY"
    mbfl_file_tail_var DIRNAME "$DIRECTORY"
    mbfl_exec_tar --directory="$PARENT" --create --file="$ARCHIVE_FILENAME" "$@" "$DIRNAME"
}
function mbfl_tar_list () {
    mbfl_mandatory_parameter(ARCHIVE_FILENAME, 1, archive pathname)
    shift
    mbfl_exec_tar --list --file="$ARCHIVE_FILENAME" "$@"
}


#### compression interface functions

mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_gzip
mbfl_p_file_compress_KEEP_ORIGINAL=false
mbfl_p_file_compress_TO_STDOUT=false

function mbfl_file_enable_compress () {
    mbfl_declare_program gzip
    mbfl_declare_program bzip2
    mbfl_declare_program lzip
    mbfl_declare_program xz
    mbfl_file_compress_select_gzip
    mbfl_file_compress_nokeep
}

function mbfl_file_compress_keep     () { mbfl_p_file_compress_KEEP_ORIGINAL=true;  }
function mbfl_file_compress_nokeep   () { mbfl_p_file_compress_KEEP_ORIGINAL=false; }
function mbfl_file_compress_stdout   () { mbfl_p_file_compress_TO_STDOUT=true;      }
function mbfl_file_compress_nostdout () { mbfl_p_file_compress_TO_STDOUT=false;     }

function mbfl_file_compress_select_gzip () {
    mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_gzip
}
function mbfl_file_compress_select_bzip2 () {
    mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_bzip2
}
function mbfl_file_compress_select_bzip () {
    mbfl_file_compress_select_bzip2
}
function mbfl_file_compress_select_lzip () {
    mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_lzip
}
function mbfl_file_compress_select_xz () {
    mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_xz
}

function mbfl_file_compress () {
    mbfl_mandatory_parameter(FILE, 1, uncompressed source file)
    shift
    mbfl_p_file_compress compress "$FILE" "$@"
}

function mbfl_file_decompress () {
    mbfl_mandatory_parameter(FILE, 1, compressed source file)
    shift
    mbfl_p_file_compress decompress "$FILE" "$@"
}

function mbfl_p_file_compress () {
    mbfl_mandatory_parameter(MODE, 1, compression/decompression mode)
    mbfl_mandatory_parameter(FILE, 2, target file)
    shift 2
    if mbfl_file_is_file "$FILE"
    then ${mbfl_p_file_compress_FUNCTION} ${MODE} "$FILE" "$@"
    else
        mbfl_message_error_printf 'compression target is not a file "%s"' "$FILE"
        return_because_failure
    fi
}


#### compression action functions: gzip

function mbfl_p_file_compress_gzip () {
    mbfl_mandatory_parameter(COMPRESS, 1, compress/decompress mode)
    mbfl_mandatory_parameter(SOURCE, 2, source file)
    shift 2
    mbfl_local_varref(COMPRESSOR)
    local FLAGS='--force' DEST

    mbfl_program_found_var mbfl_datavar(COMPRESSOR) gzip || exit_because_program_not_found
    case $COMPRESS in
        compress)
            printf -v DEST '%s.gz' "$SOURCE"
            ;;
        decompress)
            mbfl_file_rootname_var DEST "$SOURCE"
            FLAGS+=' --decompress'
            ;;
        *)
            mbfl_message_error_printf 'internal error: wrong mode "%s" in "%s"' "$COMPRESS" "$FUNCNAME"
            exit_failure
            ;;
    esac

    if mbfl_option_verbose_program
    then FLAGS+=' --verbose'
    fi

    if $mbfl_p_file_compress_TO_STDOUT
    then
	# When   writing   to   stdout:  we   ignore   the   keep/nokeep
	# configuration and always keep.
        FLAGS+=' --keep --stdout'
        mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
    else
	# The   output  goes   to   a  file:   honour  the   keep/nokeep
	# configuration.
	if $mbfl_p_file_compress_KEEP_ORIGINAL
	then FLAGS+=' --keep'
	fi
	mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
    fi
}


#### compression action functions: bzip2

function mbfl_p_file_compress_bzip2 () {
    mbfl_mandatory_parameter(COMPRESS, 1, compress/decompress mode)
    mbfl_mandatory_parameter(SOURCE, 2, target file)
    shift 2
    mbfl_local_varref(COMPRESSOR)
    local FLAGS='--force' DEST

    mbfl_program_found_var mbfl_datavar(COMPRESSOR) bzip2 || exit_because_program_not_found
    case $COMPRESS in
        compress)
            printf -v DEST '%s.bz2' "$SOURCE"
            FLAGS+=' --compress'
            ;;
        decompress)
            mbfl_file_rootname_var DEST "$SOURCE"
            FLAGS+=' --decompress'
            ;;
        *)
            mbfl_message_error_printf 'internal error: wrong mode "%s" in "%s"' "$COMPRESS" "$FUNCNAME"
            exit_failure
            ;;
    esac

    if mbfl_option_verbose_program
    then FLAGS+=' --verbose'
    fi

    if $mbfl_p_file_compress_TO_STDOUT
    then
	# When   writing   to   stdout:  we   ignore   the   keep/nokeep
	# configuration and always keep.
	FLAGS+=' --keep --stdout'
	mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
    else
	# The   output  goes   to   a  file:   honour  the   keep/nokeep
	# configuration.
	if $mbfl_p_file_compress_KEEP_ORIGINAL
	then FLAGS+=' --keep'
	fi
	mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
    fi
}


#### compression action functions: lzip

function mbfl_p_file_compress_lzip () {
    mbfl_mandatory_parameter(COMPRESS, 1, compress/decompress mode)
    mbfl_mandatory_parameter(SOURCE, 2, source file)
    shift 2
    mbfl_local_varref(COMPRESSOR)
    local FLAGS='--force' DEST

    mbfl_program_found_var mbfl_datavar(COMPRESSOR) lzip || exit_because_program_not_found
    case $COMPRESS in
        compress)
            printf -v DEST '%s.lz' "$SOURCE"
            ;;
        decompress)
            mbfl_file_rootname_var DEST "$SOURCE"
            FLAGS+=' --decompress'
            ;;
        *)
            mbfl_message_error_printf 'internal error: wrong mode "%s" in "%s"' "$COMPRESS" "$FUNCNAME"
            exit_failure
            ;;
    esac

    if mbfl_option_verbose_program
    then FLAGS+=' --verbose'
    fi

    if $mbfl_p_file_compress_TO_STDOUT
    then
	# When   writing   to   stdout:  we   ignore   the   keep/nokeep
	# configuration and always keep.
        FLAGS+=' --keep --stdout'
        mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
    else
	# The   output  goes   to   a  file:   honour  the   keep/nokeep
	# configuration.
	if $mbfl_p_file_compress_KEEP_ORIGINAL
	then FLAGS+=' --keep'
	fi
	mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
    fi
}


#### compression action functions: xz

function mbfl_p_file_compress_xz () {
    mbfl_mandatory_parameter(COMPRESS, 1, compress/decompress mode)
    mbfl_mandatory_parameter(SOURCE, 2, source file)
    shift 2
    mbfl_local_varref(COMPRESSOR)
    local FLAGS='--force' DEST

    mbfl_program_found_var mbfl_datavar(COMPRESSOR) xz || exit_because_program_not_found
    case $COMPRESS in
        compress)
            printf -v DEST '%s.xz' "$SOURCE"
            ;;
        decompress)
            mbfl_file_rootname_var DEST "$SOURCE"
            FLAGS+=' --decompress'
            ;;
        *)
            mbfl_message_error_printf 'internal error: wrong mode "%s" in "%s"' "$COMPRESS" "$FUNCNAME"
            exit_failure
            ;;
    esac

    if mbfl_option_verbose_program
    then FLAGS+=' --verbose'
    fi

    if $mbfl_p_file_compress_TO_STDOUT
    then
	# When   writing   to   stdout:  we   ignore   the   keep/nokeep
	# configuration and always keep.
        FLAGS+=' --keep --stdout'
        mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
    else
	# The   output  goes   to   a  file:   honour  the   keep/nokeep
	# configuration.
	if $mbfl_p_file_compress_KEEP_ORIGINAL
	then FLAGS+=' --keep'
	fi
	mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
    fi
}

#!# end of file
# Local Variables:
# mode: sh
# End:

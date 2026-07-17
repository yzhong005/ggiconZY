.plate_reader_numeric <- function(value, context) {
  if (is.numeric(value)) {
    return(as.numeric(value))
  }

  cleaned <- trimws(as.character(value))
  cleaned[cleaned == ""] <- NA_character_
  number <- suppressWarnings(as.numeric(cleaned))
  invalid <- !is.na(cleaned) & is.na(number)
  if (any(invalid)) {
    example <- unique(cleaned[invalid])[[1L]]
    stop(
      "Non-numeric plate-reader value in ", context, ": ", example,
      call. = FALSE
    )
  }
  number
}

.clean_plate_reader_table <- function(value) {
  value <- as.data.frame(value, check.names = FALSE, stringsAsFactors = FALSE)
  names(value) <- trimws(sub("^\\ufeff", "", names(value)))

  empty_column <- vapply(value, function(column) {
    all(is.na(column) | trimws(as.character(column)) == "")
  }, logical(1))
  value <- value[, !empty_column, drop = FALSE]

  if (!ncol(value)) {
    stop("The plate-reader table contains no data columns.", call. = FALSE)
  }

  empty_row <- apply(value, 1L, function(row) {
    all(is.na(row) | trimws(as.character(row)) == "")
  })
  value <- value[!empty_row, , drop = FALSE]
  rownames(value) <- NULL

  if (!nrow(value)) {
    stop("The plate-reader table contains no data rows.", call. = FALSE)
  }
  value
}

.read_plate_reader_file <- function(file, sheet, skip) {
  if (!is.character(file) || length(file) != 1L || is.na(file) || !nzchar(file)) {
    stop("`file` must be a file path or data frame.", call. = FALSE)
  }
  if (!file.exists(file)) {
    stop("Plate-reader file does not exist: ", file, call. = FALSE)
  }

  extension <- tolower(tools::file_ext(file))
  if (extension %in% c("xlsx", "xls")) {
    if (!requireNamespace("readxl", quietly = TRUE)) {
      stop(
        "Reading Excel plate-reader files requires the `readxl` package. ",
        "Install it with install.packages(\"readxl\").",
        call. = FALSE
      )
    }
    return(as.data.frame(
      readxl::read_excel(
        file,
        sheet = sheet,
        skip = skip,
        .name_repair = "minimal"
      ),
      check.names = FALSE,
      stringsAsFactors = FALSE
    ))
  }

  if (extension == "csv") {
    return(utils::read.csv(
      file,
      skip = skip,
      check.names = FALSE,
      stringsAsFactors = FALSE
    ))
  }
  if (extension %in% c("tsv", "txt")) {
    return(utils::read.delim(
      file,
      skip = skip,
      check.names = FALSE,
      stringsAsFactors = FALSE
    ))
  }

  stop(
    "Unsupported plate-reader file type: .", extension,
    ". Use CSV, TSV, TXT, XLS, or XLSX.",
    call. = FALSE
  )
}

.plate_reader_names <- function(value) {
  names <- toupper(trimws(names(value)))
  sub("^X(?=[0-9]+$)", "", names, perl = TRUE)
}

.plate_columns_matrix <- function(value) {
  normalized_names <- .plate_reader_names(value)
  measurement_columns <- match(LETTERS[1:8], normalized_names)
  if (anyNA(measurement_columns)) {
    return(NULL)
  }

  identifier_candidates <- setdiff(seq_len(ncol(value)), measurement_columns)
  identifier <- NULL
  identifier_values <- NULL
  for (candidate in identifier_candidates) {
    parsed <- suppressWarnings(as.integer(trimws(as.character(value[[candidate]]))))
    if (!anyNA(parsed) && setequal(parsed, 1:12) && length(parsed) == 12L) {
      identifier <- candidate
      identifier_values <- parsed
      break
    }
  }
  if (is.null(identifier)) {
    return(NULL)
  }

  order <- match(1:12, identifier_values)
  columns <- lapply(seq_along(measurement_columns), function(index) {
    name <- LETTERS[index]
    .plate_reader_numeric(
      value[[measurement_columns[[index]]]][order],
      paste0("plate row ", name)
    )
  })
  matrix <- do.call(rbind, columns)
  dimnames(matrix) <- list(LETTERS[1:8], as.character(1:12))
  matrix
}

.plate_rows_matrix <- function(value) {
  normalized_names <- .plate_reader_names(value)
  measurement_columns <- match(as.character(1:12), normalized_names)
  if (anyNA(measurement_columns)) {
    return(NULL)
  }

  identifier_candidates <- setdiff(seq_len(ncol(value)), measurement_columns)
  identifier <- NULL
  identifier_values <- NULL
  for (candidate in identifier_candidates) {
    parsed <- toupper(trimws(as.character(value[[candidate]])))
    if (!anyNA(parsed) && setequal(parsed, LETTERS[1:8]) && length(parsed) == 8L) {
      identifier <- candidate
      identifier_values <- parsed
      break
    }
  }
  if (is.null(identifier)) {
    return(NULL)
  }

  order <- match(LETTERS[1:8], identifier_values)
  columns <- lapply(seq_along(measurement_columns), function(index) {
    .plate_reader_numeric(
      value[[measurement_columns[[index]]]][order],
      paste0("plate column ", index)
    )
  })
  matrix <- do.call(cbind, columns)
  dimnames(matrix) <- list(LETTERS[1:8], as.character(1:12))
  matrix
}

.long_plate_matrix <- function(value, value_column = NULL) {
  well_pattern <- "^[A-H](?:0?[1-9]|1[0-2])$"
  well_column <- NULL
  normalized_names <- .plate_reader_names(value)
  named_well <- which(normalized_names %in% c("WELL", "WELL ID", "WELL_ID"))

  candidates <- c(named_well, setdiff(seq_len(ncol(value)), named_well))
  for (candidate in candidates) {
    wells <- toupper(trimws(as.character(value[[candidate]])))
    if (all(is.na(wells) | grepl(well_pattern, wells))) {
      well_column <- candidate
      break
    }
  }
  if (is.null(well_column)) {
    return(NULL)
  }

  if (is.null(value_column)) {
    preferred <- which(normalized_names %in% c(
      "VALUE", "LABEL", "READING", "OD", "OD600", "ABSORBANCE",
      "FLUORESCENCE", "LUMINESCENCE"
    ))
    preferred <- setdiff(preferred, well_column)
    if (length(preferred)) {
      value_column <- preferred[[1L]]
    } else {
      numeric_candidates <- setdiff(seq_len(ncol(value)), well_column)
      usable <- vapply(numeric_candidates, function(candidate) {
        raw <- trimws(as.character(value[[candidate]]))
        raw[raw == ""] <- NA_character_
        parsed <- suppressWarnings(as.numeric(raw))
        all(is.na(raw) | !is.na(parsed)) && any(!is.na(parsed))
      }, logical(1))
      numeric_candidates <- numeric_candidates[usable]
      if (length(numeric_candidates) != 1L) {
        stop(
          "Could not choose one measurement column in the long plate-reader ",
          "table; set `value_column` explicitly.",
          call. = FALSE
        )
      }
      value_column <- numeric_candidates[[1L]]
    }
  } else if (is.character(value_column)) {
    if (length(value_column) != 1L || !value_column %in% names(value)) {
      stop("`value_column` does not name a column in the table.", call. = FALSE)
    }
    value_column <- match(value_column, names(value))
  } else if (is.numeric(value_column)) {
    if (length(value_column) != 1L || is.na(value_column) ||
        value_column < 1 || value_column > ncol(value) ||
        value_column != as.integer(value_column)) {
      stop("`value_column` is outside the table.", call. = FALSE)
    }
    value_column <- as.integer(value_column)
  } else {
    stop("`value_column` must be NULL, a column name, or a column number.",
         call. = FALSE)
  }

  wells <- toupper(trimws(as.character(value[[well_column]])))
  wells <- sub("^([A-H])0([1-9])$", "\\1\\2", wells)
  keep <- !is.na(wells) & nzchar(wells)
  wells <- wells[keep]
  readings <- .plate_reader_numeric(
    value[[value_column]][keep],
    paste0("measurement column `", names(value)[[value_column]], "`")
  )

  if (anyDuplicated(wells)) {
    stop("The long plate-reader table contains duplicate well IDs.", call. = FALSE)
  }

  expected <- as.vector(t(outer(LETTERS[1:8], 1:12, paste0)))
  output <- rep(NA_real_, 96L)
  output[match(wells, expected)] <- readings
  matrix <- matrix(output, nrow = 8L, byrow = TRUE)
  dimnames(matrix) <- list(LETTERS[1:8], as.character(1:12))
  matrix
}

#' Read a plate-reader export
#'
#' @param file Path to a CSV, TSV, TXT, XLS, or XLSX export, or an already
#'   imported data frame.
#' @param sheet Excel sheet name or number.
#' @param skip Number of metadata rows before the table header.
#' @param layout Input layout: automatic detection, `"plate_columns"` for the
#'   12-row layout with A-H measurement columns, `"plate_rows"` for the 8-row
#'   layout with columns 1-12, or `"long"` for Well/Value data.
#' @param value_column Measurement column used for long data. Supply a name or
#'   one-based column number when the export contains multiple measurements.
#'
#' @return An 8 by 12 numeric matrix with row names A-H and column names 1-12,
#'   ready for [well_plate_plot()].
#' @export
read_plate_reader <- function(
    file,
    sheet = 1,
    skip = 0,
    layout = c("auto", "plate_columns", "plate_rows", "long"),
    value_column = NULL) {
  layout <- match.arg(layout)
  if (!is.numeric(skip) || length(skip) != 1L || is.na(skip) ||
      skip < 0 || skip != as.integer(skip)) {
    stop("`skip` must be one non-negative integer.", call. = FALSE)
  }

  if (is.data.frame(file)) {
    value <- file
  } else {
    value <- .read_plate_reader_file(file, sheet = sheet, skip = as.integer(skip))
  }
  value <- .clean_plate_reader_table(value)

  readers <- switch(
    layout,
    auto = list(
      plate_columns = .plate_columns_matrix,
      plate_rows = .plate_rows_matrix,
      long = function(data) .long_plate_matrix(data, value_column)
    ),
    plate_columns = list(plate_columns = .plate_columns_matrix),
    plate_rows = list(plate_rows = .plate_rows_matrix),
    long = list(long = function(data) .long_plate_matrix(data, value_column))
  )

  for (name in names(readers)) {
    result <- readers[[name]](value)
    if (!is.null(result)) {
      attr(result, "plate_reader_layout") <- name
      return(result)
    }
  }

  stop(
    "Could not recognize the plate-reader layout. Expected A-H measurement ",
    "columns, columns 1-12, or long Well/Value data. Use `skip` to remove ",
    "instrument metadata rows and set `layout` or `value_column` if needed.",
    call. = FALSE
  )
}

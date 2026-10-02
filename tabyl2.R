##### tabyl2() #####

## to do:
# remove "A tibble" and <int> lines - from 1/2-way (not 3 way, dont know why, but 3 way missing adorn title and still $ labels and have "attr" text at bottom)
### maybe issue is print methods need to be exported?!





# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# S3 PRINT METHOD DEFINITIONS (Defined outside, in file/namespace scope)
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


# clear tibble header
tbl_format_header.tabyl_clean <- function(x, setup, ...) {
  character() # Drops "# A tibble"
}

box::register_S3_method("tbl_format_header", "tabyl_clean", tbl_format_header.tabyl_clean)

# # clear footer
# tbl_format_footer.tabyl_clean <- function(x, setup, ...) {
#   character() # Drops footer notes if columns are truncated
# }



# Main Print Dispatch
print.tabyl_clean <- function(x, n_rows = 30, extra_digits = NULL, ...) {
  
  extra_digits <- extra_digits %||% attr(x, "extra_digits")
  
  
  
  
  extra_digits <- 0
  
  
  
  
  fmt_pct <- function(x) {
    threshold_995  <- paste0("9.9", rep("9", extra_digits), "5") |> as.numeric()  # 9.95  or 9.9(.9.)5
    # threshold_095  <- threshold_995 - 9                                           # 0.95  or 0.9(.9.)5  -- paste0("0.9", rep("9", extra_digits), "5") |> as.numeric()
    threshold_0005 <- paste0("0.00", rep("0", extra_digits), "5") |> as.numeric() # 0.005 or 0.00(.0.)5
    #
    n <- if_else(x >= threshold_995 - 9, 2L, 1L) + extra_digits     # sig figs: 2 if big enough, only 1 if x < 0.9(.9.)5
    mag <- floor(log10(signif(x, 2))) + 1L   # digits left of decimal, mag = magnitude?
      # case_when(
        # x>99999 ~ 0,# between(x, threshold_095, 1)     ~ 1L,                  # was: | between(x, 0.095, 0.1)
        # .default                         = 
      # )
    dec <- pmax(n - mag, 0L) # dec = decimals after 0 to show? yes, that's what sprintf does!
    out <- sprintf("%.*f", dec, x)
    out2 <- 
      case_when(
        x < threshold_0005  ~ paste0(" 0.00", rep(0, extra_digits)),   # clamp near-zero, < 0.00(.0.)5   -- recode_values(extra_digits,0 ~ " 0.00",1 ~ " 0.00")
        x < threshold_995   ~ paste0(" ", out),  # pad with one space if <10 (post-rounding)
        .default    = out                      
      )
    out3 <- 
      case_when(
        x < 1     ~ out2 |> stringr::str_replace("10$", "1"),
        .default  = out2
      ) # testing: x <- 0; out2 <- "0.510"; if_else(x < 1, out2 |> stringr::str_replace("10$", "1"), out2)
    # mag
    # n
    out3
  }
  c(41, 10, 9.99, 9.94, 4.1, 1.01, 0.999, 0.96, 0.91, 0.41, 0.101, 0.096, 0.041, 0.0096, 0.0041) %>% tibble(a = ., b = fmt_pct(.))
  #     -> "41"   "4.1"  "0.4"  "0.04" "0.00"
  #     want 0.1 not 0.10!               --> 0.09, 0.1,           0.2
  #     want 1.0! because 1.1 possible!  -->  0.9,   1.0, 1.1 ...   2.0
  
  
  # but then want 1.00 IF 1.01 possible! etc...
  
  
  x <- 99; out2 <- "1.0"; if_else(x < 1, out2 |> stringr::str_replace("10$", "1"), out2)
  
  
  
  # throw out this workaround manual stuff just use pillar digits thing etc? see claude!!!!
  
  
  
  # stuck on this while chekcing tabyl output from tbl_stratify! check that then validation for excl!
  
  
  
  
  
  
  # If 3-way, apply class to each child tibble in the list
  if (is.list(x) && !is.data.frame(x)) {
    the_call <- attr(x, "tabyl_call")
    grp_var <- the_call[5] |> as.character()
    cat(grp_var, " = ...\n\n", sep = "")
    x <- map(x, function(slice) {
      slice_tb <- as_tibble(slice)
      # Retain original attributes
      attributes(slice_tb) <- c(attributes(slice_tb), attributes(slice)[c("core", "tabyl_type", "var_names")])
      attr(slice_tb, "tabyl_call") <- the_call
      class(slice_tb) <- c("tabyl_clean", "tbl_df", "tbl", class(slice_tb))
      slice_tb
    })
    # class(x) <- c("tabyl_clean", class(x))
    return(x)
  }
  
  # # Handle 3-way tables (which are lists of 2-way tabyls)
  # is_three_way <- is.list(x) && !is.data.frame(x)
  # if (is_three_way) {
  #   # Print each slice of the 3-way table recursively
  #   walk2(names(x), x, function(slice_name, df) {
  #     cat("### Split by:", slice_name, "\n")
  #     print(df, n_rows = n_rows, ...)
  #     cat("\n")
  #   })
  #   print(x |> janitor::adorn_title())
  #   return(invisible(x))
  # }
  
  # cat() the Crosstab metadata label first (instead of using adorn_title)
  var_names <- attr(x, "var_names")
  is_two_way <- identical(attr(x, "tabyl_type"), "two_way")
  if (is_two_way && !is.null(var_names)) {
    cat(strrep(" ", nchar(var_names$row) + 6), var_names$col, "\n")
    # cat("Crosstab:", var_names$row, "by", var_names$col, "\n\n")
  }
  
  # Format column values (to 2 sig figs, capped at 0.01% with no trailing zeros)
  pct_cols <- intersect(names(x), c("percent", "valid_percent"))
  if (length(pct_cols) > 0) {
    x <- x |> mutate(across(all_of(pct_cols), ~ fmt_pct(.x))) # .x |> signif(2) |> round(2) |> pillar::num(digits = -2)))    pillar::num(signif(.x, 2), digits = -2)))
  }
  
  # Render table lines (default print maximum of 30 lines)
  formatted <- format(x, n = n_rows, ...)
  
  # remove type line (eg <int>)
  if (length(formatted) >= 2 && grepl("<[a-zA-Z0-9_]+>", formatted[2])) {
    formatted <- formatted[-2]
  }
  
  # shaft <- pillar::new_pillar_shaft_simple(formatted, align = "left")
  # width <- pillar::get_max_extent(formatted)
  # lines <- format(shaft, width = width)
  
  writeLines(formatted)   # or print(shaft)
  invisible(x)
}

box::register_S3_method("print", "tabyl_clean", print.tabyl_clean)



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# WRAPPER FUNCTION
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tabyl2 <- function(..., extra_digits = 0, arrange = "freq") {
  
  the_call <- match.call() # the call made to this function
  
  # original tabyl
  out <- tabyl(...)
  # do this if only want tibble fmting: out |> tibble::as_tibble()
  
  # if 3-way, don't modify
  if (is.list(out) && !is.data.frame(out)) {
    attr(out, "tabyl_call") <- the_call
    class(out) <- c("tabyl_clean", class(out))
    return(out)
  }
  
  
  # 1-way / 2-way tables: Convert to clean tibble subclass
  out_tbl <- as_tibble(out)
  attributes(out_tbl) <- c(attributes(out_tbl), attributes(out)[c("core", "tabyl_type", "var_names")])
  
  # Pre-multiply percentages for 1-way tables (so math is done)
  pct_cols <- intersect(names(out_tbl), c("percent", "valid_percent"))
  if (length(pct_cols) > 0) {
    out_tbl <- out_tbl |> mutate(across(all_of(pct_cols), ~ .x * 100))
  }
  
  # arrange by freq (not alphabetically) if 1-way table
  has_n <- "n" %in% names(out_tbl)
  if (has_n & arrange == "freq") {
    out_tbl <- out_tbl |> arrange(-n)
  }
  
  
  attr(out_tbl, "extra_digits") <- extra_digits
  attr(out_tbl, "tabyl_call")   <- the_call
  class(out_tbl) <- c("tabyl_clean", "tbl_df", "tbl", class(out_tbl)) # keeps "tabyl" and tabyl/janitor structure/metadata/attributes
  
  out_tbl
}


## examples
# # library(tibble)

# tibble(a = c(rep(0, 190), rep(1, 10), rep(2, 210), rep(3, 20000), rep(4, 850), rep(5, 10))) %>%
#   {
#     . |> tabyl(a)  |> arrange(-percent) |> mutate(percent = round(100 * percent, 3)) |> print() # adorn_pct_formatting() 
#     . |> tabyl2(a) |> print()
#   }

# tibble(
#   anteater        = c(rep(1:2, 10000), rep(3, 100), rep(NA, 1)),
#   banana_hedgehog = rev(c(rep(1:2, 10000), rep(3, 100), rep(NA, 1)))
# ) %>%
#   {
#     . |> tabyl(anteater, banana_hedgehog)  |> adorn_title() |> print()
#     . |> tabyl2(anteater, banana_hedgehog) |> print()
#   }
# 
# mtcars %>%
#   {
#     . |> tabyl(gear, cyl, am)  |> adorn_title() |> print()
#     . |> tabyl2(gear, cyl, am) |> print()
#   }



# not quite perfect tho (14 not 14.0) - fix in tabyl wrapper -- tab_pretty()? use gt:: under hood?

# the_call[5] delicate...

## see claude!
# var1 == 2 like count!

# gemini helped: https://gemini.google.com/app/cca6d9b5f4edcd54
# claude too - % fmt: https://claude.ai/chat/7be08065-e0d7-4a48-9006-0ad6ad699671


